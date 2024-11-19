import numpy as np
import pandas as pd

def getRelProb(alpha, beta, xa, xb, stateTable, RT):
    """
    Calculate the relative site occupancy probability using the given parameters.

    This function computes a relative probability based on the formula:
    (xa / xb) * exp(-stateTable.loc[beta, alpha] / RT). It suppresses
    divide-by-zero warnings using numpy's error state management.

    Parameters:
    alpha (str): A key to access the state table.
    beta (str): Another key to access the state table.
    xa (float): A numeric value used in the probability calculation.
    xb (float): A numeric value used in the probability calculation.
    stateTable (pd.DataFrame): A pandas DataFrame containing state values.
    RT (float): A numeric value representing a constant in the formula.

    Returns:
    float: The calculated relative probability.
    """
    with np.errstate(divide="ignore"):
        prob = (xa / xb) * np.exp(-stateTable.loc[beta, alpha] / RT)

    return prob


def getpAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    """
    Calculate the probability of a site in state A being occupied by lipid-'a' (pAa)
    based on relative probabilities derived from the inputs using the getRelProb function.

    Parameters:
    alpha (str): A key to access the state table.
    beta (str): Another key to access the state table.
    gamma (str): A third key to access the state table.
    xa (float): A numeric value used in the probability calculation.
    xb (float): A numeric value used in the probability calculation.
    xg (float): A numeric value used in the probability calculation.
    stateTable (DataFrame): A pandas DataFrame containing state values.
    RT (float): A numeric value representing a constant in the formula.

    Returns:
    float: The calculated probability pAa.
    """
    pA0a = 0
    pAba = getRelProb(beta, alpha, xb, xa, stateTable, RT)
    pAga = getRelProb(gamma, alpha, xg, xa, stateTable, RT)

    pAa = 1 / (1 + pAba + pAga + pA0a)

    return pAa


# This is the same as pAa when pA0a is 0
def getfAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    """
    Calculate the normalized probability of state A being bound to lipid-'a' (fAa).

    This function computes the probability fAa by first calculating three 
    intermediate probabilities (pAa, pAb, pAg) using the getpAa function. 
    It then normalizes pAa by the sum of these probabilities.

    Parameters:
    alpha (str): A string key to access the state table.
    beta (str): A string key to access the state table.
    gamma (str): A string key to access the state table.
    xa (float): A float used in probability calculation.
    xb (float): A float used in probability calculation.
    xg (float): A float used in probability calculation.
    stateTable (pandas.DataFrame): A DataFrame containing state values.
    RT (float): A constant used in the formula.

    Returns:
    float: The normalized probability fAa.
    """
    pAa = getpAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT)
    pAb = getpAa(beta, alpha, gamma, xb, xa, xg, stateTable, RT)
    pAg = getpAa(gamma, beta, alpha, xg, xb, xa, stateTable, RT)

    fAa = pAa / (pAa + pAb + pAg)

    return fAa
def read_tables(fname, reference="PE"):
    full_table = pd.read_csv(fname, index_col=[0])
    if reference=='PE':
        WT_ter = use_PE_reference(full_table, 'WT')
        E5_ter = use_PE_reference(full_table, 'E5')
    else:
        raise NotImplementedError("Other references not implemented. Only reference PE.")
    return WT_ter,E5_ter

def use_PE_reference(full_table, state):
    PG_PE = full_table.loc[state].query("mixture=='ternary' & frm=='PG' & to=='PE'").iloc[0].loc['dG']
    PE_PC = full_table.loc[state].query("mixture=='ternary' & frm=='PE' & to=='PC'").iloc[0].loc['dG']
    ternary = mktable(PCtoPG=-PG_PE - PE_PC,
                    PGtoPE=PG_PE,
                    PEtoPC=PE_PC)
    return ternary

def mktable(PCtoPG, PGtoPE, PEtoPC):
    """
    Create a 3x3 pandas DataFrame representing a transition table between three states: PC, PG, and PE.
    
    The table is initialized with zeros and populated with the provided transition values, ensuring that
    the transitions are symmetric with opposite signs.
    
    Parameters:
    PCtoPG (int or float): Transition value from PC to PG.
    PGtoPE (int or float): Transition value from PG to PE.
    PEtoPC (int or float): Transition value from PE to PC.
    
    Returns:
    pandas.DataFrame: A DataFrame representing the transition table with specified and symmetric transition values.
    """
    data = pd.DataFrame(0, index=["PC", "PG", "PE"], columns=["PC", "PG", "PE"])
    data.loc["PC", "PG"] = PCtoPG
    data.loc["PE", "PC"] = PEtoPC
    data.loc["PG", "PE"] = PGtoPE

    data.loc["PG", "PC"] = -data.loc["PC", "PG"]
    data.loc["PC", "PE"] = -data.loc["PE", "PC"]
    data.loc["PE", "PG"] = -data.loc["PG", "PE"]

    return data


