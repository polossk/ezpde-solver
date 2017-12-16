function ret = FE_reference_basis_2D(x, y, basis_type, basis_index, der_x, der_y)


if basis_type == 201

	if basis_index == 1
		if der_x == 0 && der_y == 0
			ret = x - y + 1;
		elseif der_x == 1 && der_y == 0
			ret = -1;
		elseif der_x == 0 && der_y == 1
			ret = -1;
		elseif 
			
			

	elseif basis_index == 2

	elseif basis_index == 3

	else warning(['Description']);
	end
		


elseif basis_type == 202

else

end

end