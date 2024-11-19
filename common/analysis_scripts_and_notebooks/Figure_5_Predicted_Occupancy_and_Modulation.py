import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from scipy import constants
from probabilities import (
    mktable,
    logSpace,
    genLogProb,
    getfAa,
)
from plotting import makeContourf, plot_ternary_titration

# Constants
temperature = 303.15  # Kelvin
RT = temperature * constants.R / (1000 * constants.calorie)  # kcal/mol

lw = 3
conformationCMAP = "RdBu"
colormap = {
    "PC": "#EF8354",
    "PG": "#3D3737",
    "PE": "seagreen",
    "WT": "#D14646",
    "E5": "#53A2BE",
}
font = {"size": 7}
mpl.rc("font", **font)
mpl.rcParams["font.sans-serif"] = "Arial"
mpl.rcParams["font.family"] = "sans-serif"

# All data:
# Using a PE reference
WT_bin = mktable(PCtoPG=-6 - 2, PGtoPE=2, PEtoPC=6)
E5_bin = mktable(PCtoPG=-6 - 4, PGtoPE=6, PEtoPC=4)
WT_ter = mktable(PCtoPG=-4 - 2, PGtoPE=2, PEtoPC=4)
E5_ter = mktable(PCtoPG=-6 - 2, PGtoPE=6, PEtoPC=2)


# Plot modulation heatmap
xPC, xPG, xPE = logSpace(-6, 0, 1000)
data = genLogProb(E5_ter, WT_ter, RT, xPC, xPG, xPE)
fig, ax = makeContourf(
    xPG, xPE, data, xmin=1e-6, log=True, cmap=conformationCMAP, vmin=-4, vmax=4
)
plt.savefig("./Figures/logloglog_pE5.pdf")


# Plot WT ternary titration
xPG = np.logspace(-6, 0, 100)
xPX = 1 - xPG
xPC = xPX * 2 / 3
xPE = xPX / 3

fPC = getfAa("PC", "PG", "PE", xPC, xPG, xPE, WT_ter, RT)
fPG = getfAa("PG", "PC", "PE", xPG, xPC, xPE, WT_ter, RT)
fPE = getfAa("PE", "PG", "PC", xPE, xPG, xPC, WT_ter, RT)

fig, ax = plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE)
plt.savefig("./Figures/WT_PG_Titration_Ternary.pdf")


# Plot ELIC5 ternary titration
xPX = 1 - xPG
xPC = xPX * 2 / 3
xPE = xPX / 3

fPC = getfAa("PC", "PG", "PE", xPC, xPG, xPE, E5_ter, RT)
fPG = getfAa("PG", "PC", "PE", xPG, xPC, xPE, E5_ter, RT)
fPE = getfAa("PE", "PG", "PC", xPE, xPG, xPC, E5_ter, RT)

fig, ax = plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE)
plt.savefig("./Figures/ELIC5_PG_Titration_Ternary.pdf")
