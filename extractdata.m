function [out1]= extractdata(data_name)
    data=xlsread(data_name);
    %% find number of diffrent varbilrs type in the data 
    [C,ia,ic] = unique(data(:,7));
    a_counts = accumarray(ic,1);
    a=array2table(a_counts);
    value_counts = [C, a];
    %% creat diffrent tables
    len_c=height(C);
    for i=1:len_c
        % for every day 96 data points of every type (battary,acc,...)
    end
    
    %%
    len_data=height(data);
    for i=1:len_c
        type_c=char(C.type(1));
        for j=1:len_data
            switch type_c
                case 'acelerometer'
                    v=join(char(table2cell(data(1,15))));
                    s = jsondecode(v);
                    m = containers.Map(fieldnames(s), struct2cell(s));
                    t=m.values;
                    ACC_table=cell2table(t);
                    varname=cellfun(@(x) string(x),keys(m));
                    ACC_table.Properties.VariableNames = varname;
            
            
            
        end
    end
    
end
