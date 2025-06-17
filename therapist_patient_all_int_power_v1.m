%% interaction power analysis

set(0,'DefaultFigureWindowStyle','docked')

%% plot variables 
userIds = [1 2 3 6 9 11 12 13];%
userWeights= [55 65 72 95 100 100 90 80];

colorCell = {[0 0.4470 0.7410], [255,69,0]./255, [0.5, 0.8, 0.4], [17 17 17]/255};
font_size = 20;
encoderFlag = false;
pareticRight = {true, true, true, false, true, false, true, false}; % vector for all users

label = {'', ''};
line_width = 1.5;
plotFlag = false;

user_p = user;
jointNames = {'Left Hip', 'Left Knee', 'Right Hip', 'Right Knee'};
jointParetic = {'Paretic Hip', 'Paretic Knee', 'Non-paretic Hip', 'Non-paretic Knee'};

bas_str = struct('pareticHip', [], 'pareticKnee', [], 'NoTpareticHip', [], 'NoTpareticKnee', []);
all_users_together_single_robot = struct('q', bas_str, 'qdot', bas_str, 'intTorque', bas_str, 'intPower', bas_str, 'desIntTorque', bas_str);
all_users_together = struct('a', all_users_together_single_robot, 'b', all_users_together_single_robot);


%% time series calculation
userCnt = 0;
mirrored_dict = dictionary([1, 2,3,4], [3, 4, 1, 2]);

