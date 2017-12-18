function ret = FE_function_2D( x, y, uh_local, vertices, basis_config, diff_order )
	ret = 0;
	local_basis_nums = basis_config.nums;
	for k = 1 : local_basis_nums
		phi = FE_local_basis_2D(x, y, vertices, k, basis_config, diff_order);
		tmp = uh_local(k) .* phi;
		ret = ret + tmp;
	end
end