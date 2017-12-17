function [ret] = generate_basis_nums(basis_type)
% basis_type =
%   101: 1D linear nodal basis
%   102: 1D quadratic nodal basis
%   201: 2D linear nodal basis
% todo  202: 2D quadratic nodal basis
% todo
	if basis_type == 101
		ret = 2;
	elseif basis_type == 102
		ret = 3;
	elseif basis_type == 201
		ret = 3;
	else
		% todo
		ret = 0;
	end
end