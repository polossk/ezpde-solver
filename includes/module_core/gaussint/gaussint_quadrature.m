function [w_, x_, y_] = gaussint_quadrature(x1, y1, x2, y2, flags)
	% output w_, x_, y_ as [nums x 1] column vector
	[u, x] = gaussint_linear(x1, x2, flags);
	[v, y] = gaussint_linear(y1, y2, flags);
	[xx, yy] = meshgrid(x, y); x_ = xx(:); y_ = yy(:);
	ww = v * u'; w_ = ww(:);
end