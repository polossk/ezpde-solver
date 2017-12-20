function [A] = treat_dirichlet_boundary_2D_A(A, boundary_config, meshes)
	boundary_nodes = boundary_config.nodes;
	boundary_nums = size(boundary_nodes, 2);
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 1
			ii = boundary_nodes(2, k);
			A(ii, :) = 0;
			A(ii, ii) = 1;
		end
	end
end