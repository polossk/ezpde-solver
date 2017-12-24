function [sol, pde_config] = equation_error(sol, pde_config)
	lmethod = pde_config.loss.method;
	switch lmethod
		case 'custom'
			sol.err = pde_config.loss.loss_fun(sol.sol, sol.sol_exact);
		case 'L_inf'
			sol.err = calc_inf_error(sol, pde_config);
		case 'L2'
			sol.err = calc_l2_error(sol, pde_config);
		case 'H1'
			sol.err = calc_h1_error(sol, pde_config);
		otherwise
			warning(['No implementation.']);
	end
end