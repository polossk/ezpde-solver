function [p, t] = generate_pt(mesh_config)
	xl = mesh_config.xl;
	xr = mesh_config.xr;
	h = mesh_config.h;
	n = (xr - xl) / h;
	p = xl : h : xr;
	t = [1 : n; 2 : (n + 1)];
end