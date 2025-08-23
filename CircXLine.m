%{
	@brief: Calculate Line-Circle intersections.
	@usage: [intG1, intG2, intLen, len] = CircXLine(eP1, eP2, cent, r, [mo])

	@param[out]:
	- 1 output case: intLen, intersection length;
	- 2 output case: [intG1, intG2], coordinates of the intersection points, 2 per circle;
	- 3 output case: [intG1, intG2, intLen];
	- 4 output case: [intG1, intG2, intLen, len], 
		- intG1: "entering" point, dim-by-N0-by-N1-by-N2;
		- intG2: "leaving" point, dim-by-N0-by-N1-by-N2;
		- intLen: intersection length, 1-by-N0-by-N1-by-N2;
		- len: point to point distance, 1-by-1-by-N1-by-N2.
	@param[in]:
	- eP1: one of the endpoints of the line segment(s), dim-by-N1 matrix.
	- eP2: another endpoint of the line segment(s), dim-by-N2 matrix.
	- cent: center of the circle/sphere, dim-by-N0.
	- r: radius of the circle/sphere, 1-by-N0 array.
	- mo (Optional): mode, 'line'||'segment', to specify whether line or line segment is under consideration.

	@details:
	- Line is represented parametrically, as `p = p0 + t * vec_n`, and intersection is calculated by inserting the expression of line into `||p - cent||^2 = r^2`
	- This function depends on fP2P.m

	@author: madpang
	@date: [created: 2024-12-21, updated: 2025-08-23]
%}
function varargout = CircXLine(eP1, eP2, cent, r, varargin)

	% --- Minimal argument check & parsing
	narginchk(4, 5);
	nargoutchk(1, 4);

	if length(varargin) >= 1
		mo = varargin{1};
	else
		mo = 'line';
	end

	[dim, N0] = size(cent);
	[~, N1] = size(eP1);
	[~, N2] = size(eP2);

	tol = eps('single');

	% Line segment length (N1-by-N2 matrix)
	len = reshape(fP2P(eP1, eP2), [1, 1, N1, N2]); % 1-1-N1-N2

	% Safety check, if there is an overlapping between eP1 set and eP2 set
	if any(len < tol, 'all')
		warning('Bad point sets, overlapping detected!');
	end

	% --- Main body

	% Dimension expansion
	eP1 = reshape(eP1, [dim, 1, N1, 1]);
	eP2 = reshape(eP2, [dim, 1, 1, N2]);

	% Unit direction vector (eP1 -> eP2)
	n = (eP2 - eP1) ./ len; % dim-1-N1-N2
	co = eP1 - cent; % dim-N0-N1-1

	% Vector from line segment endpoint to center of circle/sphere
	var1 = dot(repmat(n, [1, N0, 1, 1]), repmat(co, [1, 1, 1, N2])); % 1-N0-N1-N2
	var2 = dot(co, co, 1); % 1-N0-N1-1

	% Discriminant of intersection, three cases:
	% 1. No intersection: dmt < 0
	% 2. Tangent: dmt == 0
	% 3. Cross: dmt > 0
	dmt = var1.^2 - var2 + r.^2; % 1-N0-N1-N2 (r -- 1-N0)
	dmt(dmt < 0) = NaN;
	t = -var1 + sqrt(dmt) .* ([-1, 1].');
	% Intersection length calculation (if required)
	if nargout ~= 2
		par = zeros(1, N0, N1, N2);
		switch mo
			case 'line'				
				par = diff(t, 1, 1);
				par(isnan(par)) = 0;				
			case 'segment'
				metric = cat(1, ...
					t >= 0, ...
					t <= len ...
				);
				t1 = t(1, :, :, :);
				t2 = t(2, :, :, :);	
				ll = repmat(len, [1, N0, 1, 1]);		
				i4 = ~any(metric - ([1, 1, 1, 0].'), 1);
				par(i4) = ll(i4) - t1(i4);
				i5 = ~any(metric - ([0, 1, 1, 1].'), 1);
				par(i5) = t2(i5);
				i6 = ~any(metric - ([0, 1, 1, 0].'), 1);
				par(i6) = ll(i6);
				i7 = ~any(metric - ([1, 1, 1, 1].'), 1);
				par(i7) = t2(i7) - t1(i7);
			otherwise
				error('Invalid mode!');
		end
	end

	% Intersection points calculation (if required)
	if nargout ~= 1
		% Handle the line segment case (further constrain via mask)
		if strcmp(mo, 'segment')
			t(t < -tol | (t - len) > tol) = NaN;
		end
		
		intG1 = eP1 + t(1, :, :, :) .* n;
		intG2 = eP1 + t(2, :, :, :) .* n;
		
	end

	% Assemble the output
	switch nargout
		case 1
			[varargout{1}] = par;
		case 2
			[varargout{1:2}] = deal(intG1, intG2);
		case 3
			[varargout{1:3}] = deal(intG1, intG2, par);
		case 4
			[varargout{1:4}] = deal(intG1, intG2, par, len);
	end

end
