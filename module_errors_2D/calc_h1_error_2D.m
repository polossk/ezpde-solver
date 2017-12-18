function [err] = calc_h1_error_2D( sol, pde_config )
	errx = calc_hs_error_2D([1, 0], sol, pde_config);
	erry = calc_hs_error_2D([0, 1], sol, pde_config);
	err = hypot(errx, erry);
end