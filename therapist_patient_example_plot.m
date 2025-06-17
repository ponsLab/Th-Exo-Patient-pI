%% Exo - conventional joint angle example


colorCell = {[0 0.4470 0.7410], [0.6350 0.0780 0.1840], [0.5, 0.8, 0.4], [17 17 17]/255};
font_size = 20;
pareticRight = {true, true, true, NaN, NaN, false, NaN, NaN, true, NaN, false, true, false}; % vector for all users

label = {'', ''};
line_width = 1.5;
plotFlag = false;

userId = 13;
s = 2;
patientDofOrder = [1 2 3 4];
therapistDofOrder = [3 4 1 2];

ylims = {[-30 55],[-35 82],[-25 55],[-30 82]};
textplace = {[5 42.5],[5 65],[5 42.5],[5 65]};
texttext = {'Hip', 'Knee', 'Hip', 'Knee'};

if pareticRight{userId}
    ptext = {'NP', 'NP', 'P', 'P'};
else
    ptext = {'P', 'P', 'NP', 'NP'};
end

figs = {figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987])};

set(0,'CurrentFigure',figs{1});
sgtitle(['Joint angle comparison'],'FontSize',1.25*font_size,'FontName','Times');
hold on;
for dofId = 1:4
    dof_pat = patientDofOrder(dofId);
    dof_thera = therapistDofOrder(dofId);

    if dof_pat == 1 || dof_pat == 3
        q_pat_train_v1 = -1*user(userId).visit(1).imu.jointAngle.best_norm{s,dof_pat};
        q_pat_train_v2 = -1*user(userId).visit(2).imu.jointAngle.best_norm{s,dof_pat};
        q_pat_base_v1 = -1*user(userId).visit(2).imu.jointAngle.best_norm{4,dof_pat};
    else
        q_pat_train_v1 = user(userId).visit(1).imu.jointAngle.best_norm{s,dof_pat};
        q_pat_train_v2 = user(userId).visit(2).imu.jointAngle.best_norm{s,dof_pat};
        q_pat_base_v1 = user(userId).visit(2).imu.jointAngle.best_norm{4,dof_pat};
    end

    q_pat_train_v1 = rad2deg(q_pat_train_v1 - mean(q_pat_train_v1,1));
    q_pat_train_v2 = rad2deg(q_pat_train_v2 - mean(q_pat_train_v2,1));
    q_pat_base_v1 = rad2deg(q_pat_base_v1 - mean(q_pat_base_v1,1));

    if dof_thera == 4 || dof_thera == 2
        q_thera_train_v1 = -1*user(userId).visit(1).robotData.b.q.best_norm{s,dof_thera};
    else
        q_thera_train_v1 = user(userId).visit(1).robotData.b.q.best_norm{s,dof_thera};
    end

    q_thera_train_v1 = rad2deg(q_thera_train_v1 - mean(q_thera_train_v1,1));

    subplot(2,2,dofId);
    p1 = shadedErrorBar(1:100,mean(q_pat_train_v1,2),std(q_pat_train_v1,[],2),'lineProps',{'Color',colorCell{1}, 'LineWidth', 1.2*line_width, 'DisplayName', 'dyad - patient'}); hold on;
    p2 = shadedErrorBar(1:100,mean(q_pat_train_v2,2),std(q_pat_train_v2,[],2),'lineProps',{'Color',colorCell{2}, 'LineWidth', 1.2*line_width, 'DisplayName', 'conv - patient'});
    p3 = shadedErrorBar(1:100,mean(q_thera_train_v1,2),std(q_thera_train_v1,[],2),'lineProps',{'Color',[0.2 0.7 0.2], 'LineWidth', 1.2*line_width, 'DisplayName', 'dyad - therapist'});
    p4 = shadedErrorBar(1:100,mean(q_pat_base_v1,2),std(q_pat_base_v1,[],2),'lineProps',{'Color',[0.25 0.25 0.25], 'LineWidth', 1.2*line_width, 'DisplayName', 'baseline - patient'});
    grid('on');
    ylabel('Joint angle [deg]');
    xlabel('% of Gait Cycle');
    ylim(ylims{dofId});
    if dofId == 2
        lgd = legend([p1.mainLine,p2.mainLine,p3.mainLine,p4.mainLine]);
        % lgd.Box = 'off';
    end

    text(textplace{dofId}(1),textplace{dofId}(2),[ptext{dofId} ' - ' texttext{dofId}],'FontSize',14);
    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';

    % EMG ALSO IN SEPARATE SUBPLOTS/

end
print('-painters','-dsvg','-r300',['Figures/example_joint_angles-' date]);
