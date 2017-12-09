% \int_{x_n}^{x_{n+1}}
%   c \phi_{n\alpha}^{(r)} \phi_{n\beta}^{(s)} \diff x
function [ret] = calc_gauss_int(vertices, basis_indices, coef_fun, basis_config, flag)
	[w_gauss, x_gauss] = gauss_int_coefs(basis_config.gauss_order);
	a = vertices(1); b = vertices(2);
	
	g = @(t) ((b - a) / 2 * t);
	X = @(t) (g(t) + (b + a) / 2);
	
	w_gauss = g(w_gauss);
	x_gauss = X(x_gauss);
	phi_a = FE_local_basis_1D(x_gauss, vertices, basis_indices(1), basis_config, flag);
	phi_b = FE_local_basis_1D(x_gauss, vertices, basis_indices(2), basis_config, flag);
	c = w_gauss .* coef_fun(x_gauss);
	ret = (sum([c .* phi_a .* phi_b]));
end