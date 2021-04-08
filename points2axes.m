function [xppt, yppt, zppt] = points2axes(varargin)
%POINTS2AXES Conversion factors between points and axis units.
%   [XPPT, YPPT, ZPPT] = POINTS2AXES(AX) calculates the conversion factors
%   between points and axis units along the three Cartesian axes. XPPT is
%   the number of x axis units that corresponds to a length of 1 point on
%   the screen. Similarly, YPPT and ZPPT are the y and z axis units per
%   point, respectively. AX is an optional axes handle, which defaults to
%   the current axes if POINTS2AXES is called without an argument.
%
%   The conversion factors are useful for placing objects in a 2D or 3D
%   coordinate system whose characteristic dimensions such as width,
%   length, height, diameter, etc. are best expressed in points. Note that
%   changing the size of the figure window or the limits, orientation, or
%   aspect ratio of the axes directly affects the conversion factors. It is
%   therefore recommended to set the axis limits before calling POINTS2AXES
%   to prevent them from changing when new objects are added.
%
%   Conversion factors can only be calculated if the (default)
%   stretch-to-fill feature of the axes is disabled, for example by setting
%   DASPECT.
%
%   Logarithmic plots of any kind are not supported.
%
%   The conversion factors for perspective projections are
%   position-dependent; in this case, a warning is issued and the
%   conversion factors for orthographic projections are returned, which
%   gives reasonable results for most applications.
%
%Example:
%
%   figure; ax = axes; ax.Clipping = 'off';
%   xlim([-1 1]); ylim([-2 2]); zlim([-3 3]);
%   view(3); daspect([3 5 2]);
%   [xppt,yppt,zppt] = points2axes(ax);
%   line(ax, [-20*xppt 20*xppt], [0 0], [0 0]);
%   line(ax, [0 0], [-20*yppt 20*yppt], [0 0]);
%   line(ax, [0 0], [0 0], [-20*zppt 20*zppt]);
%
%This creates three 40 point long lines in the center of a 3D plot.
%
% Created 2021-04-04 by Jorg C. Woehl

ax = gca;
if (nargin==1)
    ax = varargin{1};
    if ~isa(ax, 'matlab.graphics.axis.Axes')
        error('points2axes:IncorrectInputType',...
            ['Input 1 must be an axis handle, not "' class(ax) '".']);
    end
end
if (nargin>1)
    warning('points2axes:TooManyInputs',...
        'This function accepts only one input; other inputs are ignored.');
end

% Projection
if strcmp(ax.Projection, 'perspective')
    % perspective projection
    warning('points2axes:Projection',...
        'Perspective projection; will return orthographic projection conversion factors.');
end

% logarithmic plots
if strcmp(ax.XScale, 'log') || strcmp(ax.XScale, 'log') || strcmp(ax.XScale, 'log')
    error('points2axes:LogPlotsUnsupported',...
        'Log plots are not supported.');
end

% coordinate ranges
xRange = diff(ax.XLim);
yRange = diff(ax.YLim);
zRange = diff(ax.ZLim);
% data aspect ratio and camera-up vector
d = ax.DataAspectRatio;
camUp = ax.CameraUpVector;
% edges of the axes "box" plus camera-up vector, expressed in equal length "units"
x = [0 xRange xRange 0      0      xRange xRange 0      camUp(1)] / d(1);
y = [0 0      yRange yRange 0      0      yRange yRange camUp(2)] / d(2);
z = [0 0      0      0      zRange zRange zRange zRange camUp(3)] / d(3);
% indices corresponding to pure axis vectors
xIdx = 2;   % x axis
yIdx = 4;   % y axis
zIdx = 5;   % z axis

% create four-dimensional column vectors (x,y,z,1)
n = size(x, 2);
v4d = [x; y; z; ones(1, n)];

% projection matrix (orthographic projection)
A = viewmtx(ax.View(1), ax.View(2));

% project vectors onto viewing surface (x'y')
v2d = A * v4d;

% x' and y' coordinates of camUp vector
upXPrime = v2d(1, end);
upYPrime = v2d(2, end);
% strip out camera-up vector
v2d = v2d(1:2, 1:end-1);

% rotate axes box so that camera-up vector points upward
upAngle = atan2(upYPrime, upXPrime);
rotAngle = pi/2 - upAngle;          % rotation angle
sine = sin(rotAngle);
cose = cos(rotAngle);
rotM = [cose, -sine; sine, cose];   % rotation matrix
v2d = rotM * v2d;
% separate rotated axes box into x' and y' coordinates
xPrime = v2d(1, :);
yPrime = v2d(2, :);

% conversion from points to data units
axU = ax.Units;         % restore point for axes units
ax.Units = 'points';    % express Position in points
pointsPerXPrime = ax.Position(3) / (max(xPrime)-min(xPrime));
pointsPerYPrime = ax.Position(4) / (max(yPrime)-min(yPrime));
pointsPerPrime = min(pointsPerXPrime, pointsPerYPrime);
xppt = xRange / (pointsPerPrime * sqrt(xPrime(xIdx)^2 + yPrime(xIdx)^2));
yppt = yRange / (pointsPerPrime * sqrt(xPrime(yIdx)^2 + yPrime(yIdx)^2));
zppt = zRange / (pointsPerPrime * sqrt(xPrime(zIdx)^2 + yPrime(zIdx)^2));
ax.Units = axU;         % restore axes units
end