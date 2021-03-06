%close all

noise_on = 1;

if noise_on
    load('optimal_params_r0_40_j_0.mat')
else
    load('optimal_params_sensing_no_noise_latest_batch_new_prob_new_params.mat')
end    


[param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15,param16,param17,param18] = return_parameters(1);
probability_switch_pt_initial_guess = param18;
%tf_vector = [2,6,12,24,36,48,72,96,120,240];
%tf_vector = [4,8,10,12,14,16];
tf_vector = [12,18,24,30,36,42,48,72];

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

color_cell = {'k','k','k','k'};
ls = {'-','--',':','-.'};
ms = {'o','s','d','h'};
%% initial concentrations
R0 = 40;
S0 = 10^7;
E0 = 0;
L0 = 0;
I0 = 0;
V0 = 10^5;
%V0 = 0;
A0 = 0;

Z0 = [R0,S0,E0,L0,I0,V0,A0];
dt = 20/3600; 
Z_temp = zeros(length(tf_vector),7,length(0:dt:48));
for i = 1:length(tf_vector)
    t = 0:dt:tf_vector(i);
    Z = forward_euler(Z0, optimal_params_save(:,i), t, dt, noise_on, 0);
    Z_temp(i,:,1:length(t)) = Z;
end    

Z_12(:,:) = Z_temp(1,:,1:length(0:dt:12));
Z_18(:,:) = Z_temp(2,:,1:length(0:dt:18));
Z_24(:,:) = Z_temp(3,:,1:length(0:dt:24));
Z_30(:,:) = Z_temp(4,:,1:length(0:dt:30));
Z_36(:,:) = Z_temp(5,:,1:length(0:dt:36));
Z_42(:,:) = Z_temp(6,:,1:length(0:dt:42));
Z_48(:,:) = Z_temp(7,:,1:length(0:dt:48));
Z_72(:,:) = Z_temp(8,:,1:length(0:dt:72));

%% figure 0 prob vs time for tf
line_thickness = 3;
dt = 20/3600;    % dt = 20s, tf = 12 hours

figure;

%prob_A_t = zeros(length(optimal_params_save),length(span_A));
prob_final_times = [12,18,24,36,48];
%color_cell = {'r','y','g','','c','',[250/255,107/255,242/255],''};
color_cell = {[0,0,0],[0.2,0.2,0.2],[0.4,0.4,0.4],'',[0.6,0.6,0.6],'',[0.8,0.8,0.8],''};
for tf_idx = 1:length(optimal_params_save)
    prob_A_t = zeros(1,length(tf_vector(tf_idx)));
    if (ismember(tf_vector(tf_idx), prob_final_times)) 
    t = 0:dt:tf_vector(tf_idx);
    for i = 1:length(t)
        prob_A_t(1,i) = probability(Z_temp(tf_idx,7,i), optimal_params_save(:,tf_idx), probability_switch_pt_initial_guess, noise_on, 0);
    end   
    
    plot (t, prob_A_t(1,:), 'color', color_cell{tf_idx},'Linewidth', line_thickness)
    hold on
    end
end    


frac = [9.5/12, 14.3/18, 18.5/24, 23.2/36, 24/48];

xlabel('Time [hours]')
ylabel('Probability')
ylim ([0,1]);
xlim([0,48]);
xticks([6 12 18 24 30 36 42 48])
%xticks([10 10.5 11 11.5 12 12.5 13 13.5 14])
%xticklabels({'10^{10}','10^{10.5}','10^{11}','10^{11.5}','10^{12}','10^{12.5}','10^{13}','10^{13.5}','10^{14}'})
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
%set(gca,'xscale','log')

