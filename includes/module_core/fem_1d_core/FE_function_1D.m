function ret = FE_function_1D( x, uh_local, vertices, basis_config, diff_order )
	ret = 0;
	local_basis_nums = basis_config.nums;
	for k = 1 : local_basis_nums
		phi = FE_local_basis_1D(x, vertices, k, basis_config, diff_order);
		tmp = uh_local(k) .* phi;
		ret = ret + tmp;
	end
end