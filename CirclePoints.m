%{
	@brief: MATLAB implementation of the Mathematica built-in function `CirclePoints`.
	@usage: pos = CirclePoints(R, eleNum, [optAng], [optCent])

	@param[out]:
	- pos: a N-by-2 matrix, each *row* corresponds to the position (x, y) of one point on the circle.
	@param[in]:
	- r: radius of circle, scalar.
	- eleNum: number of elements, scalar, integer.
	- optAng (optional): the starting angle, scalar, defaults to -pi.
	- optCent (optional): the center of circle, 2D vector, defaults to `[0, 0]`.

	@details:
	- It generates the positions of eleNum points equally spaced around a circle.
	- It assumes right-hand Cartesian coordinates.

	@author: madpang
	@date: [created: 2024-12-21, updated: 2025-08-23]
%}
function pos = CirclePoints(r, eleNum, optAng, optCent)

	% --- Minimal argument check & parsing
	narginchk(2, 4);

	if nargin < 4
		optCent = [0, 0];
	end
	if nargin < 3
		optAng = -pi;
	end

	% --- Main body
	ang = optAng + (0 : 1 : eleNum - 1) * 2 * pi/eleNum;

	xPts = r .* cos(ang);
	yPts = r .* sin(ang);

	pos = [xPts.', yPts.'] + optCent;

end
