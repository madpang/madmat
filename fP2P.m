%{
	@brief: Compute the distances between any point in set P1 and any other point in set P2.
	@usage: dist = fP2P(P1, P2)

	@param[out]:
	- dist, a N1-by-N2 matrix, w/ each ij be the distance from P1(:, i) to P2(:, j).
	@param[in]:
	- P1, a dim-by-N1 matrix, each column be a vector for a point in set P1.
	- P2, a dim-by-N2 matrix, each column be a vector for a point in set P2.

	@note:
	- This function expects *column first* matrix.
	- There is NO argument check w/ the assumption that the user should know what he/she is doing.

	@author: madpang
	@date: [created: 2024-12-21, updated: 2025-08-23]
%}
function dist = fP2P(P1, P2)

	% @note: Implicit dimension expansion is incurred.
	dist = sqrt(dot(P1, P1, 1).' + dot(P2, P2, 1) - 2 * (P1.' * P2));

end
