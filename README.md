# points2axes

**points2axes** calculates the conversion factors between points and axis units along the three Cartesian axes.

## Purpose

The conversion factors are useful for placing objects in a 2D or 3D coordinate system whose characteristic dimensions such as width, length, height, diameter, etc. are best expressed in points.

Note that changing the size of the figure window or the limits, orientation, or aspect ratio of the axes directly affects the conversion factors. It is therefore recommended to set the axis limits before calling **points2axes** to prevent them from changing when new objects are added.

## Usage

`[xppt, yppt, zppt] = points2axes(ax)` calculates the conversion factors between points and axis units along the three Cartesian axes. `xppt` is the number of x axis units that corresponds to a length of 1 point on the screen. Similarly, `yppt` and `zppt` are the y and z axis units per point, respectively. `ax` is an optional axes handle, which defaults to the current axes if `points2xes` is called without an argument.

Example:

```matlab
% create figure and axes
figure; ax = axes; ax.Clipping = 'off';
xlim([-1 1]); ylim([-2 2]); zlim([-3 3]);   % set axis limits
view(3); daspect([3 5 2]);                  % set 3D view and data aspect ratio

% calculate conversion factors
[xppt,yppt,zppt] = points2axes(ax);

% place lines in coordinate system using point units
line(ax, [-20*xppt 20*xppt], [0 0], [0 0]);
line(ax, [0 0], [-20*yppt 20*yppt], [0 0]);
line(ax, [0 0], [0 0], [-20*zppt 20*zppt]);
```
This creates three 40 point long lines in the center of a 3D plot.

## Requirements

**points2axes** has been tested on MATLAB R2021a.

## Feedback

Any feedback or suggestions for improvement are appreciated!
