function [sol, pde_config] = elasticity_error(sol, pde_config)
	[sol, pde_config] = equation_error2Ds(sol, pde_config);
end