function [A, b] = treat_robin_boundary(A, b, boundary_config, meshes, coef_fun)
	boundary_fun_p = boundary_config.script_p;
	boundary_fun_q = boundary_config.script_q;
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 3
			assert(k == 2);
			ii = boundary_nodes(2, k);
			pk = boundary_fun_p(meshes.pb(ii));
			ck = coef_fun(meshes.pb(ii));
			qk = boundary_fun_q(meshes.pb(ii));
			A(ii, :) = A(ii, :) + pk * ck;
			b(ii, 1) = b(ii, 1) + qk * ck;
		end
	end
end