for userId = userIds
    userCnt = userCnt + 1;
    if pareticRight{userCnt}
        jointList = [3 4 1 2];
    else
        jointList = [1 2 3 4];
    end

    for session = 1:3
        for joint = 1:4
            % therapist
            int_tor_a = user_p(userId).visit(1).robotData.a.intTorque.best_norm{session, joint+1};
            int_tor_a = int_tor_a./userWeights(userCnt);
            int_tor_b = user_p(userId).visit(1).robotData.b.intTorque.best_norm{session, mirrored_dict(joint)+1};
            int_tor_b = int_tor_b./55;
            qd_b = user_p(userId).visit(1).robotData.b.qd.best_norm{session, mirrored_dict(joint)};
            qd_a = user_p(userId).visit(1).robotData.a.qd.best_norm{session, joint};
            q_b = user_p(userId).visit(1).robotData.b.q.best_norm{session, mirrored_dict(joint)};
            q_a = user_p(userId).visit(1).robotData.a.q.best_norm{session, joint};
            des_int_tor_a = user_p(userId).visit(1).robotData.a.desIntTorque.best_norm{session, joint+1};
            %des_int_tor_a = des_int_tor_a; %./userWeights(userCnt);
            des_int_tor_b = user_p(userId).visit(1).robotData.b.desIntTorque.best_norm{session, mirrored_dict(joint)+1};
            %des_int_tor_b = des_int_tor_b./55;
            int_pow_b = int_tor_b.*qd_b;
            int_pow_a = int_tor_a.*qd_a;

            if pareticRight{userCnt}
                if joint ==1
                    % non paretic hip
                    all_users_together.a.q.NoTpareticHip = [all_users_together.a.q.NoTpareticHip, q_a];
                    all_users_together.b.q.NoTpareticHip = [all_users_together.b.q.NoTpareticHip, q_b];
                    all_users_together.a.qdot.NoTpareticHip = [all_users_together.a.qdot.NoTpareticHip, qd_a];
                    all_users_together.b.qdot.NoTpareticHip =[all_users_together.b.qdot.NoTpareticHip, qd_b];
                    all_users_together.a.intTorque.NoTpareticHip =[all_users_together.a.intTorque.NoTpareticHip, int_tor_a];
                    all_users_together.b.intTorque.NoTpareticHip =[all_users_together.b.intTorque.NoTpareticHip, int_tor_b];
                    all_users_together.a.desIntTorque.NoTpareticHip =[all_users_together.a.desIntTorque.NoTpareticHip, des_int_tor_a];
                    all_users_together.b.desIntTorque.NoTpareticHip =[all_users_together.b.desIntTorque.NoTpareticHip, des_int_tor_b];
                    all_users_together.a.intPower.NoTpareticHip = [all_users_together.a.intPower.NoTpareticHip, int_pow_a];
                    all_users_together.b.intPower.NoTpareticHip = [all_users_together.b.intPower.NoTpareticHip, int_pow_b];
                elseif joint ==2
                    % non paretic knee
                    all_users_together.a.q.NoTpareticKnee = [all_users_together.a.q.NoTpareticKnee, q_a];
                    all_users_together.b.q.NoTpareticKnee = [all_users_together.b.q.NoTpareticKnee, q_b];
                    all_users_together.a.qdot.NoTpareticKnee = [all_users_together.a.qdot.NoTpareticKnee, qd_a];
                    all_users_together.b.qdot.NoTpareticKnee =[all_users_together.b.qdot.NoTpareticKnee, qd_b];
                    all_users_together.a.intTorque.NoTpareticKnee =[all_users_together.a.intTorque.NoTpareticKnee, int_tor_a];
                    all_users_together.b.intTorque.NoTpareticKnee =[all_users_together.b.intTorque.NoTpareticKnee, int_tor_b];
                    all_users_together.a.intPower.NoTpareticKnee = [all_users_together.a.intPower.NoTpareticKnee, int_pow_a];
                    all_users_together.b.intPower.NoTpareticKnee = [all_users_together.b.intPower.NoTpareticKnee, int_pow_b];
                    all_users_together.a.desIntTorque.NoTpareticKnee =[all_users_together.a.desIntTorque.NoTpareticKnee, des_int_tor_a];
                    all_users_together.b.desIntTorque.NoTpareticKnee =[all_users_together.b.desIntTorque.NoTpareticKnee, des_int_tor_b];
                elseif joint ==3
                    % paretic hip
                    all_users_together.a.q.pareticHip = [all_users_together.a.q.pareticHip, q_a];
                    all_users_together.b.q.pareticHip = [all_users_together.b.q.pareticHip, q_b];
                    all_users_together.a.qdot.pareticHip = [all_users_together.a.qdot.pareticHip, qd_a];
                    all_users_together.b.qdot.pareticHip =[all_users_together.b.qdot.pareticHip, qd_b];
                    all_users_together.a.intTorque.pareticHip =[all_users_together.a.intTorque.pareticHip, int_tor_a];
                    all_users_together.b.intTorque.pareticHip =[all_users_together.b.intTorque.pareticHip, int_tor_b];
                    all_users_together.a.intPower.pareticHip = [all_users_together.a.intPower.pareticHip, int_pow_a];
                    all_users_together.b.intPower.pareticHip = [all_users_together.b.intPower.pareticHip, int_pow_b];
                    all_users_together.a.desIntTorque.pareticHip =[all_users_together.a.desIntTorque.pareticHip, des_int_tor_a];
                    all_users_together.b.desIntTorque.pareticHip =[all_users_together.b.desIntTorque.pareticHip, des_int_tor_b];
                else
                    % paretic knee
                    all_users_together.a.q.pareticKnee = [all_users_together.a.q.pareticKnee, q_a];
                    all_users_together.b.q.pareticKnee = [all_users_together.b.q.pareticKnee, q_b];
                    all_users_together.a.qdot.pareticKnee = [all_users_together.a.qdot.pareticKnee, qd_a];
                    all_users_together.b.qdot.pareticKnee =[all_users_together.b.qdot.pareticKnee, qd_b];
                    all_users_together.a.intTorque.pareticKnee =[all_users_together.a.intTorque.pareticKnee, int_tor_a];
                    all_users_together.b.intTorque.pareticKnee =[all_users_together.b.intTorque.pareticKnee, int_tor_b];
                    all_users_together.a.intPower.pareticKnee = [all_users_together.a.intPower.pareticKnee, int_pow_a];
                    all_users_together.b.intPower.pareticKnee = [all_users_together.b.intPower.pareticKnee, int_pow_b];
                    all_users_together.a.desIntTorque.pareticKnee =[all_users_together.a.desIntTorque.pareticKnee, des_int_tor_a];
                    all_users_together.b.desIntTorque.pareticKnee =[all_users_together.b.desIntTorque.pareticKnee, des_int_tor_b];
                end
            else
                if joint ==1
                    % paretic hip
                    all_users_together.a.q.pareticHip = [all_users_together.a.q.pareticHip, q_a];
                    all_users_together.b.q.pareticHip = [all_users_together.b.q.pareticHip, q_b];
                    all_users_together.a.qdot.pareticHip = [all_users_together.a.qdot.pareticHip, qd_a];
                    all_users_together.b.qdot.pareticHip =[all_users_together.b.qdot.pareticHip, qd_b];
                    all_users_together.a.intTorque.pareticHip =[all_users_together.a.intTorque.pareticHip, int_tor_a];
                    all_users_together.b.intTorque.pareticHip =[all_users_together.b.intTorque.pareticHip, int_tor_b];
                    all_users_together.a.intPower.pareticHip = [all_users_together.a.intPower.pareticHip, int_pow_a];
                    all_users_together.b.intPower.pareticHip = [all_users_together.b.intPower.pareticHip, int_pow_b];
                    all_users_together.a.desIntTorque.pareticHip =[all_users_together.a.desIntTorque.pareticHip, des_int_tor_a];
                    all_users_together.b.desIntTorque.pareticHip =[all_users_together.b.desIntTorque.pareticHip, des_int_tor_b];
                elseif joint ==2
                    % paretic knee
                    all_users_together.a.q.pareticKnee = [all_users_together.a.q.pareticKnee, q_a];
                    all_users_together.b.q.pareticKnee = [all_users_together.b.q.pareticKnee, q_b];
                    all_users_together.a.qdot.pareticKnee = [all_users_together.a.qdot.pareticKnee, qd_a];
                    all_users_together.b.qdot.pareticKnee =[all_users_together.b.qdot.pareticKnee, qd_b];
                    all_users_together.a.intTorque.pareticKnee =[all_users_together.a.intTorque.pareticKnee, int_tor_a];
                    all_users_together.b.intTorque.pareticKnee =[all_users_together.b.intTorque.pareticKnee, int_tor_b];
                    all_users_together.a.intPower.pareticKnee = [all_users_together.a.intPower.pareticKnee, int_pow_a];
                    all_users_together.b.intPower.pareticKnee = [all_users_together.b.intPower.pareticKnee, int_pow_b];
                    all_users_together.a.desIntTorque.pareticKnee =[all_users_together.a.desIntTorque.pareticKnee, des_int_tor_a];
                    all_users_together.b.desIntTorque.pareticKnee =[all_users_together.b.desIntTorque.pareticKnee, des_int_tor_b];
                elseif joint ==3
                    % non paretic hip
                    all_users_together.a.q.NoTpareticHip = [all_users_together.a.q.NoTpareticHip, q_a];
                    all_users_together.b.q.NoTpareticHip = [all_users_together.b.q.NoTpareticHip, q_b];
                    all_users_together.a.qdot.NoTpareticHip = [all_users_together.a.qdot.NoTpareticHip, qd_a];
                    all_users_together.b.qdot.NoTpareticHip =[all_users_together.b.qdot.NoTpareticHip, qd_b];
                    all_users_together.a.intTorque.NoTpareticHip =[all_users_together.a.intTorque.NoTpareticHip, int_tor_a];
                    all_users_together.b.intTorque.NoTpareticHip =[all_users_together.b.intTorque.NoTpareticHip, int_tor_b];
                    all_users_together.a.intPower.NoTpareticHip = [all_users_together.a.intPower.NoTpareticHip, int_pow_a];
                    all_users_together.b.intPower.NoTpareticHip = [all_users_together.b.intPower.NoTpareticHip, int_pow_b];
                    all_users_together.a.desIntTorque.NoTpareticHip =[all_users_together.a.desIntTorque.NoTpareticHip, des_int_tor_a];
                    all_users_together.b.desIntTorque.NoTpareticHip =[all_users_together.b.desIntTorque.NoTpareticHip, des_int_tor_b];
                else
                    % non paretic knee
                    all_users_together.a.q.NoTpareticKnee = [all_users_together.a.q.NoTpareticKnee, q_a];
                    all_users_together.b.q.NoTpareticKnee = [all_users_together.b.q.NoTpareticKnee, q_b];
                    all_users_together.a.qdot.NoTpareticKnee = [all_users_together.a.qdot.NoTpareticKnee, qd_a];
                    all_users_together.b.qdot.NoTpareticKnee =[all_users_together.b.qdot.NoTpareticKnee, qd_b];
                    all_users_together.a.intTorque.NoTpareticKnee =[all_users_together.a.intTorque.NoTpareticKnee, int_tor_a];
                    all_users_together.b.intTorque.NoTpareticKnee =[all_users_together.b.intTorque.NoTpareticKnee, int_tor_b];
                    all_users_together.a.intPower.NoTpareticKnee = [all_users_together.a.intPower.NoTpareticKnee, int_pow_a];
                    all_users_together.b.intPower.NoTpareticKnee = [all_users_together.b.intPower.NoTpareticKnee, int_pow_b];
                    all_users_together.a.desIntTorque.NoTpareticKnee =[all_users_together.a.desIntTorque.NoTpareticKnee, des_int_tor_a];
                    all_users_together.b.desIntTorque.NoTpareticKnee =[all_users_together.b.desIntTorque.NoTpareticKnee, des_int_tor_b];
                end
            end
         
        end
    end