% set(gca,'TickLabelInterpreter', 'latex');
fig.PaperUnits = 'inches';
pbaspect([2.5 1.5 1])
%legend('2 hours','6 hours','12 hours','24 hours','36 hours','48 hours','72 hours','96 hours','120 hours','240 hours')
%legend('4 hours','8 hours','10 hours','12 hours','14 hours', '16 hours')
%legend('12 hours','18 hours','24 hours','30 hours','36 hours', '42 hours', '48 hours')
legend('12 hours','18 hours','24 hours','36 hours','48 hours')



%% figure 1 prob vs A for all tf
for i = 0:1000
    span_A(i+1) = 10^(9 + i/1000*8);
end


figure;
prob_A = zeros(length(optimal_params_save),length(span_A));
prob_final_times = [12,18,24,36,48];
%color_cell = {'r','y','g','','c','',[250/255,107/255,242/255],''};
color_cell = {[0,0,0],[0.2,0.2,0.2],[0.4,0.4,0.4],'',[0.6,0.6,0.6],'',[0.8,0.8,0.8],''};
for tf_idx = 1:length(optimal_params_save)
    if (ismember(tf_vector(tf_idx), prob_final_times))   
    for i = 1:length(span_A)
        prob_A(tf_idx, i) = probability(span_A(i), optimal_params_save(:,tf_idx), probability_switch_pt_initial_guess, noise_on, 0);
    end   
    
    plot ((span_A),prob_A(tf_idx,:), 'color', color_cell{tf_idx},'Linewidth', line_thickness)
    hold on
    end
end    

xlabel('$\mathrm{A~[molecules/\mu m^3]}$','Interpreter','latex')
ylabel('Probability','Interpreter','latex')
ylim ([0,1]);
xlim([1e12,1e15]);
xticks([1e12 1e13 1e14 1e15])
xticklabels({1,10,100,1000})

set(gca,'TickLabelInterpreter','latex')
%xticks([10 10.5 11 11.5 12 12.5 13 13.5 14])
%xticklabels({'10^{10}','10^{10.5}','10^{11}','10^{11.5}','10^{12}','10^{12.5}','10^{13}','10^{13.5}','10^{14}'})
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
set(gca,'xscale','log')

% set(gca,'TickLabelInterpreter', 'latex');
fig.PaperUnits = 'inches';
pbaspect([2.5 1.5 1])
%legend('2 hours','6 hours','12 hours','24 hours','36 hours','48 hours','72 hours','96 hours','120 hours','240 hours')
%legend('4 hours','8 hours','10 hours','12 hours','14 hours', '16 hours')
%legend('12 hours','18 hours','24 hours','30 hours','36 hours', '42 hours', '48 hours')
legend('12 hours','18 hours','24 hours','36 hours','48 hours','Interpreter','latex')
legend boxoff

%% figure 2a E(tf) and L(tf)
state_final = zeros(2,length(tf_vector));
frac_end = state_final;
for tf_idx = 1:length(tf_vector)
    dt = 20/3600;    % dt = 20s, tf = 12 hours
    t = 0:dt:tf_vector(tf_idx);
    Z = forward_euler(Z0, optimal_params_save(:,tf_idx), t, dt, noise_on, 0);
    state_final(:,tf_idx) = Z(3:4,end);
    frac_end(1,tf_idx) = state_final(1,tf_idx)/(state_final(1,tf_idx)+state_final(2,tf_idx));
    frac_end(2,tf_idx) = 1 - frac_end(1,tf_idx);
end    
figure;
subplot(1,2,1)

