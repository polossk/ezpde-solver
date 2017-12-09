function [vec] = assemble_vector_1D( mesh, basis_config, coef_fun )
	element_nums = length(mesh.p) - 1;
	local_basis_nums = basis_config.nums;
	vec = zeros(length(mesh.p), 1);

	for n = 1 : element_nums
		v = mesh.p(:, mesh.t(:, n));
		for jj = 1 : local_basis_nums
			integral_r = calc_gauss_int(v, [0, jj], coef_fun, basis_config, 0);
			vec(mesh.tb(jj, n), 1) = vec(mesh.tb(jj, n), 1) + integral_r;
		end
	end

end