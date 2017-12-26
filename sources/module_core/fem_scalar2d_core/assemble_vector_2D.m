function [vec] = assemble_vector_2D( meshes, basis_config, coef_fun, diff_orders )
	% diff_orders = [p, q];
	point_nums = length(meshes.pb);
	element_nums = length(meshes.t);
	local_basis_nums = basis_config.nums;
	vec = zeros(point_nums, 1);
	for n = 1 : element_nums
		v = meshes.p(:, meshes.t(:, n));
		for jj = 1 : local_basis_nums
			integral_r = calc_intgt(v, [0, jj], coef_fun, basis_config, [0, 0, diff_orders]);
			vec(meshes.tb(jj, n), 1) = vec(meshes.tb(jj, n), 1) + integral_r;
		end
	end
end