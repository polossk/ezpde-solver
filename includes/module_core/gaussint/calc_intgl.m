function [ret] = calc_intgl(vertices, basis_indices, coef_fun, basis_config, flag)
	% guass method in 1D interval element
	a = vertices(1); b = vertices(2);
	[w_gauss, x_gauss] = gaussint_linear(a, b, basis_config.gauss_order);
	phi_a = FE_local_basis_1D(x_gauss, vertices, basis_indices(1), basis_config.type, flag);
	phi_b = FE_local_basis_1D(x_gauss, vertices, basis_indices(2), basis_config.type, flag);
	c = w_gauss .* coef_fun(x_gauss);
	ret = sum([c .* phi_a .* phi_b]);
end