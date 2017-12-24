function [w_, x_, y_] = gaussint_triangular(x1, y1, x2, y2, x3, y3, order)
	% output w_, x_, y_ as [nums x 1] column vector
	if order >= 9 || order <= 0
		error('out of function abilitity.');
	end
	global gtc;
	xw = gtc.xw{order};
	x = xw(:, 1); y = xw(:, 2); w = xw(:, 3);
	jcb = (x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1);
	% f = @(a, b, c, x, y) (a + (b - a) * x + (c - a) * y);
	w_ = 0.5 * abs(jcb) * w;
	x_ = (x1 + (x2 - x1) * x + (x3 - x1) * y);
	y_ = (y1 + (y2 - y1) * x + (y3 - y1) * y);
end