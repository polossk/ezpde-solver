function [err] = calc_l2_error( sol, pde_config )
	err = calc_hs_error(0, sol, pde_config);
end