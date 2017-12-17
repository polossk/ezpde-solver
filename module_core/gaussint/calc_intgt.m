function [ret] = calc_intgt(vertices, basis_indices, coef_fun, basis_config, flag)
	% gauss method in triangle element
	x1 = vertices(1, 1); y1 = vertices(2, 1);
	x2 = vertices(1, 2); y2 = vertices(2, 2);
	x3 = vertices(1, 3); y3 = vertices(2, 3);
	[w_, x_, y_] = gaussint_triangular(x1, y1, x2, y2, x3, y3, basis_config.gauss_order);
	phi_a = FE_local_basis_2D(x_, y_, vertices, basis_indices(1), basis_config, flag);
	phi_b = FE_local_basis_2D(x_, y_, vertices, basis_indices(2), basis_config, flag);
	c = w_gauss .* coef_fun(x_, y_);
	ret = sum([c .* phi_a .* phi_b]);
end