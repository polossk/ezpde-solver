function [ret] = calc_intgr(vertices, basis_indices, coef_fun, basis_config, diff_orders)
	% gauss method in rectangle element
	% diff_orders = [r, s, p, q];
	r = diff_orders(1); s = diff_orders(2);
	p = diff_orders(3); q = diff_orders(4);
	x1 = vertices(1, 1); y1 = vertices(2, 1);
	x2 = vertices(1, 2); y2 = vertices(2, 2);
	[w_, x_, y_] = gaussint_triangular(x1, y1, x2, y2, basis_config.gauss_order);
	phi_a = FE_local_basis_2D(x_, y_, vertices, basis_indices(1), basis_config, [r, s]);
	phi_b = FE_local_basis_2D(x_, y_, vertices, basis_indices(2), basis_config, [p, q]);
	c = w_gauss .* coef_fun(x_, y_);
	ret = sum([c .* phi_a .* phi_b]);
end