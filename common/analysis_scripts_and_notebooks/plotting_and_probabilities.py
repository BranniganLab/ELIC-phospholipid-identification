import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
def make_3d_plot(xPG, xPE, data):
    fig = plt.figure()
    ax = plt.axes(projection="3d")
    ax.plot_surface(xPG, xPE, data)
    ax.set_xlabel("PG")
    ax.set_ylabel("PE")
    ax.set_zlabel("log(E5) conformation")
    ax.set_title("3D contour")
    return fig
def getRelProb(alpha, beta, xa, xb, stateTable, RT):
    with np.errstate(divide="ignore"):
        prob = (xa / xb) * np.exp(-stateTable.loc[beta, alpha] / RT)

    return prob
def plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE):
    font = {"size": 20}
    mpl.rc("font", **font)
    fig, ax = plt.subplots()
    ax.plot(xPG, fPC, label="PC", color=colormap["PC"], linewidth=lw)
    ax.plot(xPG, fPG, label="PG", color=colormap["PG"], linewidth=lw)
    ax.plot(xPG, fPE, label="PE", color=colormap["PE"], linewidth=lw)

    ax.set_xlabel(r"$x_{PG}$")
    ax.set_ylabel("Fraction of Sites Occupied")

    ax.legend(loc="center left")
    ax.set_xscale("log")
    fig.set_size_inches(2.5, 2)
    fig.subplots_adjust(bottom=0.25, left=0.25)
    ax.set_xticks([1e-6, 1e-3, 1])

    return fig, ax

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




def makeContourf(
    xPG, xPE, data, xmin=1e-9, xmax=1, log=True, cmap="jet", vmin=-8, vmax=8
):


    fig, ax = plt.subplots()

    step = 0.1
    levels = np.arange(-4, 4 + step, step)

    cf = ax.contourf(xPG, xPE, data, levels=levels, cmap=cmap)

    ax.set_xlabel(r"$x_{PG}$")
    ax.set_ylabel(r"$x_{PE}$")
    # ax.title.set_text("Relative log-probability of ELIC5 conformation")
    # ax.legend(bbox_to_anchor=(1.45,0.5))

    if log:
        ax.set_xscale("log")
        ax.set_yscale("log")
        arrowWidth = 5
        arrowLength = 0.1
    else:
        arrowWidth = 5
        arrowLength = 0.2

    ax.set_xlim([xmin, xmax])
    ax.set_ylim([xmin, xmax])

    addArrow(0.25, 0.25, ax, "up", log)
    addArrow(0.25, xmin, ax, "down", log)
    addArrow(1 / 60, xmin, ax, "down", log)
    addArrow(xmin, 1 / 60, ax, "left", log)

    pos = ax.get_position()

    cb = fig.colorbar(cf, ax=ax, ticks=np.arange(vmin, vmax + 1, 2))
    # cbar.ax.set_yticklabels(['< -1', '0', '> 1'])  # vertically oriented colorbar
    for t in cb.ax.get_yticklabels():
        t.set_horizontalalignment("right")
        t.set_x(4)

    plt.xticks([1e-6, 1e-3, 1])
    plt.yticks([1e-6, 1e-3, 1])

    fig.set_size_inches(5, 4)
    plt.subplots_adjust(bottom=0.25, left=0.25)
    ax.set_aspect("equal")
    return fig, ax


def addArrow(x, y, ax, direction, log):
    headSize = 70
    lineSize = 70
    lineWidth = 3
    if log == True:
        if direction in ["up", "down"]:
            xoffset = 1.001
            yoffset = 0.7
        else:
            xoffset = 0.7
            yoffset = 1.001

        xup = x * xoffset
        xdown = x / xoffset

        yup = y * yoffset
        ydown = y / yoffset
    else:
        if direction in ["up", "down"]:
            xoffset = 0
            yoffset = 0.02
        else:
            xoffset = 0.02
            yoffset = 0

        xup = x - xoffset
        xdown = x + xoffset

        yup = y - yoffset
        ydown = y + yoffset

    if direction == "up":
        ax.scatter(
            x, y, marker=mpl.markers.CARETUP, color="w", s=headSize, linewidths=0
        )
        ax.scatter(
            xup,
            yup,
            marker=mpl.markers.TICKDOWN,
            color="w",
            s=lineSize,
            linewidths=lineWidth,
        )
    elif direction == "down":
        ax.scatter(
            x, y, marker=mpl.markers.CARETDOWN, color="w", s=headSize, linewidths=0
        )
        ax.scatter(
            xdown,
            ydown,
            marker=mpl.markers.TICKUP,
            color="w",
            s=lineSize,
            linewidths=lineWidth,
        )
    elif direction == "left":
        ax.scatter(
            x, y, marker=mpl.markers.CARETLEFT, color="w", s=headSize, linewidths=0
        )
        ax.scatter(
            xdown,
            ydown,
            marker=mpl.markers.TICKRIGHT,
            color="w",
            s=lineSize,
            linewidths=lineWidth,
        )
    elif direction == "right":
        ax.scatter(
            x, y, marker=mpl.markers.CARETRIGHT, color="w", s=headSize, linewidths=0
        )
        ax.scatter(
            xup,
            yup,
            marker=mpl.markers.TICKLEFT,
            color="w",
            s=lineSize,
            linewidths=lineWidth,
        )
    else:
        print(f"ERROR: direction {direction} not recognized")
        raise




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