function [A, b] = treat_dirichlet_boundary_2Ds(A, b, boundarys, meshes, meshes_ids)
	offset = 0;
	for idx = meshes_ids
		[A, b] = treat_dirichlet_boundary_2Ds_(A, b, boundarys{idx}, meshes.meshes{idx}, offset);
		offset = offset + length(meshes.meshes{idx}.pb);
	end
end