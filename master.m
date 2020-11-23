%% params 
filename = 'prob_5_assignment.txt'; % set input filename for COBRA

DX = -0.20; %Length of the axial interval
NAXP = 18; %Number of axial levels for power distribution
interval = 0.13:-DX:3.53;

no_rod = 17*17;
no_rod_heated = 264;
rod_diam = 0.0095;
rod_pitch = 0.0126;
channel_length = 3.66;
mass_flow_rate = 19000;

[CHAR,CHPH,CHPW,GIN] = func(no_rod,no_rod_heated,rod_diam,...
    rod_pitch,mass_flow_rate) %(2)(4)(3)(16)
% GIN = 1750; %(16) alternate mass flux mentioend on the doc

HRNUM = 264; %(4.5)no of heated rods in channel - just 1 pin in our channel
HIN = 563; %default = 563(15)inlet temperature
PEXIT = 15.5; %(17)system exit pressure

power = 3320e6;
linear_power_average = power/(193*3.66);
linear_power_max = pi*power/(2*193*3.66);
power_peaking_factor = linear_power_max/linear_power_average;

% linear_power_max = 2.320*linear_power_average; % for a different power factor

%Linear fission power of rod N for axial level J (W/m)
QTAB = linear_power_max*sin(pi*interval./3.66); %(1)linear fission power 
% plot(interval,QTAB,'k*');
for i = 1:NAXP
    fprintf('Node %d: %s\n',i,cobra_in_handle(QTAB(i)));
end

%% COBRA card statements
card{1} = '';
card{2} = '     0     2     2     1';
card{3} = sprintf('     2     1     0    %2d     1     0     0     5     0     0     0     1',NAXP);
card{4} = sprintf('   %1.2f',DX);
card{5} = sprintf('    %2d',NAXP);

card_r{1} = sprintf('     1  1.0   %s    %1.5f     %1.5f      %d        1      ',cobra_in_handle(CHAR),CHPW,CHPH,HRNUM);
card_r{2} = '  0.008       0.00057      10000       6500        0.0095  ';
card_r{3} = '    3.3       300          10          500         9400 ';
card_r{4} = '     0     0     1     1     0     1     1     0     1     0';
card_r{5} = '     0';
card_r{6} = '$            JSLIP';
card_r{7} = '     0     0     0';
card_r{8} = '     0     0     0     0     0     0';
card_r{9} = ' 10.   0.0   0.5  0.0';
card_r{10} = '     3     0     0  0.0      0     0    0.    0.    0.';
card_r{11} = '$                  WERRX DAMPP DAMPF                         EPSP ISCHEM';
card_r{12} = '     0     0    0.  0.     0.    0.  -.01     0.     0  0.     0.      2';
card_r{13} = sprintf('     1  %d  %d  %.1f    -20     1   0.  0.0   0.0  1600.   0.0  0.0',HIN,int32(GIN),PEXIT);
card_r{14} = '     0     0     0';
card_r{15} = '     0     0     0     0     0';
card_r{16} = '     0     5     3     0     0     0    -1';
card_r{17} = '$EOD';


%% generate input file
fid = fopen(filename,'w');

for i = 1:5
    fprintf(fid,'%s\n',card{i});
end

for i = 1:length(QTAB)
    str = cobra_in_handle(QTAB(i));
    fprintf(fid,' %1.4f\n',interval(i));
    fprintf(fid,'%s\n',str);
end

% plot(interval,QTAB);

for i = 1:length(card_r)
    fprintf(fid,'%s\n',card_r{i});
end
close_result = fclose(fid);
if close_result == 0
    disp('File close successful');
else
    disp('File close not successful');
end

%% run COBRA from cmd
command = sprintf('%s%s','.\rcobra.bat .\',filename)
status = system(command)
[status,cmdout] = system(command)
[status,cmdout] = system(command,'-echo')

%% COBRA output read
outfilename = strcat(filename,'.out');
cobra_out_handle(outfilename);

%% in-script functions 
function [CHAR,CHPH,CHPW,GIN] = func(no_rod,no_rod_heated,rod_diam,...
    rod_pitch,mass_flow_rate)
    CHAR = (17*rod_pitch)^2-(no_rod*0.25*pi*rod_diam^2);
    CHPH = no_rod_heated*pi*rod_diam;
    CHPW = no_rod*pi*rod_diam;
    GIN = mass_flow_rate/(193*CHAR);%mass flux
end