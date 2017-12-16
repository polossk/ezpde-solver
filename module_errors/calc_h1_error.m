function [err] = calc_h1_error( sol, pde_config )
	err = calc_hs_error(1, sol, pde_config);
end