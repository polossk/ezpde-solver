function [A, b] = treat_neumann_boundary(A, b, boundary_config, meshes, coef_fun)
	boundary_fun = boundary_config.script;
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 2
			ii = boundary_nodes(2, k);
			rk = boundary_fun(meshes.pb(ii));
			ck = coef_fun(meshes.pb(ii));
			coef = k * 2 - 3;
			b(ii, 1) = b(ii, 1) + coef * rk * ck;
		end
	end
end