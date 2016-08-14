function T = read_fs_files(path)
T = fileread(path);
T = regexp(T, '\n', 'split');
if isempty(T{end}),T(end)=[];end
header_lines=cellfun(@(A) strcmp(A(1),'#'),T);
T(header_lines)=[];
T = cellfun(@(A) strsplit(A),T,'UniformOutput',false);
end