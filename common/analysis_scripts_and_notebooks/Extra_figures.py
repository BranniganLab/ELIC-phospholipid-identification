import numpy as np
from scipy.interpolate import griddata
import matplotlib.pyplot as plt
import matplotlib as mpl
from scipy import constants
import pandas as pd
from common.analysis_scripts_and_notebooks.probabilities import mktable, logSpace, genLogProb, makeContourf, linSpace, getfAa, getpAa, make_3d_plot, plot_ternary_titration


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


# All data:
# Using a PE reference
WT_bin = mktable(PCtoPG=-6 - 2, PGtoPE=2, PEtoPC=6)
E5_bin = mktable(PCtoPG=-6 - 4, PGtoPE=6, PEtoPC=4)
WT_ter = mktable(PCtoPG=-4 - 2, PGtoPE=2, PEtoPC=4)
E5_ter = mktable(PCtoPG=-6 - 2, PGtoPE=6, PEtoPC=2)

font = {"size": 7}
mpl.rc("font", **font)
mpl.rcParams["font.sans-serif"] = "Arial"
mpl.rcParams["font.family"] = "sans-serif"


xPC, xPG, xPE = logSpace(-6, 0, 1000)  # e^-9 to e^0, 1000 steps
data = genLogProb(E5_ter, WT_ter, RT, xPC, xPG, xPE)
fig, ax = makeContourf(
    xPG, xPE, data, xmin=1e-6, log=True, cmap=conformationCMAP, vmin=-4, vmax=4
)
plt.savefig("./Figures/logloglog_pE5.pdf")


xPC, xPG, xPE = linSpace(0, 1, 1000)  # e^-9 to e^0, 1000 steps
data = genLogProb(E5_ter, WT_ter, RT, xPC, xPG, xPE)
fig, ax = makeContourf(
    xPG, xPE, data, xmin=1e-6, log=False, cmap=conformationCMAP, vmin=-4, vmax=4
)
plt.savefig("./Figures/log_pE5.pdf")



fig = make_3d_plot(xPG, xPE, data)
plt.savefig("./Figures/contour_plot.pdf")

# xPG = np.linspace(0, 1, 1000)
xPG = np.logspace(-6, 0, 100)
xPX = 1 - xPG
xPC = xPX * 2 / 3
xPE = xPX / 3

fPC = getfAa("PC", "PG", "PE", xPC, xPG, xPE, WT_ter, RT)
fPG = getfAa("PG", "PC", "PE", xPG, xPC, xPE, WT_ter, RT)
fPE = getfAa("PE", "PG", "PC", xPE, xPG, xPC, WT_ter, RT)

fig, ax = plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE)
plt.savefig("./Figures/WT_PG_Titration_Ternary.pdf")


xPX = 1 - xPG
xPC = xPX * 2 / 3
xPE = xPX / 3

fPC = getfAa("PC", "PG", "PE", xPC, xPG, xPE, E5_ter, RT)
fPG = getfAa("PG", "PC", "PE", xPG, xPC, xPE, E5_ter, RT)
fPE = getfAa("PE", "PG", "PC", xPE, xPG, xPC, E5_ter, RT)

fig, ax = plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE)
plt.savefig("./Figures/ELIC5_PG_Titration_Ternary.pdf")


xPX = 1 - xPG
xPC = xPX * 2 / 3
xPE = xPX / 3

WTfPG_ter = getfAa("PG", "PC", "PE", xPG, xPC, xPE, WT_ter, RT)
E5fPG_ter = getfAa("PG", "PC", "PE", xPG, xPC, xPE, E5_ter, RT)

xPC = 1 - xPG
WTfPG_bin = getfAa("PG", "PC", "PE", xPG, xPC, xPE, WT_bin, RT)
E5fPG_bin = getfAa("PG", "PC", "PE", xPG, xPC, xPE, E5_bin, RT)


plt.plot(xPG, E5fPG_bin, label="ELIC5 1:0:X", linestyle="-", color=colormap["E5"])
plt.plot(xPG, WTfPG_bin, label="WT 1:0:X", linestyle="-", color=colormap["WT"])
plt.plot(
    xPG,
    E5fPG_ter,
    label="ELIC5 2:1:X",
    linestyle="--",
    color=colormap["E5"],
    linewidth=2,
)
plt.plot(
    xPG, WTfPG_ter, label="WT 2:1:X", linestyle="--", color=colormap["WT"], linewidth=2
)

# plt.xlim([10**(-9), 1])
plt.legend(loc="lower right", prop={"size": 10})
plt.xscale("log")

