function [pb, tb] = generate_pt_local(mesh_config, basis_type, p, t)
% basis_type =
%   101: 1D linear nodal basis
%   102: 1D quadratic nodal basis
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	h = mesh_config.h;
	n = (xr - xl) / h;
	if basis_type == 101
		pb = p; tb = t;
	elseif basis_type == 102
		pb = p(1) : ((p(2) - p(1)) / 2) : p(end);
		n = length(p) - 1;
		tb = [1:2:(2 * n - 1); 3:2:(2 * n + 1); 2:2:(2*n)];
	else
		warning('No implementation.');
	end
end