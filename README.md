[![View points2axes on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/90012-points2axes)

# points2axes

**points2axes** calculates the conversion factors between points and axis units along the three Cartesian axes.

## Purpose

The conversion factors are useful for drawing objects whose characteristic dimensions such as width, length, height, diameter, etc. are best expressed in points, where 1 point = 1/72 of an inch.

Note that changing the size of the figure window or the limits, orientation, or aspect ratio of the axes directly affects the conversion factors. It is therefore recommended to set the axis limits before calling **points2axes** to prevent them from changing when new objects are added.

## Usage

`[xppt, yppt, zppt] = points2axes` calculates the conversion factors between points and axis units along the three Cartesian axes for the current axes. `xppt` is the number of x axis units that corresponds to a length of 1 point on the screen. Similarly, `yppt` and `zppt` are the number of y and z axis units per point, respectively. 

`[xppt, yppt, zppt] = points2axes(ax)` calculates the conversion factors for the axes specified by `ax` instead of the current axes.

## Limitations

Logarithmic plots of any kind are not supported.

The conversion factors for perspective projections are position-dependent and therefore do not have unique values. In this case, the conversion factors for the corresponding orthographic projection are returned, which gives sensible results in most cases, and a warning is issued.

## Example

```matlab
% create figure and axes
figure; ax = axes; ax.Clipping = 'off';
xlim([-1 1]); ylim([-2 2]); zlim([-3 3]);   % set axis limits
view(3); daspect([2 3 5]);                  % set 3D view and data aspect ratio

% calculate conversion factors
[xppt,yppt,zppt] = points2axes;

% draw lines that are 40 points in length
line([-20*xppt 20*xppt], [0 0], [0 0]);
line([0 0], [-20*yppt 20*yppt], [0 0]);
line([0 0], [0 0], [-20*zppt 20*zppt]);
```
This creates three 40 point long lines in the center of a 3D plot.

![example-image](https://github.com/JorgWoehl/points2axes/blob/main/assets/example.png)

## Requirements

**points2axes** has been tested on MATLAB R2021a.

## Feedback

Any feedback or suggestions for improvement are welcome!