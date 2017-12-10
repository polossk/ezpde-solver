function [boundary] = generate_boundary( boundary, mesh )
	boundary.nodes = ones(boundary.nums, boundary.nums);
	boundary.nodes(2, 1) = 1;
	boundary.nodes(2, 2) = length(mesh.pb);
end