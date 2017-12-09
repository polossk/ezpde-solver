function [A, b] = treat_dirichlet_boundary(A, b, boundary_config, mesh)
	boundary_fun = boundary_config.script;
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 1
			ii = boundary_nodes(2, k);
			A(ii, :) = 0;
			A(ii, ii) = 1;
			b(ii, 1) = boundary_fun(mesh.pb(ii));
		end
	end
end