%{
	@brief: Create a regular (2D) pixel grid on which the image reconstruction could be performed
	@usage: pos = RegularGrid(pixSz, pixNum, [optCent])

	@param[out]:
	- pos: N-by-2 (number of grids) matrix.
	- optionally variable outputs are also available, please inspect the source code.
	@param[in]:
	- pixSz: pixSz = [dx, dy], grid size:
		- dx: pixel grid size, in x-direction (2D Cartesian convention);
		- dy: pixel grid size, in y-direction (2D Cartesian convention).
	- pixNum: pixNum = [nx, ny], number of grids:
		- n1: number of pixels in x-direction;
		- n2: number of pixels in y-direction.
	- optCent (optional): the center of circle, 2D vector, defaults to `[0, 0]`.

	@details:
	- This function utilizes MATLAB's built-in function `meshgrid`.
	- The order of y-axis coordinates is reversed so that it is convenient to relate image pixel index (usually starts from [1, 1] at upper-left corner) and physical coordinates (usually has horizontal x-axis pointing right and vertical y-axis pointing up).
	- The relation between the MATLAB 2-dimension array indexing and the Cartesian coordinates convention is illustrated as follow:
	``` ASCII graph
	O---> 2nd dim
	|		_|_|_|_|_|_|_|_|_|_
	|		_|_|_|_|_|_|_|_|_|_
	V		_|_|_|_|_|_|_|_|_|_
	1st-dim	_|_|_|_|_|_|_|_|_|_
			_|_|_|_|_|_|_|_|_|_
			_|_|_|_|_|_|_|_|_|_
	^		 | | | | | | | | |
	| Y-direction
	|
	O---> X-direction
	```
	- The `[x, y]` coordinates at grid center is returned.

	@author: madpang
	@date: [created: 2024-12-21, updated: 2025-08-23]
%}
function varargout = RegularGrid(pixSz, pixNum, optCent)

	% --- Minimal argument check & parsing
	narginchk(2, 3);

	if nargin < 3
		optCent = [0, 0];
	end

	% --- Main body
	xlin = ((1 : 1 : pixNum(1)) - (pixNum(1) + 1) / 2) * pixSz(1);
	ylin = ((pixNum(2) : -1 : 1) - (pixNum(2) + 1) / 2) * pixSz(2);

	[xx, yy] = meshgrid(xlin, ylin);

	pos = [xx(:), yy(:)] + optCent;

	switch nargout
		case 1
			[varargout{1}] = pos;
		case 2
			[varargout{1:2}] = deal(xlin, ylin);
		case 3
			[varargout{1:3}] = deal(pos, xlin, ylin);
	end

end
