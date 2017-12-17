function [ret] = FE_local_basis_1D(...
	x, vertices, basis_index, basis_config, diff_order...
	)
% helps
% basis_index = 0 => constant 1
% basis_type =
%   101: 1D linear nodal basis
%   102: 1D quadratic nodal basis

	h = diff(vertices);
	basis_type = basis_config.type;

	if basis_index == 0
		ret = 1; return;
	end
	
	if basis_type == 101 % 1D linear nodal basis
		if basis_index == 1
			if diff_order == 0
				ret = (vertices(2) - x) / h;
			elseif diff_order == 1
				ret = -1/h;
			elseif diff_order >= 2
				ret = 0;
			else
				warning('@subrouting: basis_type: 101, basis_index: 1');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 2
			if diff_order == 0
				ret = (x - vertices(1)) / h;
			elseif diff_order == 1
				ret = 1/h;
			elseif diff_order >= 2
				ret = 0;
			else
				warning('@subrouting: basis_type: 101, basis_index: 2');
				error('Wrong input for diff_order.');
			end
		else
			error('Wrong input for basis_index');
		end
	elseif basis_type == 102 % 1D quadratic nodal basis
		y = (x - vertices(1)) / h;
		if basis_index == 1
			if diff_order == 0
				ret = 2 .* y .* y - 3 .* y + 1;
			elseif diff_order == 1
				ret = 4 / h .* y - 3 / h;
			elseif diff_order == 2
				ret = 4 / h / h;
			elseif diff_order >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 102, basis_index: 1');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 2
			if diff_order == 0
				ret = 2 .* y .* y - y;
			elseif diff_order == 1
				ret = 4 / h .* y - 1 / h;
			elseif diff_order == 2
				ret = 4 / h / h;
			elseif diff_order >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 102, basis_index: 2');
				error('Wrong input for diff_order.');
			end
		elseif basis_index == 3
			if diff_order == 0
				ret = -4 .* y .* y + 4 .* y;
			elseif diff_order == 1
				ret = -8 / h .* y + 4 / h;
			elseif diff_order == 2
				ret = -8 / h / h;
			elseif diff_order >= 3
				ret = 0;
			else
				warning('@subrouting: basis_type: 102, basis_index: 3');
				error('Wrong input for diff_order.');
			end
		else
			error('Wrong input for basis_index');
		end
	else
		error('Wrong input for basis_type');
	end
end