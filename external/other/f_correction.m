
% example
% f = [2,2,1,-4;5,-4,1,5]';

function [L,f_cor] = f_correction(f)

f_cor = f;
for i=1:size(f_cor,2)
    m = f_cor (:,i)== -4;
    f_cor (m,i)= mode(f_cor (~m,i));
end
L = length(find(m==1));
end
