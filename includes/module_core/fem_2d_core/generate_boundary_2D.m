function [boundary] = generate_boundary_2D( boundary, mesh_config, meshes, basis_type )
% basis_type =
%   201: 2D linear nodal basis
%   202: 2D quadratic nodal basis
% triangular: square-based triangle mesh
%   D --- C
%   | \ 2 |
%   |  \  |
%   | 1 \ |
%   A --- B
% rectangular: square-liked mesh
%   D --- C
%   |     |
%   |  1  |
%   |     |
%   A --- B
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	yl = mesh_config.yl;
	yr = mesh_config.yr;
	hx = mesh_config.hx;
	hy = mesh_config.hy;
	nx = (xr - xl) / hx;
	ny = (yr - yl) / hy;
	npx = nx + 1; npy = ny + 1;
	if strcmp(mesh_config.type, 'triangular')
		len = 2 * (nx + ny);
		boundary.edges = int32(zeros(4, len));
		boundary.edges(1, :) = boundary.types;
		e1 = 1 : 2 * ny : 2 * (nx - 1) * ny + 1;
		e2 = 2 + 2 * (nx - 1) * ny : 2 : 2 * nx * ny;
		e3 = 2 * nx * ny : -2 * ny : 2 * ny;
		e4 = 2 * ny - 1 : -2 : 1;
		p1 = 1 : npy : (npx - 2) * npy + 1;
		p2 = (npx - 1) * npy + 1 : npx * npy - 1;
		p3 = npx * npy : -npy : 2 * npy;
		p4 = npy : -1 : 1;
		e = [ e1, e2, e3, e4 ];
		boundary.edges(2, :) = [ e1, e2, e3, e4 ];
		p = [ p1, p2, p3, p4 ];
		boundary.edges(3, :) = p(1 : end - 1);
		boundary.edges(4, :) = p(2 : end);
		if basis_type == 201
			boundary.nodes = int32(zeros(2, len));
			boundary.nodes(1, :) = boundary.types;
			boundary.nodes(2, :) = boundary.edges(3, :);
			boundary.endpoints = [1, (npx - 1) * npy + 1, npx * npy, npy, 1];
		elseif basis_type == 202
			npy = 2 * npy - 1; npx = npx * 2 - 1;
			p1 = 1 : npy : (npx - 2) * npy + 1;
			p2 = (npx - 1) * npy + 1 : npx * npy - 1;
			p3 = npx * npy : -npy : 2 * npy;
			p4 = npy : -1 : 1;
			p = [ p1, p2, p3, p4 ];
			boundary.nodes = int32(zeros(2, 2 * len));
			boundary.nodes(1, :) = boundary.types;
			boundary.nodes(2, :) = p(1 : end - 1);
			boundary.endpoints = [1, (npx - 1) * npy + 1, npx * npy, npy, 1];
		else
			warning('No implementation.');
		end
	else
		% todo
		warning(['todo']);
	end
end