plot(tf_vector, frac_end(1,:),'color', [0.3,0.3,0.3], 'Marker',  'o', 'MarkerSize',9,'Linewidth', line_thickness)
hold on
plot(tf_vector, frac_end(2,:), 'color', [0.7,0.7,0.7], 'Marker', 'o', 'MarkerSize',9,'Linewidth', line_thickness)
xlabel('Time [hours]','Interpreter','latex')
ylabel('Fraction','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
fig.PaperUnits = 'inches';
pbaspect([2.5 2.5 1])
legend('Fraction of E','Fraction of L','Interpreter','latex')
legend boxoff
xlim([12,48])
xticks([12,24,36,48])
set(gca,'TickLabelInterpreter','latex')



% figure 2b growth rate
phi = 3.4*10^(-10);
d_V = 0.05; 
E_0 = phi*S0*V0/(phi*S0+d_V);
rho = zeros(1,length(tf_vector));
figure;
subplot(1,2,2)
for tf_idx = 1:length(tf_vector)
    rho(tf_idx) = 1/tf_vector(tf_idx)*log((state_final(1,tf_idx)+state_final(2,tf_idx))/E_0);
end  
plot(tf_vector, rho(1,:), 'color', [0,0,0], 'Marker','o', 'MarkerSize',9,'Linewidth', line_thickness)
hold on 
yline(0)
xlabel('Time [hours]','Interpreter','latex')
ylabel('Reproductive Rate','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
fig.PaperUnits = 'inches';
pbaspect([2.5 2.5 1])
xlim([12,48])
xticks([12,24,36,48])
set(gca,'TickLabelInterpreter','latex')


%% figure 4 and 5 E(t) and L(t) for fixed vs optimal
mixed_prob = 0.5;
% tf_vals = [4,10];
tf_vals = 1:length(tf_vector);
state_final_optimal = zeros(2,length(tf_vector));
state_final_lysis = zeros(2,length(tf_vector));
state_final_lysogeny = zeros(2,length(tf_vector));
state_final_half = zeros(2,length(tf_vector));

for tf_idx = 1:length(tf_vals)
    
    dt = 20/3600;    % dt = 20s, tf = 12 hours
    t = 0:dt:tf_vector(tf_vals(tf_idx));
    Z = forward_euler(Z0, optimal_params_save(:,tf_vals(tf_idx)), t, dt, noise_on, 0);
        
    Z_fixed_lysis = forward_euler(Z0, optimal_params_save(:,tf_vals(tf_idx)), t, dt, noise_on, 0.01);
    Z_fixed_mixed = forward_euler(Z0, optimal_params_save(:,tf_vals(tf_idx)), t, dt, noise_on, 0.5);
    Z_fixed_lysogeny = forward_euler(Z0, optimal_params_save(:,tf_vals(tf_idx)), t, dt, noise_on, 1);
    
    state_final_optimal(:,tf_idx) = Z(3:4,end);
    state_final_lysis(:,tf_idx) = Z_fixed_lysis(3:4,end);
    state_final_lysogeny(:,tf_idx) = Z_fixed_lysogeny(3:4,end);
    state_final_half(:,tf_idx) = Z_fixed_mixed(3:4,end);
    
%     figure;
%     plot(t, Z(3,:),'b', 'Linewidth', line_thickness)
%     hold on
%     plot(t, Z_fixed_lysis(3,:), '--b', 'Linewidth', line_thickness)
%     hold on
%     plot(t, Z_fixed_half(3,:), ':b', 'Linewidth', line_thickness)
%     hold on    
%     plot(t, Z_fixed_lysogeny(3,:), '-.b', 'Linewidth', line_thickness)
%     hold on   
%     
%     plot(t, Z(4,:), 'r', 'Linewidth', line_thickness)
%     hold on
%     
%     plot(t, Z_fixed_lysis(4,:), '--r', 'Linewidth', line_thickness)
%     hold on
%     plot(t, Z_fixed_half(4,:), ':r', 'Linewidth', line_thickness)
%     hold on    
%     plot(t, Z_fixed_lysogeny(4,:), '-.r', 'Linewidth', line_thickness)
%     hold on 
%     
%     xlabel('$Time~[hours]$','Interpreter','latex')
%     ylabel('$Population$','Interpreter','latex')
%     fig.PaperUnits = 'inches';
%     set(gcf, 'color', 'white');
%     set(gca, 'color', 'white');
%     set(gca,'FontSize',20);
%     fig.PaperUnits = 'inches';
%     pbaspect([2.5 2.5 1])
%     legend('E (Optimal)','E (Lysis)', 'E (Both)','E(Lysogeny)','L(Optimal)','L(Lysis)', 'L(Both)','L(Lysogeny)')

end

%% Figure final values comparison with fixed probability
%{
figure;
plot(tf_vector, state_final_optimal(1,:),'b', 'Linewidth', line_thickness)
hold on
plot(tf_vector, state_final_lysis(1,:), '--b', 'Linewidth', line_thickness)
hold on
plot(tf_vector, state_final_half(1,:), ':b', 'Linewidth', line_thickness)
hold on    
plot(tf_vector, state_final_lysogeny(1,:), '-.b', 'Linewidth', line_thickness)
hold on 
xlabel('$Time~[hours]$','Interpreter','latex')
ylabel('$Population$','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
fig.PaperUnits = 'inches';
pbaspect([2.5 2.5 1])
legend('E (Optimal)','E (Lysis)', 'E (Both)','E(Lysogeny)')

figure;
plot(tf_vector, state_final_optimal(2,:),'r', 'Linewidth', line_thickness)
hold on
plot(tf_vector, state_final_lysis(2,:), '--r', 'Linewidth', line_thickness)
hold on
plot(tf_vector, state_final_half(2,:), ':r', 'Linewidth', line_thickness)
hold on    
plot(tf_vector, state_final_lysogeny(2,:), '-.r', 'Linewidth', line_thickness)
hold on 
xlabel('$Time~[hours]$','Interpreter','latex')
ylabel('$Population$','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
fig.PaperUnits = 'inches';
pbaspect([2.5 2.5 1])
legend('L (Optimal)','L (Lysis)', 'L (Both)','L(Lysogeny)')

%}
figure;
plot(tf_vector, (state_final_optimal(1,:)+state_final_optimal(2,:)), 'color','k', 'Marker',ms{1}, 'MarkerSize',9,'Linewidth', line_thickness,'LineStyle', ls{1})
hold on
plot(tf_vector, (state_final_lysis(1,:)+state_final_lysis(2,:)), 'color','k', 'Marker',ms{2},'MarkerSize',9,'Linewidth', line_thickness,'LineStyle', ls{2})
hold on
plot(tf_vector, (state_final_half(1,:)+state_final_half(2,:)), 'color','k', 'Marker',ms{3}, 'MarkerSize',9,'Linewidth', line_thickness,'LineStyle', ls{3})
hold on    
plot(tf_vector, (state_final_lysogeny(1,:)+state_final_lysogeny(2,:)),'color','k', 'Marker',ms{4}, 'MarkerSize',9,'Linewidth', line_thickness,'LineStyle', ls{4})
hold on 
xlabel('Time [hours]','Interpreter','latex')
ylabel('$\mathrm{Population~[ml^{-1}]}$','Interpreter','latex')
ylim([1e2,1e7])
yticks([1e2 1e3 1e4 1e5 1e6 1e7 1e8])
xlim([12,48])
xticks([12 24 36 48])
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
fig.PaperUnits = 'inches';
pbaspect([2.5 1.5 1])
legend('E+L (Optimal)','E+L (Lysis)', 'E+L (Mixed)','E+L (Lysogeny)','Interpreter','latex')
set(gca,'yscale','log')
legend boxoff
set(gca,'TickLabelInterpreter','latex')

    
%% figures popuation dynamics for fixed strats for 48 hours
    mixed_prob = 0.5;
    dt = 20/3600;    % dt = 20s, tf = 12 hours
    t = 0:dt:48;
    index_for_48_hours = 7;
    Z = forward_euler(Z0, optimal_params_save(:,index_for_48_hours), t, dt, noise_on, 0);
    Z_48 = Z;
    save('Z_48.mat','Z')    
    Z_fixed_lysis = forward_euler(Z0, optimal_params_save(:,index_for_48_hours), t, dt, noise_on, 0.01);
    Z_fixed_mixed = forward_euler(Z0, optimal_params_save(:,index_for_48_hours), t, dt, noise_on, mixed_prob);
    Z_fixed_lysogeny = forward_euler(Z0, optimal_params_save(:,index_for_48_hours), t, dt, noise_on, 1);
    
    % lysis only
    figure;
    subplot(1,3,1)
    plot(t, (Z_fixed_lysis(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysis(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysis(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysis(6,:)),  'Linewidth', line_thickness)
    hold on
    %plot(t, log10(Z_fixed_lysis(7,:)),  'Linewidth', line_thickness)    
    %xlabel('$Time~[hours]$','Interpreter','latex')
    ylabel('$\mathrm{Population~[ml^{-1}}]$','Interpreter','latex')
    xticks([0,24,48]);
    ylim([1e3, 1e9]);
    yticks([1e3  1e5  1e7 1e9])
    xlim([0,48])
    title('P = 0','Interpreter','latex')
    %legend('S','E','L','V')
    set(gca,'FontSize',20);
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')


    fig.PaperUnits = 'inches';
    pbaspect([2.5 2.5 1])

    % lysogeny only
    subplot(1,3,3)
    plot(t, (Z_fixed_lysogeny(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysogeny(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysogeny(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysogeny(6,:)),  'Linewidth', line_thickness)
    hold on
    %plot(t, log10(Z_fixed_lysogeny(7,:)),  'Linewidth', line_thickness)
    %xlabel('$Time~[hours]$','Interpreter','latex')
    xticks([0,24,48]);
    xlim([0,48])
    ylim([1e3, 1e9]);
    yticks([1e3  1e5  1e7 1e9])
    yticklabels({'10^3','10^5','10^7','10^9'})    
    %ylabel('$Population~[ml^{-1}]$','Interpreter','latex')
    title('P = 1','Interpreter','latex')
    legend('S','E','L','V','Interpreter','latex')
    legend boxoff
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    pbaspect([2.5 2.5 1])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    % mixed strat
    subplot(1,3,2)
    plot(t, (Z_fixed_mixed(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_mixed(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_mixed(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_mixed(6,:)),  'Linewidth', line_thickness)
    hold on
    %plot(t, log10(Z_fixed_half(7,:)),  'Linewidth', line_thickness)
    xlabel('Time [hours]','Interpreter','latex')
    xticks([0,24,48]);
    xlim([0,48])
    ylim([1e3, 1e9]);
    yticks([1e3  1e5  1e7 1e9])
    yticklabels({'10^3','10^5','10^7','10^9'})    
    %ylabel('$Population~[ml^{-1}]$','Interpreter','latex')
    title('P = 0.5','Interpreter','latex')
    %legend('S','E','L','V')    
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    pbaspect([2.5 2.5 1])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    % compare
    figure;
    %plot(t, log10(Z(3,:)+Z(4,:)),  'Linewidth', line_thickness)
    %hold on
    plot(t, (Z_fixed_lysis(3,:)+Z_fixed_lysis(4,:)), 'k--', 'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_mixed(3,:)+Z_fixed_mixed(4,:)),'k:',  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_fixed_lysogeny(3,:)+Z_fixed_lysogeny(4,:)),'k-.',  'Linewidth', line_thickness)
    
    fig.PaperUnits = 'inches';
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca,'FontSize',20);
    %set(gca,'TickLabelInterpreter', 'latex');
    fig.PaperUnits = 'inches';
    pbaspect([2.5 1 1])
    xlabel('Time [hours]','Interpreter','latex')
    xticks([0,6,12,18,24,30,36,42,48]);
    xlim([12,48])
    ylim([1e2, 1e6]);
    yticks([1e2 1e3  1e4  1e5  1e6 ])

    ylabel('$\mathrm{Birth~State~Population~[ml^{-1}]}$','Interpreter','latex')
    %title('$Total~birth~states~comparison$','Interpreter','latex')
    legend('P = 0','P = 0.5','P = 1','Interpreter','latex')    
    pbaspect([2.5 1.5 1])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')
    legend boxoff
    
    %% 12, 18, 24, 48
    figure;
    subplot(2,8,[1,2])
    t = 0:dt:12;
    plot(t, (Z_12(2,:)), t, (Z_12(3,:)), t, (Z_12(4,:)),t, (Z_12(6,:)),'Linewidth', line_thickness)
    %xlabel('$Time~[hours]$','Interpreter','latex')
    %ylabel('$Population$','Interpreter','latex')
    xlim([0,12]);
    xticks([0  6 12])
    ylim([1e3, 1e9]);
    yticks([1e3,1e5, 1e7, 1e9])
    title('$\mathrm{T_{max}=12}$','Interpreter','latex')
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    %pbaspect([2.5 1.5 1])
    set(gca,'xticklabel',[])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    
    %figure;
    subplot(2,8,[9,11])
    t = 0:dt:18;
    plot(t, (Z_18(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_18(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_18(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_18(6,:)),  'Linewidth', line_thickness)
    hold on
    %xlabel('$Time~[hours]$','Interpreter','latex')
    %ylabel('$Population$','Interpreter','latex')
    title('$\mathrm{T_{max}=18}$','Interpreter','latex')
    xlim([0,18]);
    xticks([0  6 12 18])
    ylim([1e3, 1e9]);
    yticks([1e3 1e5 1e7 ])
    %legend('S','E','L','V')
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    %pbaspect([2.5 1.5 1])
    set(gca,'xticklabel',[])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    figure;
    subplot(2,8,[1,4]);
    t = 0:dt:24;
    plot(t, (Z_24(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_24(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_24(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_24(6,:)),  'Linewidth', line_thickness)
    hold on
    %xlabel('$Time~[hours]$','Interpreter','latex')
    ylabel('$\mathrm{Population~[ml^{-1}]}$','Interpreter','latex')
    title('$\mathrm{T_{max}=24}$','Interpreter','latex')
    xlim([0,24]);
    xticks([0  6 12 18 24])
    ylim([1e3, 1e9]);
    yticks([1e3 1e5 1e7])
    %legend('S','E','L','V')
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    %pbaspect([2.5 1.5 1])
    set(gca,'xticklabel',[])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    figure;
    subplot(2,8,[1,6]);
    t = 0:dt:36;
    plot(t, (Z_36(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_36(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_36(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_36(6,:)),  'Linewidth', line_thickness)
    hold on
    %xlabel('$Time~[hours]$','Interpreter','latex')
    %ylabel('$Population$','Interpreter','latex')
    xlim([0,36]);
    xticks([0  12 24 36])
    ylim([1e3, 1e9]);
    yticks([1e3 1e5 1e7 ])
    %legend('S','E','L','V')
    title('$\mathrm{T_{max}=36}$','Interpreter','latex')
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    %pbaspect([2.5 1.5 1])
    set(gca,'xticklabel',[])
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

   
    %figure;
    subplot(2,8,[9,16]);
    t = 0:dt:48;
    plot(t, (Z_48(2,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_48(3,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_48(4,:)),  'Linewidth', line_thickness)
    hold on
    plot(t, (Z_48(6,:)),  'Linewidth', line_thickness)
    hold on
    xlabel('Time [hours]','Interpreter','latex')
    %ylabel('$Population$','Interpreter','latex')
    xlim([0,48]);
    xticks([0  12 24 36 48])
    ylim([1e3, 1e9]);
    yticks([1e3 1e5 1e7])
    %legend('S','E','L','V')
    title('$\mathrm{T_{max}=48}$','Interpreter','latex')
    set(gca,'FontSize',20);
    fig.PaperUnits = 'inches';
    %pbaspect([2.5 1.5 1])
    legend('S','E','L','V','Interpreter', 'latex')
    legend boxoff
    set(gca,'yscale','log')
    set(gca,'TickLabelInterpreter','latex')

    
    
    
%% comparison table
Z_end = zeros(12,3);
t = 0:dt:48;
idx = 1;
for prob = 0:0.1:1
    idx = idx+1;
    prob_new = prob;
    if prob == 0
        prob_new = 0.01;
    end    
    Z_temp = forward_euler(Z0, optimal_params_save(:,7), t, dt, noise_on, prob_new);
    Z_end(idx,1:2) = Z_temp(3:4,end);
    Z_end(idx,3) = Z_end(idx,1)+Z_end(idx,2);
end

Z_end(1,1:2) = Z_48(3:4,end);
Z_end(1,3) = Z_end(1,1)+Z_end(1,2);
Z_end_log = log(Z_end);
figure;
H = bar((Z_end(:,1:2)),'stacked');
ylabel('$\mathrm{Population~[ml^{-1}]}$','Interpreter','latex')
xlabel('Lysogeny Probability, P','Interpreter','latex')
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
set(gca,'yscale','log')
xticks(1:12)
yticks([1,1e2,1e4,1e6])

xticklabels({'Optimal', 'P=0','P=0.1','P=0.2','P=0.3','P=0.4','P=0.5','P=0.6','P=0.7','P=0.8','P=0.9','P=1'})
xticklabels({'Optimal', '0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
legend('Exposed Cells','Lysogens','Interpreter','latex')
H(1).FaceColor = [0.3,0.3,0.3];
H(2).FaceColor = [0.7,0.7,0.7];
axis tight
ylim([1,1e6])
yticks([1,1e2,1e4,1e6])
set(gca,'TickLabelInterpreter','latex')
pbaspect([2.5 1.5 1])
legend boxoff

 %% different  J
load('optimal_params_different_J.mat') 
figure;
for i = 1:4
    vec = zeros(1,8);
    for j = 1:8
        vec(1,j) = optimal_params_different_J(i,2,j);
    end    
    plot(tf_vector(1:7),vec(1:7), 'color', 'k','Marker',ms{i}, 'MarkerSize',9,'Linewidth', 3, 'LineStyle', ls{i})
    hold on
end
legend('J = 0','J = 1','J = 2','J = 3','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
xlabel('Time [Hours]','Interpreter','latex')
ylabel('$\mathrm{Switch~Point~[molecules/\mu m^3]}$','Interpreter','latex')
xlim([12,48])
xticks([12,18,24,30,36,42,48])
pbaspect([2.5 1.5 1])
set(gca,'TickLabelInterpreter','latex')
legend boxoff



 %% different initial r0
load('optimal_params_different_r0.mat') 

%color_cell = {'r','y','g','c'};


figure;
for i = 1:4
    vec = zeros(1,8);
    for j = 1:8
        vec(1,j) = optimal_params_different_r0(i,2,j);
    end    
    plot(tf_vector(1:7),vec(1:7), 'color', 'k','Marker',ms{i}, 'MarkerSize',9,'Linewidth', 3, 'LineStyle', ls{i})
    hold on
end
legend('$\mathrm{R_0 = 40}$','$\mathrm{R_0 = 60}$','$\mathrm{R_0 = 80}$','$\mathrm{R_0 = 100}$','Interpreter','latex')
fig.PaperUnits = 'inches';
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca,'FontSize',20);
xlabel('Time [Hours]','Interpreter','latex')
ylabel('$\mathrm{Switch~Point~[molecules/\mu m^3]}$','Interpreter','latex')
xlim([12,48])
xticks([12,18,24,30,36,42,48])
set(gca,'TickLabelInterpreter','latex')
pbaspect([2.5 1.5 1])
legend boxoff


