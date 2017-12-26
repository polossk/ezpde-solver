function [A, b] = treat_dirichlet_boundary_2Ds_(A, b, boundary, mesh, offset)
	
	boundary_fun = boundary.script;
	boundary_nodes = boundary.nodes;
	boundary_nums = size(boundary_nodes, 2);
	endpoints = boundary.endpoints; endi = 1;
	for k = 1 : boundary_nums
		if boundary_nodes(1, k) == 1
			ii = boundary_nodes(2, k);
			jj = ii + offset;
			A(jj, :) = 0;
			A(jj, jj) = 1;
			b(jj, 1) = boundary_fun(mesh.pb(1, ii), mesh.pb(2, ii));
			if (ii == endpoints(endi))
				b(jj, 1) = b(jj, 1) / 2;
				endi = endi + 1;
			end
		end
	end
end