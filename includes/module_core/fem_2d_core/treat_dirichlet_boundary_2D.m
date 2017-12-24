function [A, b] = treat_dirichlet_boundary_2D(A, b, boundary_config, meshes)
	boundary_fun = boundary_config.script;
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	endpoints = 1 : boundary_nums / 4 : boundary_nums;
	endpoints = [endpoints, 1]; jj = 1;
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 1
			ii = boundary_nodes(2, k);
			A(ii, :) = 0;
			A(ii, ii) = 1;
			b(ii, 1) = boundary_fun(meshes.pb(1, ii), meshes.pb(2, ii));
			if (k == endpoints(jj))
				b(ii, 1) = b(ii, 1) / 2;
				jj = jj + 1;
			end
		end
	end
end