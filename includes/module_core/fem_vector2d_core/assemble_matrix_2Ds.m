function [mat] = assemble_matrix_2Ds( meshes, meshes_ids, basis_config, coef_fun, diff_orders )
	% diff_orders = [r, s, p, q];
	ida = meshes_ids(1); idb = meshes_ids(2);

	element_nums = length(meshes.t);
	point_nums_1 = length(meshes.meshes{ida}.pb);
	point_nums_2 = length(meshes.meshes{idb}.pb);
	
	local_basis_nums_1 = basis_config.nums(ida);
	local_basis_nums_2 = basis_config.nums(idb);

	mat = sparse(point_nums_2, point_nums_1);
	for n = 1 : element_nums
		v = meshes.p(:, meshes.t(:, n));
		for ii = 1 : local_basis_nums_1
			for jj = 1 : local_basis_nums_2
				% fprintf('%02d-%02d-%02d: ', n, ii, jj);
				% fprintf('meshes.tb(jj, n), meshes.tb(ii, n) = %d, %d\n', meshes.tb(jj, n), meshes.tb(ii, n));
				integral_r = calc_intgt2(v, [ii, jj], coef_fun, meshes_ids, basis_config, diff_orders);
				jjj = meshes.meshes{idb}.tb(jj, n);
				iii = meshes.meshes{ida}.tb(ii, n);
				mat(jjj, iii) = mat(jjj, iii) + integral_r;
			end
		end
	end
end