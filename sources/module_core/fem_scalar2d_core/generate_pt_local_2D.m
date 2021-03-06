function [pb, tb] = generate_pt_local_2D(mesh_config, basis_type, p, t)
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
	ny = (yr - yl) / hy;
	npy = ny + 1;
	if strcmp(mesh_config.type, 'triangular')
		if basis_type == 201
			pb = p; tb = t;
		elseif basis_type == 202
			sid = t - 1;
			si = floor(sid / npy); sj = rem(sid, npy);
			tid = 4 * sid - 2 * (si + sj) + 1;
			tt = [tid; tid(1, :)];
			ttid = (tt(1:3, :) + tt(2:4, :)) / 2;
			tb = [tid; ttid];
			hx = hx / 2; nx = (xr - xl) / hx;
			hy = hy / 2; ny = (yr - yl) / hy;
			px = xl : hx : xr; npx = nx + 1;
			py = yl : hy : yr; npy = ny + 1;
			pid = 0 : (npx * npy - 1);
			qi = floor(pid / npy) + 1; qj = rem(pid, npy) + 1;
			pb = [ px(qi); py(qj) ];
		else
			warning('No implementation.');
		end
	else
		% todo
		warning(['todo']);
	end
end