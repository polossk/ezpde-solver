function [p, t] = generate_pt_2D(mesh_config, basis_type)
	% square-based triangle mesh
	% D --- C
	% | \ 2 |
	% |  \  |
	% | 1 \ |
	% A --- B
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	yl = mesh_config.yl;
	yr = mesh_config.yr;
	hx = mesh_config.hx;
	hy = mesh_config.hy;
	nx = (xr - xl) / hx;
	ny = (yr - yl) / hy;
	px = xl : hx : xr; npx = nx + 1;
	py = yl : hy : yr; npy = ny + 1;
	pid = 0 : (npx * npy - 1);
	qi = floor(pid / npy) + 1; qj = rem(pid, npy) + 1;
	sid = 0 : (nx * ny - 1);
	si = floor(sid / ny); sj = rem(sid, ny);
	b = 1 + npy * (si + 1) + sj;
	d = 2 + npy * si + sj;
	c = b + 1;
	a = d - 1;
	tt = [ a; b; d; d; b; c ];
	p = [ px(qi); py(qj) ];
	t = reshape(tt, 3, 2 * nx * ny);
end