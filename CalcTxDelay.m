%{
	@brief: Generate transmission time-delay parameters for different TX strategies (plane wave, focused, or virtual source).
	@usage: [dVec, baseline] = CalcTxDelay(elePos, focus, c, mo)

	@param[out]:
	- dVec: a column vector of channel delay, with length equal to size(elePos, 2), in unit second.
	- baseline (optional): a scalar, the "baseline distance" for each mode, in unit second.
	@param[in]:
	- elePos: 2-by-N matrix, position of transducer elements.
	- focus: 2-by-1 column vector, the position of the focus/virtual-source, or the normal vector of the plane wave.
	- c: scalar, sound speed (just scales the distance by 1/c).
	- mo: mode, string, 'P' for plane wave, 'V' for virtual source, 'F' for focused.

	@details:
	- For plane wave ('P'): calculates projection distances onto the wave front normal.
	- For virtual source ('V'): calculates distances to virtual source point, closest element excites first.
	- For focused TX ('F'): calculates distances to focus point, farthest element excites first.

	@author: madpang
	@date: [created: 2019-01-24, updated: 2019-10-03]
%}

function [dVec, varargout] = CalcTxDelay(elePos, focus, c, mo)

	% --- Minimal argument check & parsing
	nargoutchk(1, 2);
	
	switch mo
		case 'P'
			% Calculate distance from all points to the front-line of plane wave.    
			proj = elePos' * focus / norm(focus);
			% Align plane to first element.
			baseline = min(proj);
			dist = proj - baseline;
			% Form delay vector, in terms of number of samples.
			dVec = dist / c;

		case 'V'
			% Calculate distance from all elements to the virtual source point.
			dist = fP2P(elePos, focus);
			% Element closest to the virtual source excite first
			baseline = min(dist);
			dist = dist - baseline;
			% Form delay vector, in terms of number of samples.
			dVec = dist / c;
			
		case 'F'
			% Calculate distance from all elements to the focus source point.
			dist = fP2P(elePos, focus);
			% Element farest to the focusing point excite first
			baseline = max(dist);
			dist = baseline - dist;
			% Form delay vector, in terms of number of samples.
			dVec = dist / c;

		otherwise
			error('Mode %s is invalid!', mo);
	end

	if nargout > 1
		varargout{1} = baseline / c;
	end

end
