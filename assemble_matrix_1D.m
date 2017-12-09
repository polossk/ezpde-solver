function [mat] = assemble_matrix_1D( mesh, basis_config, coef_fun )
	element_nums = length(mesh.p) - 1;
	local_basis_nums = basis_config.nums;
	mat = sparse(length(mesh.p), length(mesh.p));

	for n = 1 : element_nums
		v = mesh.p(:, mesh.t(:, n));
		for ii = 1 : local_basis_nums
			for jj = 1 : local_basis_nums
				integral_r = calc_gauss_int(v, [ii, jj], coef_fun, basis_config, 1);
				mat(mesh.tb(jj, n), mesh.tb(ii, n)) = mat(mesh.tb(jj, n), mesh.tb(ii, n)) + integral_r;
			end
		end
	end

end