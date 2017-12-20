function [sol, pde_config] = equ_error2D(sol, pde_config)
	lmethod = pde_config.loss.method;
	if strcmp(lmethod, 'custom')
		sol.err = pde_config.loss.loss_fun(sol.sol, sol.sol_exact);
		return;
	end

	time_equ_flag = isfield(pde_config.loss, 't');

	if time_equ_flag
		sol.sol = sol.sol(end, :);
		t_ = pde_config.loss.t;
		exact_t = pde_config.exact_sol_script;
		diffx_t = pde_config.exact_sol_script_diffx;
		diffy_t = pde_config.exact_sol_script_diffy;
		pde_config.exact_sol_script = @(x, y) (exact_t(x, y, t_));
		pde_config.exact_sol_script_diffx = @(x, y) (diffx_t(x, y, t_));
		pde_config.exact_sol_script_diffy = @(x, y) (diffy_t(x, y, t_));
	end

	switch lmethod
		case 'L_inf'
			sol.err = calc_inf_error_2D(sol, pde_config);
		case 'L2'
			sol.err = calc_l2_error_2D(sol, pde_config);
		case 'H1'
			sol.err = calc_h1_error_2D(sol, pde_config);
		otherwise
			warning(['No implementation.']);
	end

	if time_equ_flag
		pde_config.exact_sol_script = exact_t;
		pde_config.exact_sol_script_diffx = diffx_t;
		pde_config.exact_sol_script_diffy = diffy_t;
	end
end