function fh = include( folder )
	fh = addpath(genpath(fullfile(folder, 'includes')));
end