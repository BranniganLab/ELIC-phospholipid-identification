
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

def make_3d_plot(xPG, xPE, data):
    """
    Create a 3D surface plot using the provided grid and data.

    Parameters:
    xPG (2D array): Grid values for the X-axis.
    xPE (2D array): Grid values for the Y-axis.
    data (2D array): Z-axis values for the surface plot.

    Returns:
    tuple: A tuple containing the figure and 3D axes objects.
    """
    fig = plt.figure()
    ax = plt.axes(projection="3d")
    ax.plot_surface(xPG, xPE, data)
    ax.set_xlabel("PG")
    ax.set_ylabel("PE")
    ax.set_zlabel("log(E5) conformation")
    ax.set_title("3D contour")
    return fig, ax


def plot_ternary_titration(lw, colormap, xPG, fig, fPC, fPG, fPE):
    """
    Create a titration plot to visualize the fraction of sites occupied by 
    different components (PC, PG, PE) as a function of xPG using Matplotlib.

    Parameters:
    lw (int): Line width for the plot lines.
    colormap (dict): A dictionary mapping component names ("PC", "PG", "PE") 
                     to their respective colors.
    xPG (list or array): X-values representing the PG component.
    fig (matplotlib.figure.Figure): A Matplotlib figure object.
    fPC (list or array): Y-values for the PC component.
    fPG (list or array): Y-values for the PG component.
    fPE (list or array): Y-values for the PE component.

    Returns:
    tuple: A tuple containing the Matplotlib fig and ax objects, representing 
           the figure and axis of the plot.
    """
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


def makeContourf(
    xPG, xPE, data, xmin=1e-9, xmax=1, log=True, cmap="jet", vmin=-8, vmax=8
):
    """
    Create a filled contour plot using the provided data and axis ranges.

    Parameters:
    xPG (array-like): 1D array representing the x-axis values for the contour plot.
    xPE (array-like): 1D array representing the y-axis values for the contour plot.
    data (array-like): 2D array of data values to be plotted.
    xmin (float, optional): Minimum value for both x and y axes. Default is 1e-9.
    xmax (float, optional): Maximum value for both x and y axes. Default is 1.
    log (bool, optional): Whether to use logarithmic scales. Default is True.
    cmap (str, optional): Colormap for the contour plot. Default is "jet".
    vmin (int, optional): Minimum value for the color bar. Default is -8.
    vmax (int, optional): Maximum value for the color bar. Default is 8.

    Returns:
    tuple: A tuple containing the figure (fig) and axis (ax) objects for further customization or display.
    """

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
    """
    Add an arrow marker to a matplotlib axis at specified coordinates.

    Parameters:
    x (float): The x-coordinate for the arrow placement.
    y (float): The y-coordinate for the arrow placement.
    ax (matplotlib.axes.Axes): The axis object where the arrow is drawn.
    direction (str): The direction of the arrow, can be "up", "down", "left", or "right".
    log (bool): Indicates if the plot uses a logarithmic scale.

    Raises:
    Exception: If an unrecognized direction is provided.
    """
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
