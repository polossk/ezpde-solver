function load_gaussint_coefs()
	global glc gtc;
	glc = load('gaussint_linear_coefs');
	gtc = load('gaussint_triangular_coefs.mat');
end