function [w_, x_, y_] = point_selection_2D( xs, point_orders )
	x1 = xs(1, 1); y1 = xs(2, 1);
	x2 = xs(1, 2); y2 = xs(2, 2);
	x3 = xs(1, 3); y3 = xs(2, 3);
	[w_, x_, y_] = gaussint_triangular(x1, y1, x2, y2, x3, y3, point_orders);
end