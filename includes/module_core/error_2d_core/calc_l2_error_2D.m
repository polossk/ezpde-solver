function [err] = calc_l2_error_2D( sol, pde_config )
	err = calc_hs_error_2D([0, 0], sol, pde_config);
end