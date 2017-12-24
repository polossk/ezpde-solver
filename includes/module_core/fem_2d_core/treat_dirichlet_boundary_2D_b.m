function [b] = treat_dirichlet_boundary_2D_b(b, boundary_config, meshes)
	boundary_fun = boundary_config.script;
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	endpoints = boundary_config.endpoints; jj = 1;
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 1
			ii = boundary_nodes(2, k);
			b(ii, 1) = boundary_fun(meshes.pb(1, ii), meshes.pb(2, ii));
			if (ii == endpoints(jj))
				b(ii, 1) = b(ii, 1) / 2;
				% [double(ii), meshes.pb(1, ii), meshes.pb(2, ii), b(ii, 1)]
				jj = jj + 1;
			end
			% [double(ii), meshes.pb(1, ii), meshes.pb(2, ii), b(ii, 1)]
		end
	end
end