function cobra_out_handle(filename)
% SAAD ISLAM 15 NOV 20, MH-106, Hills Rd

%----------------------------black-box-------------------------------------

temp = fileread(filename);
str_1 = 'REC. NO. =    5        ';
scope_index_begins = strfind(temp,str_1);
offset = length(str_1);
steps = str2num(temp(scope_index_begins+offset:scope_index_begins+...
    offset+5));
str_2 ='T( 7)';
scope_index_next = strfind(temp,str_2);
output_1 = temp(scope_index_next+length(str_2)+...
    5:scope_index_next+length(str_2)+5+(118*steps)-3);
%jotogulai space thakuk,ekta space dia replace koro
output_2 = regexprep(output_1,' +',' ');
%--------------------------------------------------------------------------

var_names = {'DISTANCE','FLUX','DNBR','CHANNEL','AVERAGE FUEL TEMPERATURE',...
    'ROD CENTERLINE TEMPERATURE','PELLET MEAN TEMPERATURE','PELLET OUTER TEMPERATURE',...
    'GAP MEAN TEMPERATURE','CLAD INNER SURFACE TEMPERATURE','CLAD MEAN TEMPERATURE',...
    'CLAD OUTER SURFACE TEMPERATURE'};
var = zeros(steps,12);
rest = output_2;
for i = 1:steps
    for j = 1:12
        [token,rest] = strtok(rest,' ');
        var(i,j) = str2double(token);
    end 
end

clf;
figure(1);
plot(var(:,1),var(:,3),'k*')
xlabel(var_names{1})
ylabel(var_names{3})

figure(2);
hold on;
for i = 1:8
    plot(var(:,1),var(:,i+4))
end
xlabel(var_names{1});
ylabel('TEMPERATURE');
legend(var_names{5},var_names{6},var_names{7},var_names{8},var_names{9},...
    var_names{10},var_names{11},var_names{12});

% saveas(gcf,'dnbr.png');

% title('figure')
% xlabel('abscissa')
% ylabel('ordinate')
% axis([0 5 0 5]) 
% pbaspect([1 1 1]);

end