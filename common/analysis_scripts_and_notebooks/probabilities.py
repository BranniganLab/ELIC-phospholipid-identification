import numpy as np
import pandas as pd

def getRelProb(alpha, beta, xa, xb, stateTable, RT):
    with np.errstate(divide="ignore"):
        prob = (xa / xb) * np.exp(-stateTable.loc[beta, alpha] / RT)

    return prob


def getpAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    pA0a = 0
    pAba = getRelProb(beta, alpha, xb, xa, stateTable, RT)
    pAga = getRelProb(gamma, alpha, xg, xa, stateTable, RT)

    pAa = 1 / (1 + pAba + pAga + pA0a)

    return pAa


# This is the same as pAa when pA0a is 0
def getfAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT):
    pAa = getpAa(alpha, beta, gamma, xa, xb, xg, stateTable, RT)
    pAb = getpAa(beta, alpha, gamma, xb, xa, xg, stateTable, RT)
    pAg = getpAa(gamma, beta, alpha, xg, xb, xa, stateTable, RT)

    fAa = pAa / (pAa + pAb + pAg)

    return fAa


def mktable(PCtoPG, PGtoPE, PEtoPC):
    data = pd.DataFrame(0, index=["PC", "PG", "PE"], columns=["PC", "PG", "PE"])
    data.loc["PC", "PG"] = PCtoPG
    data.loc["PE", "PC"] = PEtoPC
    data.loc["PG", "PE"] = PGtoPE

    data.loc["PG", "PC"] = -data.loc["PC", "PG"]
    data.loc["PC", "PE"] = -data.loc["PE", "PC"]
    data.loc["PE", "PG"] = -data.loc["PG", "PE"]

    return data


def logSpace(xmin=-9, xmax=0, N=1000):
    grid_x = np.logspace(xmin, xmax, N)

    xPG, xPE = np.meshgrid(grid_x, grid_x)  # titration grid

    xPC = np.full((N, N), 1.0) - (xPG + xPE)  # PC+PG+PE=1
    mask = xPC < 0
    xPG = np.where(~mask, xPG, np.nan)
    xPE = np.where(~mask, xPE, np.nan)

    return xPC, xPG, xPE


def linSpace(xmin=0, xmax=1, N=1000):
    grid_x = np.linspace(xmin, xmax, N)

    xPG, xPE = np.meshgrid(grid_x, grid_x)  # titration grid

    xPC = np.full((N, N), 1.0) - (xPG + xPE)  # PC+PG+PE=1
    mask = xPC < 0
    xPG = np.where(~mask, xPG, np.nan)
    xPE = np.where(~mask, xPE, np.nan)

    return xPC, xPG, xPE


def genLogProb(E5, WT, RT, xPC, xPG, xPE):
    # Boltzmann weights
    KCG5 = np.exp(-E5.loc["PC", "PG"] / RT)
    KCGWT = np.exp(-WT.loc["PC", "PG"] / RT)
    KCE5 = np.exp(-E5.loc["PC", "PE"] / RT)
    KCEWT = np.exp(-WT.loc["PC", "PE"] / RT)

    data = (xPC + KCG5 * xPG + KCE5 * xPE) / (xPC + KCGWT * xPG + KCEWT * xPE)
    data = np.log(data)
    # data=np.where(mask, data, np.nan)

    return data
