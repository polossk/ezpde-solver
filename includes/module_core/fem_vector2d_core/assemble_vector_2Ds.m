function [vec] = assemble_vector_2Ds( meshes, meshes_id, basis_config, coef_fun, diff_orders )
	% diff_orders = [p, q];
	point_nums = length(meshes.meshes{meshes_id}.pb);
	element_nums = length(meshes.t);
	local_basis_nums = basis_config.nums(meshes_id);
	vec = zeros(point_nums, 1);
	for n = 1 : element_nums
		v = meshes.p(:, meshes.t(:, n));
		for jj = 1 : local_basis_nums
			integral_r = calc_intgt2(v, [0, jj], coef_fun, [1, meshes_id], basis_config, [0, 0, diff_orders]);
			jjj = meshes.meshes{meshes_id}.tb(jj, n);
			vec(jjj, 1) = vec(jjj, 1) + integral_r;
		end
	end
end