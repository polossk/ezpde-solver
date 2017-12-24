function fh = include( folder )
	fh = addpath(genpath(folder));
	load_gaussint_coefs;
end