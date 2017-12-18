function [sol, pde_config] = possion2D_error(sol, pde_config)
	% debug = [(sol.sol)', (sol.sol_exact)']
	lmethod = pde_config.loss.method;
	switch lmethod
		case 'custom'
			sol.err = pde_config.loss.loss_fun(sol.sol, sol.sol_exact);
		case 'L_inf'
			sol.err = calc_inf_error_2D(sol, pde_config);
		case 'L2'
			sol.err = calc_l2_error_2D(sol, pde_config);
		case 'H1'
			sol.err = calc_h1_error_2D(sol, pde_config);
		otherwise
			warning(['No implementation.']);
	end
end