end


%% plot results all together

figs = {figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987])};
set(0,'CurrentFigure',figs{1});
%sgtitle(['U' num2str(userCnt)],'FontSize',1.25*font_size,'FontName','Times');

%kinematics
% paretic hip
subplot(5,4,1);
%plot_info(all_users_together.a.q.pareticHip, all_users_together.b.q.pareticHip);
grid('on');
title('Paretic Hip','FontSize',font_size,'FontName','Times');
ylabel('Joint Kinematics [rad]');
ylim([-0.5 1.5]);

% non paretic hip
subplot(5,4,2);
%plot_info(all_users_together.a.q.NoTpareticHip, all_users_together.b.q.NoTpareticHip);
grid('on');
title('Non Paretic Hip','FontSize',font_size,'FontName','Times');
ylim([-0.5 1.5]);

% paretic knee
subplot(5,4,3);
%plot_info(all_users_together.a.q.pareticKnee, all_users_together.b.q.pareticKnee);
grid('on');
title('Paretic Knee','FontSize',font_size,'FontName','Times');
ylim([-2 0]);


% non paretic knee
subplot(5,4,4);
%plot_info(all_users_together.a.q.NoTpareticKnee, all_users_together.b.q.NoTpareticKnee);
grid('on');
title('Non Paretic Knee','FontSize',font_size,'FontName','Times');
ylim([-2 0]);