def logSpace(xmin=-9, xmax=0, N=1000):
    """
    Generates a logarithmically spaced grid and computes a titration grid.

    This function creates a logarithmic space between `xmin` and `xmax` with `N` points,
    then constructs a mesh grid for titration calculations. It ensures that the sum of
    the components `xPC`, `xPG`, and `xPE` equals 1, and masks invalid values where this
    condition is not met.

    Parameters:
    xmin (int): The minimum exponent for the logarithmic space (default is -9).
    xmax (int): The maximum exponent for the logarithmic space (default is 0).
    N (int): The number of points in the logarithmic space (default is 1000).

    Returns:
    tuple: A tuple containing three matrices:
        - xPC: A matrix representing the remaining component after subtracting `xPG` and `xPE` from 1.
        - xPG: A matrix representing one component of the titration grid.
        - xPE: A matrix representing another component of the titration grid.
    """
    grid_x = np.logspace(xmin, xmax, N)

    xPG, xPE = np.meshgrid(grid_x, grid_x)  # titration grid

    xPC = np.full((N, N), 1.0) - (xPG + xPE)  # PC+PG+PE=1
    mask = xPC < 0
    xPG = np.where(~mask, xPG, np.nan)
    xPE = np.where(~mask, xPE, np.nan)

    return xPC, xPG, xPE


def linSpace(xmin=0, xmax=1, N=1000):
    """
    Generate a 2D grid of values for three variables, xPC, xPG, and xPE, 
    based on a linear space between xmin and xmax. The function ensures 
    that the sum of xPG and xPE does not exceed 1 by setting invalid 
    entries to NaN.

    Parameters:
    xmin (float): The minimum value of the linear space (default is 0).
    xmax (float): The maximum value of the linear space (default is 1).
    N (int): The number of points in the linear space (default is 1000).

    Returns:
    tuple: A tuple containing three 2D arrays:
        - xPC: Represents the remaining part of the sum to 1.
        - xPG: Grid values, with invalid entries set to NaN.
        - xPE: Grid values, with invalid entries set to NaN.
    """
    grid_x = np.linspace(xmin, xmax, N)

    xPG, xPE = np.meshgrid(grid_x, grid_x)  # titration grid

    xPC = np.full((N, N), 1.0) - (xPG + xPE)  # PC+PG+PE=1
    mask = xPC < 0
    xPG = np.where(~mask, xPG, np.nan)
    xPE = np.where(~mask, xPE, np.nan)

    return xPC, xPG, xPE


def genLogProb(E5, WT, RT, xPC, xPG, xPE):
    """
    Calculate the logarithm of a ratio of weighted sums using Boltzmann weights.

    This function computes Boltzmann weights from energy matrices `E5` and `WT`, 
    and uses these weights to calculate a weighted sum of the inputs `xPC`, `xPG`, 
    and `xPE`. It then computes the ratio of these weighted sums for the E5 and WT 
    states, takes the natural logarithm of this ratio, and returns the result.

    Parameters:
    E5 (DataFrame): Energy values for the E5 state.
    WT (DataFrame): Energy values for the WT state.
    RT (float): Product of the gas constant and temperature.
    xPC (float): Concentration or probability for state PC.
    xPG (float): Concentration or probability for state PG.
    xPE (float): Concentration or probability for state PE.

    Returns:
    float: The logarithm of the ratio of weighted sums.
    """
    # Boltzmann weights
    KCG5 = np.exp(-E5.loc["PC", "PG"] / RT)
    KCGWT = np.exp(-WT.loc["PC", "PG"] / RT)
    KCE5 = np.exp(-E5.loc["PC", "PE"] / RT)
    KCEWT = np.exp(-WT.loc["PC", "PE"] / RT)

    data = (xPC + KCG5 * xPG + KCE5 * xPE) / (xPC + KCGWT * xPG + KCEWT * xPE)
    data = np.log(data)
    # data=np.where(mask, data, np.nan)

    return data
