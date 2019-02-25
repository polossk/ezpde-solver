function fh = compile()
    src_path_list = split(genpath(fullfile('.', 'sources')), ';');
    src_path_list(cellfun(@isempty, src_path_list)) = [];
    dst_path_list = strrep(src_path_list, 'sources', 'includes');
    folder_num = length(src_path_list);
    old_path = cd();
    src_file_list = fullfile(old_path, src_path_list, '*.m');
    for i = 1 : folder_num
        if isempty(dir(src_file_list{i}))
            continue
        end
        cd(dst_path_list{i});
        pcode(src_file_list{i});
        cd(old_path);
    end
end