%velocity
% paretic hip
subplot(5,4,5);
%plot_info(all_users_together.a.qdot.pareticHip, all_users_together.b.qdot.pareticHip);
grid('on');
ylabel('Joint Velocity [rad/s]');
ylim([-2.5 3]);

% paretic knee
subplot(5,4,7);
%plot_info(all_users_together.a.qdot.pareticKnee, all_users_together.b.qdot.pareticKnee);
grid('on');
ylim([-5 5]);

% non paretic hip
subplot(5,4,6);
%plot_info(all_users_together.a.qdot.NoTpareticHip, all_users_together.b.qdot.NoTpareticHip);
grid('on');
ylim([-2.5 3]);

% non paretic knee
subplot(5,4,8);
%plot_info(all_users_together.a.qdot.NoTpareticKnee, all_users_together.b.qdot.NoTpareticKnee);
grid('on');
ylim([-5 5]);

%Int torque
% paretic hip
subplot(5,4,9);
%plot_info(all_users_together.a.intTorque.pareticHip, all_users_together.b.intTorque.pareticHip);
grid('on');
ylabel('Int Forces [Nm/kg]');
ylim([-0.5 0.5]);

% paretic knee
subplot(5,4,11);
plot_info(all_users_together.a.intTorque.pareticKnee, all_users_together.b.intTorque.pareticKnee);
grid('on');
ylim([-0.5 0.5]);

