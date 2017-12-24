function [sol, pde_config] = heat2D_error(sol, pde_config)
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

	[sol, pde_config] = equation_error2D(sol, pde_config);

	if time_equ_flag
		pde_config.exact_sol_script = exact_t;
		pde_config.exact_sol_script_diffx = diffx_t;
		pde_config.exact_sol_script_diffy = diffy_t;
	end
end