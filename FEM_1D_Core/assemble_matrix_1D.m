function [mat] = assemble_matrix_1D( meshes, basis_config, coef_fun )
	point_nums = length(meshes.pb);
	element_nums = length(meshes.p) - 1;
	local_basis_nums = basis_config.nums;
	mat = sparse(point_nums, point_nums);

	for n = 1 : element_nums
		v = meshes.p(:, meshes.t(:, n));
		for ii = 1 : local_basis_nums
			for jj = 1 : local_basis_nums
                % fprintf('%02d-%02d-%02d: ', n, ii, jj);
                % fprintf('meshes.tb(jj, n), meshes.tb(ii, n) = %d, %d\n', meshes.tb(jj, n), meshes.tb(ii, n));
				integral_r = calc_gauss_int(v, [ii, jj], coef_fun, basis_config, 1);
				mat(meshes.tb(jj, n), meshes.tb(ii, n)) = mat(meshes.tb(jj, n), meshes.tb(ii, n)) + integral_r;
			end
		end
	end

end