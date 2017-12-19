function [p, t, pb, tb] = generate_pt(mesh_config, basis_type)
% basis_type =
%   101: 1D linear nodal basis
%   102: 1D quadratic nodal basis
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	h = mesh_config.h;
	n = (xr - xl) / h;
	p = xl : h : xr;
	t = [1 : n; 2 : (n + 1)];
	if basis_type == 101
		pb = P; tb = T;
	elseif basis_type == 102
		pb = P(1) : ((P(2) - P(1)) / 2) : P(end);
		n = length(P) - 1;
		tb = [1:2:(2 * n - 1); 3:2:(2 * n + 1); 2:2:(2*n)];
	else
		warning('No implementation.');
	end
end