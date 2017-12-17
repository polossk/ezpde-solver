function [boundary] = generate_boundary( boundary, mesh )
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	yl = mesh_config.yl;
	yr = mesh_config.yr;
	hx = mesh_config.hx;
	hy = mesh_config.hy;
	nx = (xr - xl) / hx;
	ny = (yr - yl) / hy;
	npx = nx + 1; npy = ny + 1;
	% triangular: square-based triangle mesh
	% D --- C
	% | \ 2 |
	% |  \  |
	% | 1 \ |
	% A --- B
	% rectangular: square-liked mesh
	% D --- C
	% |     |
	% |  1  |
	% |     |
	% A --- B
	if strcmp(mesh_config.type, 'triangular')
		len = 2 * (nx + ny);
		boundary.edges = zeros(4, len);
		boundary.edges(1, :) = boundary.types;
		e1 = 1 : 2 * npy : 2 * (npx - 1) * npy + 1;
		e2 = 2 + 2 * (npx - 1) * npy : 2 : 2 * npx * npy;
		e3 = 2 * npx * npy : -2 * npy : 2 * npy;
		e4 = 2 * npy - 1 : -2 : 1;
		boundary.edges(2, :) = [ e1, e2, e3, e4 ];
		p1 = 1 : npy : (npx - 2) * npy + 1;
		p2 = (npx - 1) * npy + 1 : npx * npy + 1;
		p3 = npx * npy : -npy : 2 * npy;
		p4 = npy : -1 : 1;
		p = [ p1, p2, p3, p4 ];
		boundary.edges(3, :) = p(1 : end - 1);
		boundary.edges(4, :) = p(2 : end);
		boundary.nodes(1, :) = boundary.types;
		boundary.nodes(2, :) = boundary.edges(3, :);
	else
		% todo
		warning(['todo']);
	end
end