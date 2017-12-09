function [ret] = FE_local_basis_1D(...
	x, vertices, basis_index, basis_config, diff_order...
	)
% helps
% basis_index = 0 => constant 1
% basis_type =
%   101: 1D linear nodal basis

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
	else
		error('Wrong input for basis_type');
	end
end