function save_table_dat(table_title,var_name,filename, input_matrix )
%     [
%     TABLE TITLE  
%     n
%     X1
%     .
%     .
%     .
%     Xn
%     VARIABLE NAME
%     ]
    n = length(var_name);
    fid = fopen(filename,'wt');
    header = [table_title,'\n',num2str(n),'\n'];
    for var_i = 1:n
        header = [header,var_name{var_i},'\n'];
    end
    
    fprintf(fid, header);
    for matrix_row = 1:1:size(input_matrix,1)
        fprintf(fid, ['%f',repmat('\t%f',[1 n-1]),'\n'],input_matrix(matrix_row,:));
    end

    fclose(fid);
end

