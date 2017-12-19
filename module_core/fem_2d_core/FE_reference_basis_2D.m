function [ret] = FE_reference_basis_2D(...
	x, y, basis_index, basis_config, diff_order...
	)
% helps
% basis_index = 0 => constant 1
% basis_type =
%   201: 2D linear nodal basis
%   202: 2D quadratic nodal basis
	basis_type = basis_config.type;
	der_x = diff_order(1); der_y = diff_order(2);

	if basis_type == 201
		if basis_index == 1
			if der_x == 0 && der_y == 0
				ret = -x - y + 1;
			elseif der_x == 1 && der_y == 0
				ret = -1;
			elseif der_x == 0 && der_y == 1
				ret = -1;
			elseif (der_x + der_y) >= 2
				ret = 0;
			else
				warning('@subrouting: basis_type: 201, basis_index: 1');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 2
			if der_x == 0 && der_y == 0
				ret = x;
			elseif der_x == 1 && der_y == 0
				ret = 1;
			elseif der_x >= 2 || der_y >= 1
				ret = 0;
			else
				warning('@subrouting: basis_type: 201, basis_index: 2');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 3
			if der_x == 0 && der_y == 0
				ret = y;
			elseif der_x == 0 && der_y == 1
				ret = 1;
			elseif der_x >= 1 || der_y >= 2
				ret = 0;
			else
				warning('@subrouting: basis_type: 201, basis_index 3');
				error('Wrong input for diff_order.');
			end
		else
			error('Wrong input for basis_index');
		end
	elseif basis_type == 202
		if basis_index == 1
			if der_x == 0 && der_y == 0
				ret = 2 * x.^2 + 2 * y.^2 + 4 * x .* y - 3 * y - 3 * x + 1;
			elseif der_x == 1 && der_y == 0
				ret = 4 * x + 4 * y - 3;
			elseif der_x == 0 && der_y == 1
				ret = 4 * x + 4 * y - 3;
			elseif der_x == 1 && der_y == 1
				ret = 4;
			elseif der_x == 2 && der_y == 0
				ret = 4;
			elseif der_x == 0 && der_y == 2
				ret = 4;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index: 1');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 2
			if der_x == 0 && der_y == 0
				ret = 2 * x.^2 - x;
			elseif der_x == 1 && der_y == 0
				ret = 4 * x - 1;
			elseif der_x == 0 && der_y == 1
				ret = 0;
			elseif der_x == 1 && der_y == 1
				ret = 0;
			elseif der_x == 2 && der_y == 0
				ret = 4;
			elseif der_x == 0 && der_y == 2
				ret = 0;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index: 2');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 3
			if der_x == 0 && der_y == 0
				ret = 2 * y.^2 - y;
			elseif der_x == 1 && der_y == 0
				ret = 0;
			elseif der_x == 0 && der_y == 1
				ret = 4 * y - 1;
			elseif der_x == 1 && der_y == 1
				ret = 0;
			elseif der_x == 2 && der_y == 0
				ret = 0;
			elseif der_x == 0 && der_y == 2
				ret = 4;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index 3');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 4
			if der_x == 0 && der_y == 0
				ret = -4 * x.^2 - 4 * x .* y + 4 * x;
			elseif der_x == 1 && der_y == 0
				ret = 4 - 8 * x - 4 * y;
			elseif der_x == 0 && der_y == 1
				ret = -4 * x;
			elseif der_x == 1 && der_y == 1
				ret = -4;
			elseif der_x == 2 && der_y == 0
				ret = -8;
			elseif der_x == 0 && der_y == 2
				ret = 0;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index: 4');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 5
			if der_x == 0 && der_y == 0
				ret = 4 * x .* y;
			elseif der_x == 1 && der_y == 0
				ret = 4 * y;
			elseif der_x == 0 && der_y == 1
				ret = 4 * x;
			elseif der_x == 1 && der_y == 1
				ret = 4;
			elseif der_x == 2 && der_y == 0
				ret = 0;
			elseif der_x == 0 && der_y == 2
				ret = 0;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index: 5');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 6
			if der_x == 0 && der_y == 0
				ret = -4 * y.^2 - 4 * x .* y + 4 * y;
			elseif der_x == 1 && der_y == 0
				ret = -4 * y;
			elseif der_x == 0 && der_y == 1
				ret = 4 - 4 * x - 8 * y;
			elseif der_x == 1 && der_y == 1
				ret = -4;
			elseif der_x == 2 && der_y == 0
				ret = 0;
			elseif der_x == 0 && der_y == 2
				ret = -8;
			elseif (der_x + der_y) >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 202, basis_index 6');
				error('Wrong input for diff_order.');
			end
		else
			error('Wrong input for basis_index');
		end
	else
		error('Wrong input for basis_type');
	end

end