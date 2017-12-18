function y = evaluate_us_2D(pde_config, ev_point, rs)
	r = rs(1); s = rs(2);
	x = ev_point(:, 1); y = ev_point(:, 2);
	if r == 0 && s == 0
		y = pde_config.exact_sol_script(x, y);
	elseif r == 1 && s == 0
		y = pde_config.exact_sol_script_diffx(x, y);
	elseif r == 0 && s == 1
		y = pde_config.exact_sol_script_diffy(x, y);
	elseif r == 1 && s == 1
		warning(['evaluate_us_2D {r = 1, s = 1}: No Implementation.']);
	end
end