% non paretic hip
subplot(5,4,10);
%plot_info(all_users_together.a.intTorque.NoTpareticHip, all_users_together.b.intTorque.NoTpareticHip);
grid('on');
ylim([-0.5 0.5]);

% non paretic knee
subplot(5,4,12);
plot_info(all_users_together.a.intTorque.NoTpareticKnee, all_users_together.b.intTorque.NoTpareticKnee);
grid('on');
ylim([-0.5 0.5]);

%Int Pwr
% paretic hip
subplot(5,4,13);
%plot_info(all_users_together.a.intPower.pareticHip, all_users_together.b.intPower.pareticHip);
grid('on');
ylabel('Int Power [Nm rad/s kg]');
%xlabel('% of gait cycle');
ylim([-0.6 0.6]);

% paretic knee
subplot(5,4,15);
%plot_info(all_users_together.a.intPower.pareticKnee, all_users_together.b.intPower.pareticKnee);
grid('on');
%xlabel('% of gait cycle');
ylim([-1 1]);

% non paretic hip
subplot(5,4,14);
%plot_info(all_users_together.a.intPower.NoTpareticHip, all_users_together.b.intPower.NoTpareticHip);
grid('on');
%xlabel('% of gait cycle');
ylim([-0.6 0.6]);

% non paretic knee
subplot(5,4,16);
%plot_info(all_users_together.a.intPower.NoTpareticKnee, all_users_together.b.intPower.NoTpareticKnee);
grid('on');
%xlabel('% of gait cycle');
ylim([-1 1]);

%Des Int Torque
% paretic hip
subplot(5,4,17);
%plot_info(all_users_together.a.desIntTorque.pareticHip, all_users_together.b.desIntTorque.pareticHip);
grid('on');
ylabel('Des Int Torque [Nm]');
xlabel('% of gait cycle');
ylim([-15 15]);

% paretic knee
subplot(5,4,19);
%plot_info(all_users_together.a.desIntTorque.pareticKnee, all_users_together.b.desIntTorque.pareticKnee);
grid('on');
xlabel('% of gait cycle');
ylim([-20 25]);

% non paretic hip
subplot(5,4,18);
%plot_info(all_users_together.a.desIntTorque.NoTpareticHip, all_users_together.b.desIntTorque.NoTpareticHip);
grid('on');
xlabel('% of gait cycle');
ylim([-15 15]);

% non paretic knee
subplot(5,4,20);
%plot_info(all_users_together.a.desIntTorque.NoTpareticKnee, all_users_together.b.desIntTorque.NoTpareticKnee);
grid('on');
xlabel('% of gait cycle');
ylim([-20 25]);


%% help function to plot 
function plot_info(value_a, value_b)
    shadedErrorBar(1:100, mean(value_a, 2), std(value_a,[], 2),'lineProps','b'); hold on;
    shadedErrorBar(1:100, mean(value_b, 2), std(value_b,[], 2),'lineProps','g'); hold on;
    plot(mean(value_a, 2), '-','Color','b','LineWidth',0.7); hold on;
    plot(mean(value_b, 2), '-','Color','g','LineWidth',0.7); hold on;
end