plt.xlabel(r"$x_{PG}$")
plt.ylabel("Fraction of Sites Occupied by PG")
# plt.title('PG Titration Comparison')
# plt.xlim([1e-9, 1])

fig.set_size_inches(2.5, 2)
plt.subplots_adjust(bottom=0.25, left=0.25)
plt.xticks([1e-6, 1e-3, 1])
plt.savefig("./Figures/PG_titration.pdf")


# Generate numbers for barchart

bar_xPC = 0.5
bar_xPG = 0.25
bar_xPE = 0.25

cols = ["fPC", "fPG", "fPE"]
rows = pd.MultiIndex.from_tuples(
    [("WT", "2:1:1"), ("WT", "128:1"), ("E5", "2:1:1"), ("E5", "128:1")],
    names=["sequence", "membrane"],
)
data = pd.DataFrame(columns=cols, index=rows)

data.loc[("WT", "2:1:1"), "fPC"] = getpAa(
    "PC", "PG", "PE", bar_xPC, bar_xPG, bar_xPE, WT_ter, RT
)
data.loc[("WT", "2:1:1"), "fPG"] = getpAa(
    "PG", "PC", "PE", bar_xPG, bar_xPC, bar_xPE, WT_ter, RT
)
data.loc[("WT", "2:1:1"), "fPE"] = getpAa(
    "PE", "PG", "PC", bar_xPE, bar_xPG, bar_xPC, WT_ter, RT
)

data.loc[("E5", "2:1:1"), "fPC"] = getpAa(
    "PC", "PG", "PE", bar_xPC, bar_xPG, bar_xPE, E5_ter, RT
)
data.loc[("E5", "2:1:1"), "fPG"] = getpAa(
    "PG", "PC", "PE", bar_xPG, bar_xPC, bar_xPE, E5_ter, RT
)
data.loc[("E5", "2:1:1"), "fPE"] = getpAa(
    "PE", "PG", "PC", bar_xPE, bar_xPG, bar_xPC, E5_ter, RT
)

bar_xPC = 128 / 129
bar_xPG = 1 / 129
bar_xPE = 0
data.loc[("WT", "128:1"), "fPC"] = getpAa(
    "PC", "PG", "PE", bar_xPC, bar_xPG, bar_xPE, WT_bin, RT
)
data.loc[("WT", "128:1"), "fPG"] = getpAa(
    "PG", "PC", "PE", bar_xPG, bar_xPC, bar_xPE, WT_bin, RT
)

data.loc[("E5", "128:1"), "fPC"] = getpAa(
    "PC", "PG", "PE", bar_xPC, bar_xPG, bar_xPE, E5_bin, RT
)
data.loc[("E5", "128:1"), "fPG"] = getpAa(
    "PG", "PC", "PE", bar_xPG, bar_xPC, bar_xPE, E5_bin, RT
)
data = data.loc[:, ["fPG", "fPC", "fPE"]]
data.columns = ["PG", "PC", "PE"]




fig, (ax211, ax1281) = plt.subplots(1, 2, sharey=True)
data.loc[(slice(None), "2:1:1"), :].plot.bar(ax=ax211, stacked=True, color=colormap)
ax211.set_xticklabels(["WT", "E5"])
ax211.set_xlabel("PC:PG:PE 2:1:1")

# PG, PG, PC, PC, PE, PE
hatches = ["\\\\", "\\\\", "//", "//", "||", "||"]
bars = ax211.patches
# for bar, hatch in zip(bars, hatches):
# bar.set_hatch(hatch)


data.loc[(slice(None), "128:1"), :].plot.bar(ax=ax1281, stacked=True, color=colormap)
ax1281.set_xticklabels(["WT", "E5"])
ax1281.set_xlabel("PC:PG 128:1")

fig.set_size_inches(4.5, 7.9)

ax1281.legend(
    loc="center", prop={"size": 12}, handleheight=3, bbox_to_anchor=(1.45, 0.5)
)
ax211.get_legend().remove()

# ax1281.set_position([box.x0, box.y0, box.width * 0.9, box.height])
pos = ax1281.get_position()
width = pos.x1 - pos.x0
pos.x0 = 0.5  # for example 0.2, choose your value
pos.x1 = pos.x0 + width
ax1281.set_position(pos)


fig.tight_layout()
# fig.suptitle('Absolute Occupancy Fraction')
ax211.set_ylabel("Occupancy Fraction")
plt.subplots_adjust(bottom=0.15, left=0.25)
# ax211.semilogy()
plt.savefig("./Figures/OccupancyFraction.pdf")
