function show_2 = cobra_in_handle(linear_power_average)

num_str = num2str(linear_power_average);
[whole_old,frac_old] = strtok(num_str,'.');
frac_old(1) = '';
whole_old_len = length(whole_old);

if whole_old_len-1 < 10
    exp = strcat('0',num2str(whole_old_len-1));
elseif whole_old_len-1>=10 && whole_old_len-1<100
    exp = num2str(whole_old_len-1);
else
    error('Invalid lin power');
end

whole_new = whole_old(1);
frac_new = strcat(whole_old(2:end),frac_old);
show_2 = strcat(whole_new,'.',frac_new(1:4),'E+',exp);

end