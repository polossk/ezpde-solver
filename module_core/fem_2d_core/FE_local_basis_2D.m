function [ret] = FE_local_basis_2D(...
	x, y, vertices, basis_index, basis_config, diff_order...
	)

	basis_type = basis_config.type;
	der_x = diff_order(1); der_y = diff_order(2);

	x1 = vertices(1, 1);
	x2 = vertices(1, 2);
	x3 = vertices(1, 3);
	y1 = vertices(2, 1);
	y2 = vertices(2, 2);
	y3 = vertices(2, 3);

	jcb = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
	xh = ((y3 - y1) * (x - x1) - (x3 - x1) * (y - y1)) / jcb;
	yh = ((y1 - y2) * (x - x1) - (x1 - x2) * (y - y1)) / jcb;
	
	% pxhpx := \frac{\partial \hat x}{\partial x}
	% pxhpy := \frac{\partial \hat x}{\partial y}
	% pyhpx := \frac{\partial \hat y}{\partial x}
	% pyhpy := \frac{\partial \hat y}{\partial y}
	pxhpx = (y3 - y1) / jcb;
	pxhpy = (x1 - x3) / jcb;
	pyhpx = (y1 - y2) / jcb;
	pyhpy = (x2 - x1) / jcb;

	fehelp = @(ds) FE_reference_basis_2D(xh, yh, basis_index, basis_config, ds);

	if der_x == 0 && der_y == 0
		ret = fehelp(diff_order);
	elseif der_x == 1 && der_y == 0
		hoge = pxhpx * fehelp([1, 0]);
		piyo = pyhpx * fehelp([0, 1]);
		ret = hoge + piyo;
	elseif der_x == 0 && der_y == 1
		hoge = pxhpy * fehelp([1, 0]);
		piyo = pyhpy * fehelp([0, 1]);
		ret = hoge + piyo;
	elseif der_x == 1 && der_y == 1
		hoge = pxhpy * pxhpx * fehelp([2, 0]);
		piyo = (pxhpy * pyhpx + pxhpx * pyhpy) * fehelp([1, 1]);
		fuga = pyhpy * pyhpx * fehelp([0, 2]);
		ret = hoge + piyo + fuga;
	elseif der_x == 2 && der_y == 0
		hoge = pxhpx * pxhpx * fehelp([2, 0]);
		piyo = 2 * pxhpx * pyhpx * fehelp([1, 1]);
		fuga = pyhpx * pyhpx * fehelp([0, 2]);
		ret = hoge + piyo + fuga;
	elseif der_x == 0 && der_y == 2
		hoge = pxhpy * pxhpy * fehelp([2, 0]);
		piyo = 2 * pxhpy * pyhpy * fehelp([1, 1]);
		fuga = pyhpy * pyhpy * fehelp([0, 2]);
		ret = hoge + piyo + fuga;
	else
		warning('@subrouting: FE_local_basis_2D, basis_index 3');
		error('Wrong input for diff_order.');
	end
end