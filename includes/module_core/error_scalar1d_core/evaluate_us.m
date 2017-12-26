function y = evaluate_us(pde_config, ev_point, s)
	if s == 0
		y = pde_config.exact_sol_script(ev_point);
	elseif s == 1
		y = pde_config.exact_sol_script_diff1(ev_point);
	end
end