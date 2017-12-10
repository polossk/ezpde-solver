function [w_gauss, x_gauss] = point_selection( xs, point_nums )
	[w_gauss, x_gauss] = gauss_int_coefs(xs(1), xs(2), point_nums);
end