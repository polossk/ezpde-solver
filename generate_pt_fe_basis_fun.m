function [pb, tb] = generate_pt_fe_basis_fun(P, T, basis_type)
% basis_type =
%   101: 1D linear nodal basis
%   102: 1D quadratic nodal basis
	if basis_type == 101
		pb = P; tb = T;
	elseif basis_type == 102
		pb = P(1) : ((P(2) - P(1)) / 2) : P(end);
		n = length(P) - 1;
		tb = [1:2:(2 * n - 1); 3:2:(2 * n + 1); 2:2:(2*n)];
	else
		% todo
		pb = P; tb = T;
	end

end