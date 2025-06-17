%% load full dataset (dataset structure: user)
% load('C:\Users\mshort\OneDrive - Shirley Ryan AbilityLab\Documents\HRCEML\X2\matt_analysis\hip_norm_best_steps_withBaseline_IMURotwAnkle.mat')

% set(0,'DefaultFigureWindowStyle','default')
set(0,'DefaultFigureWindowStyle','default')

%% plot variables 
userIds = [1 2 3 6 9 11 12 13];%
% userIds = [12 13];%

colorCell = {[0 0.4470 0.7410], [0.6350 0.0780 0.1840], [0.5, 0.8, 0.4], [17 17 17]/255};
font_size = 16;
encoderFlag = false;
pareticRight = {true, true, true, false, true, false, true, false}; % vector for all users
% pareticRight = {true, false}; % vector for 12 and 13 users

label = {'', ''};
line_width = 1.5;
plotFlag = false;

%% compute spatiotemporal measures and plot ankle positions

% step length (maximum - minimum horizontal ankle position)
% step time (timing of maximum - minimum horizontal ankle position)
% foot clearance (maximum vertical ankle position)

% compute asymmetry between sides (1 - paretic / nonparetic); step length
% normalize paretic (1 - paretic / nonparetic); foot clearance
user_p = user;
for session = 1:4
figs = {figure; figure};

set(0,'CurrentFigure',figs{1});
sgtitle(['Left ankle data - session ' num2str(session)]);
hold on;

set(0,'CurrentFigure',figs{2});
sgtitle(['Right ankle data - session ' num2str(session)]);
hold on;

userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    for visitId = 1:2
        alpha_lowCut = user_p(userId).visit(visitId).alpha_low;
        alpha_highCut = 1 - alpha_lowCut;
        skipFlag = false;
        if visitId == 1 && userId == 3
            if size(user_p(userId).visit(visitId).robotData.a.anklePos.best_norm,1) < session
                skipFlag = true;
            else 
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm(session,1:2);
                aRDataAlt = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm_alt(session,3:4);

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm(session,3:4);
                aLDataAlt = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm_alt(session,1:2);

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        else
            if size(user_p(userId).visit(visitId).imu.anklePos.best_norm,1) < session
                skipFlag = true;
            else
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).imu.anklePos.best_norm(session,1:2);
                aRDataAlt = user_p(userId).visit(visitId).imu.anklePos.best_norm_alt(session,3:4);

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).imu.anklePos.best_norm(session,3:4);
                aLDataAlt = user_p(userId).visit(visitId).imu.anklePos.best_norm_alt(session,1:2);

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        end

        if ~skipFlag
            HS_event_right = round(gaitEventsNormL(:,3));
            HS_event_left = round(gaitEventsNormL(:,end));
            if plotFlag
                figure;
    
                for s = 1:size(gaitEventsNormL,1)
                    Lalpha_stride = aLAlpha(:,s);
                    plot(Lalpha_stride); hold on;
                    
                    % convert to events
                    plot(HS_event_right(s), Lalpha_stride(HS_event_right(s)), "v", "MarkerSize", 15, "Color","blue", 'MarkerFaceColor','blue');
                    plot(HS_event_left(s), Lalpha_stride(HS_event_left(s)), "v", "MarkerSize", 15, "Color","red", 'MarkerFaceColor','red');
    
                    ylim([-0.04 1.04]);
                    ylabel("\alpha");
                    xlabel("time [s]");
                end
                legend("raw", "HS_L", "HS_R");
                
                figure;
                sgtitle('Ankle positions'); hold on;
                subplot(1,2,1);
                a = plot(aLData{1},'b-','DisplayName','Left');
                hold on;
                b = plot(aRDataAlt{1},'r-','DisplayName','Right');
                c = xline(HS_event_right,'DisplayName','Right Heel Strike');
                box('off')
                legend([a(1), b(1), c(1)]);
                xlabel('% GC');
                ylabel('X Position');
                set(gca,'FontSize',14);
    
                subplot(1,2,2);
                a = plot(aLData{2},'b-','DisplayName','Left');
                hold on;
                b = plot(aRDataAlt{2},'r-','DisplayName','Right');
                c = xline(HS_event_right,'DisplayName','Right Heel Strike');
                box('off')
                xlabel('% GC');
                ylabel('X Position');
                legend([a(1), b(1), c(1)]);
                set(gca,'FontSize',14);
            end

            aRDataHS = zeros(1,length(HS_event_right));
            aLDataHS = zeros(1,length(HS_event_right));
            for s = 1:length(HS_event_right)
                aRDataHS(1,s) = aRDataAlt{1}(HS_event_right(s),s);
                aLDataHS(1,s) = aLData{1}(HS_event_right(s),s);
            end

            % STEPS
            aLData_step_length = aLData{1}(end,:) - aRDataAlt{1}(end,:); % left step length (x ankle pos)
            aRData_step_length = aRDataHS - aLDataHS; % right step length (x ankle pos)
            user_p(userId).visit(visitId).spatiotemporal.left.step_length{session,1} = aLData_step_length;
            user_p(userId).visit(visitId).spatiotemporal.right.step_length{session,1} = aRData_step_length;

            aLData_step_clear = max(aLData{1}) - min(aRData{1}); % left step clearance (y ankle pos)
            aRData_step_clear = max(aRData{1}) - min(aLData{1}); % right step length (y ankle pos)
            user_p(userId).visit(visitId).spatiotemporal.left.step_clearance{session,1} = aLData_step_clear;
            user_p(userId).visit(visitId).spatiotemporal.right.step_clearance{session,1} = aRData_step_clear;

            % STRIDES
            aLData_stride_length = max(aLData{1}) - min(aLData{1}); % left stride length (x ankle pos)
            aRData_stride_length = max(aRData{1}) - min(aRData{1}); % right stride length (x ankle pos)
            user_p(userId).visit(visitId).spatiotemporal.left.stride_length{session,1} = aLData_stride_length;
            user_p(userId).visit(visitId).spatiotemporal.right.stride_length{session,1} = aRData_stride_length;
    
            aLData_stride_clear = max(aLData{2}) - min(aLData{2}); % left foot clearance (y ankle pos)
            aRData_stride_clear = max(aRData{2}) - min(aRData{2}); % right foot clearance (y ankle pos)
            user_p(userId).visit(visitId).spatiotemporal.left.stride_clearance{session,1} = aLData_stride_clear;
            user_p(userId).visit(visitId).spatiotemporal.right.stride_clearance{session,1} = aRData_stride_clear;
    
            aLData_poly_area = zeros(size(aLData{1},2),1);
            aLData_work_area = zeros(size(aLData{1},2),1);
            for ns = 1:size(aLData{1},2)
                aLData_poly_area(ns) = polygon_area_polar(100*aLData{1}(:,ns), 100*aLData{2}(:,ns));
                aLData_work_area(ns) = polygon_area(100*aLData{1}(:,ns), 100*aLData{2}(:,ns));
            end
            user_p(userId).visit(visitId).spatiotemporal.left.poly_work_area{session,1} = aLData_poly_area;
            user_p(userId).visit(visitId).spatiotemporal.left.work_area{session,1} = aLData_work_area;

            aRData_poly_area = zeros(size(aRData{1},2),1);
            aRData_work_area = zeros(size(aRData{1},2),1);
            for ns = 1:size(aRData{1},2)
                aRData_poly_area(ns) = polygon_area_polar(100*aRData{1}(:,ns), 100*aRData{2}(:,ns));
                aRData_work_area(ns) = polygon_area(100*aRData{1}(:,ns), 100*aRData{2}(:,ns));
            end
            user_p(userId).visit(visitId).spatiotemporal.right.poly_work_area{session,1} = aRData_poly_area;
            user_p(userId).visit(visitId).spatiotemporal.right.work_area{session,1} = aRData_work_area;

            nstride = min([length(aLData_stride_length), length(aRData_stride_length)]);
            user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_length{session,1} = zeros(1,nstride);
            user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance{session,1} = zeros(1,nstride);
            user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_length{session,1} = zeros(1,nstride);
            user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_clearance{session,1} = zeros(1,nstride);
            for ns = 1: nstride
                if pareticRight{userCnt}
    
                    % % paretic/non para
                    % usernew(userId).visit(visitId).spatiotemporal.asymmetry.stride_length(ns) = abs(100*(1-aRData_stride_length(ns)/aLData_stride_length(ns)));
                    % usernew(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance(ns) = abs(100*(1 - aRData_stride_clear(ns)/aLData_stride_clear(ns)));
    
                    % diff/total (Padmanabhan 2020, Persons post-stroke improve step length symmetry by walking asymmetrically)
                    % usernew(userId).visit(visitId).spatiotemporal.asymmetry.stride_length(ns) = ...
                    %     abs(100*(aRData_stride_length(ns)-aLData_stride_length(ns))/(0.5*(aRData_stride_length(ns)+aLData_stride_length(ns))));
                    %
                    % usernew(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance(ns) = ...
                    %     abs(100*(aRData_stride_clear(ns) - aLData_stride_clear(ns))) / (0.5*(aRData_stride_clear(ns) + aLData_stride_clear(ns)));
    
                    % % sum asym (Lauzière S, Betschart M, Aissaoui R, Nadeau S (2014))
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_length{session,1}(ns) = 100*(aLData_stride_length(ns)-aRData_stride_length(ns))/(aLData_stride_length(ns)+aRData_stride_length(ns));
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance{session,1}(ns) = 100*(aLData_stride_clear(ns)-aRData_stride_clear(ns))/(aLData_stride_clear(ns)+aRData_stride_clear(ns));
    
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_length{session,1}(ns) = 100*(aLData_step_length(ns)-aRData_step_length(ns))/(aLData_step_length(ns)+aRData_step_length(ns));
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_clearance{session,1}(ns) = 100*(aLData_step_clear(ns)-aRData_step_clear(ns))/(aLData_step_clear(ns)+aRData_step_clear(ns));

                else
                    % % paretic/non para
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_length{session,1}(ns) = 100*(aRData_stride_length(ns)-aLData_stride_length(ns))/(aLData_stride_length(ns)+aRData_stride_length(ns));
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance{session,1}(ns) = 100*(aRData_stride_clear(ns)-aLData_stride_clear(ns))/(aLData_stride_clear(ns)+aRData_stride_clear(ns));

                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_length{session,1}(ns) = 100*(aRData_step_length(ns)-aLData_step_length(ns))/(aLData_step_length(ns)+aRData_step_length(ns));
                    user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_clearance{session,1}(ns) = 100*(aRData_step_clear(ns)-aLData_step_clear(ns))/(aLData_step_clear(ns)+aRData_step_clear(ns));
                end
            end
    
            set(0,'CurrentFigure',figs{1});
            nstride_plot = min([size(aLData{1},2), size(aLData{2},2)]);
            subplot(2,length(userIds),userCnt+length(userIds)*(visitId-1));
            hold on;
            alpha_color = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
            for stride = 1:nstride_plot
               scatter(aLData{1}(:, stride),aLData{2}(:, stride), 3, alpha_color(:, stride));
            end
            colormap(jet); % Set the colormap (e.g., 'jet', 'parula', 'hot', etc.)
            a = colorbar;      % Add a colorbar to show the mapping
            a.Label.String = 'Alpha';
            clim([0 1]); % Ensure color mapping is properly scaled
    
            xlim([-0.4 0.4])
            ylim([-0.8 -0.4])
            if ~pareticRight{userCnt}
                text(0.3,-0.45,'*','FontSize',14);
            end
            title(['User' num2str(userId) ' - Visit' num2str(visitId)]);
            xlabel('X ankle position (m)');
            ylabel('Y ankle position (m)');
    
            set(0,'CurrentFigure',figs{2});
            nstride_plot = min([size(aRData{1},2), size(aRData{2},2)]);
            subplot(2,length(userIds),userCnt+length(userIds)*(visitId-1));
            hold on;
            alpha_color = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
            for stride =1:nstride_plot
               scatter(aRData{1}(:, stride),aRData{2}(:, stride), 3, alpha_color(:, stride));
            end
            colormap(jet); % Set the colormap (e.g., 'jet', 'parula', 'hot', etc.)
            b=colorbar;      % Add a colorbar to show the mapping
            b.Label.String = 'Alpha';
            clim([0 1]); % Ensure color mapping is properly scaled
    
            xlim([-0.4 0.4])
            ylim([-0.8 -0.4])
            if pareticRight{userCnt}
                text(0.3,-0.45,'*','FontSize',14);
            end
            title(['User' num2str(userId) ' - Visit' num2str(visitId)]);
            xlabel('X ankle position (m)');
            ylabel('Y ankle position (m)');
        end
    end
end
end
%% Plot ankle trajectories in a different way
set(0,'DefaultFigureWindowStyle','default')

dn = {'dyad','conv'};
figs = {figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987]); figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987])};

set(0,'CurrentFigure',figs{1});
sgtitle(['Paretic ankle position'],'FontSize',1.25*font_size,'FontName','Times');
hold on;

set(0,'CurrentFigure',figs{2});
sgtitle(['Non-paretic ankle position'],'FontSize',1.25*font_size,'FontName','Times');
hold on;

for session = 1:4

userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    plot_p = cell(2,1);
    plot_np = cell(2,1);
    for visitId = 1:2
        alpha_lowCut = user_p(userId).visit(visitId).alpha_low;
        alpha_highCut = 1 - alpha_lowCut;
        skipFlag = false;
        if visitId == 1 && userId == 3
            if size(user_p(userId).visit(visitId).robotData.a.anklePos.best_norm,1) < session
                skipFlag = true;
            else 
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm(session,1:2);
                aRDataAlt = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm_alt(session,3:4);

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm(session,3:4);
                aLDataAlt = user_p(userId).visit(visitId).robotData.a.anklePos.best_norm_alt(session,1:2);

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        else
            if size(user_p(userId).visit(visitId).imu.anklePos.best_norm,1) < session
                skipFlag = true;
            else
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).imu.anklePos.best_norm(session,1:2);
                aRDataAlt = user_p(userId).visit(visitId).imu.anklePos.best_norm_alt(session,3:4);

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).imu.anklePos.best_norm(session,3:4);
                aLDataAlt = user_p(userId).visit(visitId).imu.anklePos.best_norm_alt(session,1:2);

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        end

        if ~skipFlag

            if session <= 3
                set(0,'CurrentFigure',figs{1});
                subplot(3,length(userIds),userCnt+length(pareticRight)*(session-1));
                hold on;
                if pareticRight{userCnt}
                    plot(100*aRData{1},100*aRData{2}, '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_p{visitId} = plot(100*mean(aRData{1},2),100*mean(aRData{2},2), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                else
                    plot(100*aLData{1},100*aLData{2}, '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_p{visitId} = plot(100*mean(aLData{1},2),100*mean(aLData{2},2), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                end
                grid('on');

                xlim(100*[-0.5 0.5]);
                ylim(100*[-0.85 -0.3]);
                if session == 1
                    title(['U' num2str(userCnt)],'FontSize',font_size,'FontName','Times');
                end
                ax = gca;
                ax.FontSize = font_size;
                ax.LineWidth = line_width;
                ax.FontName = 'Times';

                han=axes(figs{1},'visible','off'); 
                han.Title.Visible='on';
                han.XLabel.Visible='on';
                han.YLabel.Visible='on';
                ylabel(han,'Vertical ankle position (cm)','FontSize',font_size,'FontName','Times');
                xlabel(han,'Horizontal ankle position (cm)','FontSize',font_size,'FontName','Times');


                set(0,'CurrentFigure',figs{2});
                subplot(3,length(userIds),userCnt+length(pareticRight)*(session-1));
                hold on;
                if ~pareticRight{userCnt}
                    plot(100*aRData{1},100*aRData{2}, '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_np{visitId} = plot(100*mean(aRData{1},2),100*mean(aRData{2},2), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                else
                    plot(100*aLData{1},100*aLData{2}, '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_np{visitId} = plot(100*mean(aLData{1},2),100*mean(aLData{2},2), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                end
                grid('on');

                xlim(100*[-0.5 0.5]);
                ylim(100*[-0.85 -0.3]);
                if session == 1
                    title(['U' num2str(userCnt)],'FontSize',font_size,'FontName','Times');
                end
                ax = gca;
                ax.FontSize = font_size;
                ax.LineWidth = line_width;
                ax.FontName = 'Times';

                han=axes(figs{2},'visible','off'); 
                han.Title.Visible='on';
                han.XLabel.Visible='on';
                han.YLabel.Visible='on';
                ylabel(han,'Vertical ankle position (cm)','FontSize',font_size,'FontName','Times');
                xlabel(han,'Horizontal ankle position (cm)','FontSize',font_size,'FontName','Times');
            end
        end
    end
    if session == 1 && userCnt == length(pareticRight)
        set(0,'CurrentFigure',figs{1});
        legend([plot_p{1} plot_p{2}],'FontSize',font_size,'FontName','Times');

        set(0,'CurrentFigure',figs{2});
        legend([plot_np{1} plot_np{2}],'FontSize',font_size,'FontName','Times');
    end
end
end
set(0,'CurrentFigure',figs{1});
print('-painters','-dsvg','-r300',['Figures/ankle_traj_paretic-' date]);

set(0,'CurrentFigure',figs{2});
print('-painters','-dsvg','-r300',['Figures/ankle_traj_nonparetic-' date]);


%% Save video of the ankle position
userId_ = 13;
%[1 2 3 6 9 11 12 13];%
videoName = sprintf('Figures/ankle_trajectory_video_Patient%d_L', userId_);
v = VideoWriter(videoName);
v.FrameRate = 10; % Adjust as needed
open(v);

fig = figure('Position', [100 100 1000 600]);
hold on;
xlabel('Horizontal ankle position (cm)');
ylabel('Vertical ankle position (cm)');
title('Ankle trajectory over time');
grid on;
xlim(100*[-0.5 0.5]);
ylim(100*[-0.85 -0.3]);

% Example: animate mean ankle trajectory of one visit/session
% Assuming `aRData{1}` and `aRData{2}` are [timePoints x samples] arrays
for userId = userId_
    aRData_Visit1 = user_p(userId).visit(1).imu.anklePos.best_norm(1,1:2);
    aRData_Visit2 = user_p(userId).visit(2).imu.anklePos.best_norm(1,1:2);
    for s= 1:20
        for t = 1:size(aRData_Visit2{1}, 1)
            cla;
            % Paretic side example
            %plot(100*aRData{1},100*aRData{2}, '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
            if s>1
                x = 100 * aRData_Visit1{1}(:,1:s-1);
                y = 100 * aRData_Visit1{2}(:,1:s-1);
                plot(x, y, 'b-', 'LineWidth', 2);
        
                x = 100 * aRData_Visit2{1}(:,1:s-1);
                y = 100 * aRData_Visit2{2}(:,1:s-1);
                plot(x, y, 'r-', 'LineWidth', 2);
            end

            x = 100 * aRData_Visit1{1}(1:t,s);
            y = 100 * aRData_Visit1{2}(1:t,s);
            plot(x, y, 'b-', 'LineWidth', 2);
    
            x = 100 * aRData_Visit2{1}(1:t,s);
            y = 100 * aRData_Visit2{2}(1:t,s);
            plot(x, y, 'r-', 'LineWidth', 2);
            
            % Optional: draw gait event markers, etc.
            
            drawnow;
            frame = getframe(fig);
            writeVideo(v, frame);
        end
    end
end
close(v);


%% Plot cyclograms
set(0,'DefaultFigureWindowStyle','default')

dn = {'dyad','conv'};
figs = {figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987]); figure('Position',   1.0e+03*[0.0837    0.8503    1.4553    0.7987])};

set(0,'CurrentFigure',figs{1});
sgtitle(['Paretic cyclogram'],'FontSize',1.25*font_size,'FontName','Times');
hold on;

set(0,'CurrentFigure',figs{2});
sgtitle(['Non-paretic cyclogram'],'FontSize',1.25*font_size,'FontName','Times');
hold on;

for session = 1:4

userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    plot_p = cell(2,1);
    plot_np = cell(2,1);
    for visitId = 1:2
        alpha_lowCut = user_p(userId).visit(visitId).alpha_low;
        alpha_highCut = 1 - alpha_lowCut;
        skipFlag = false;
        if visitId == 1 && userId == 3
            if size(user_p(userId).visit(visitId).robotData.a.anklePos.best_norm,1) < session
                skipFlag = true;
            else 
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).robotData.a.q.best_norm(session,1:2);
                aLData{1} = aLData{1} - mean(mean(aLData{1}));
                aLData{2} = aLData{2} - mean(mean(aLData{2}));

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).robotData.a.q.best_norm(session,3:4);
                aRData{1} = aRData{1} - mean(mean(aRData{1}));
                aRData{2} = aRData{2} - mean(mean(aRData{2}));

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        else
            if size(user_p(userId).visit(visitId).imu.anklePos.best_norm,1) < session
                skipFlag = true;
            else
                aLAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,1};
                aLData = user_p(userId).visit(visitId).imu.jointAngle.best_norm(session,1:2);
                aLData{1} = aLData{1} - mean(mean(aLData{1}));
                aLData{2} = aLData{2} - mean(mean(aLData{2}));

                aRAlpha = user_p(userId).visit(visitId).robotData.a.alpha.best_norm{session,2};
                aRData = user_p(userId).visit(visitId).imu.jointAngle.best_norm(session,3:4);
                aRData{1} = aRData{1} - mean(mean(aRData{1}));
                aRData{2} = aRData{2} - mean(mean(aRData{2}));

                gaitEventsTimeL = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,1};
                gaitEventsNormL = zeros(size(gaitEventsTimeL));
                for s = 1:size(gaitEventsNormL,1)
                    gaitEventsNormL(s,:) = (gaitEventsTimeL(s,:) - min(gaitEventsTimeL(s,:))) ...
                                            / (max(gaitEventsTimeL(s,:)) - min(gaitEventsTimeL(s,:)))...
                                            * (100 - 1) + 1;
                end
                
                gaitEventsTimeR = user_p(userId).visit(visitId).robotData.a.timeEvents.best_t{session,2};
                gaitEventsNormR = zeros(size(gaitEventsTimeR));
                for s = 1:size(gaitEventsNormR,1)
                    gaitEventsNormR(s,:) = (gaitEventsTimeR(s,:) - min(gaitEventsTimeR(s,:))) ...
                                            / (max(gaitEventsTimeR(s,:)) - min(gaitEventsTimeR(s,:)))...
                                            * (100 - 1) + 1;
                end
            end
        end

        if ~skipFlag

            if session <= 3
                set(0,'CurrentFigure',figs{1});
                subplot(3,length(userIds),userCnt+length(pareticRight)*(session-1));
                hold on;
                if pareticRight{userCnt}
                    plot(rad2deg(aRData{2}),rad2deg(aRData{1}), '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_p{visitId} = plot(rad2deg(mean(aRData{2},2)),rad2deg(mean(aRData{1},2)), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                else
                    plot(rad2deg(aLData{2}),rad2deg(aLData{1}), '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_p{visitId} = plot(rad2deg(mean(aLData{2},2)),rad2deg(mean(aLData{1},2)), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                end
                grid('on');

                % xlim(100*[-0.5 0.5]);
                % ylim(100*[-0.85 -0.3]);
                if session == 1
                    title(['U' num2str(userCnt)],'FontSize',font_size,'FontName','Times');
                end
                ax = gca;
                ax.FontSize = font_size;
                ax.LineWidth = line_width;
                ax.FontName = 'Times';

                han=axes(figs{1},'visible','off'); 
                han.Title.Visible='on';
                han.XLabel.Visible='on';
                han.YLabel.Visible='on';
                ylabel(han,'Hip angle (deg)','FontSize',font_size,'FontName','Times');
                xlabel(han,'Knee angle (deg)','FontSize',font_size,'FontName','Times');


                set(0,'CurrentFigure',figs{2});
                subplot(3,length(userIds),userCnt+length(pareticRight)*(session-1));
                hold on;
                if ~pareticRight{userCnt}
                    plot(rad2deg(aRData{2}),rad2deg(aRData{1}), '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_np{visitId} = plot(rad2deg(mean(aRData{2},2)),rad2deg(mean(aRData{1},2)), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                else
                    plot(rad2deg(aLData{1}),rad2deg(aLData{2}), '-','Color',[colorCell{visitId} 0.2],'LineWidth',0.5);
                    plot_np{visitId} = plot(rad2deg(mean(aLData{2},2)),rad2deg(mean(aLData{1},2)), '-','Color',[colorCell{visitId} 1.0],'LineWidth',2.5,'DisplayName',dn{visitId});
                end
                grid('on');

                % xlim(100*[-0.5 0.5]);
                % ylim(100*[-0.85 -0.3]);
                if session == 1
                    title(['U' num2str(userCnt)],'FontSize',font_size,'FontName','Times');
                end
                ax = gca;
                ax.FontSize = font_size;
                ax.LineWidth = line_width;
                ax.FontName = 'Times';

                han=axes(figs{2},'visible','off'); 
                han.Title.Visible='on';
                han.XLabel.Visible='on';
                han.YLabel.Visible='on';
                ylabel(han,'Hip angle (deg)','FontSize',font_size,'FontName','Times');
                xlabel(han,'Knee angle (deg)','FontSize',font_size,'FontName','Times');
            end
        end
    end
    if session == 1 && userCnt == length(pareticRight)
        set(0,'CurrentFigure',figs{1});
        legend([plot_p{1} plot_p{2}],'FontSize',font_size,'FontName','Times');

        set(0,'CurrentFigure',figs{2});
        legend([plot_np{1} plot_np{2}],'FontSize',font_size,'FontName','Times');
    end
end
end
set(0,'CurrentFigure',figs{1});
print('-painters','-dsvg','-r300',['Figures/cyclogram_paretic-' date]);

set(0,'CurrentFigure',figs{2});
print('-painters','-dsvg','-r300',['Figures/cyclogram_nonparetic-' date]);

%% set up table for analysis
outs = {'poly_work_area','step_length', 'step_clearance'};
labels = {'Workspace area [cm^2]','Step length [cm]', 'Step height [cm]'};
labels_np = {'Workspace area [cm^2]', 'Step length [cm]', 'Step height [cm]'};
vnames = {'subj','block', 'type', outs{1}, outs{2}, outs{3}};
vnames_mean = {'subj', 'type', outs{1}, outs{2}, outs{3}};

tbl_full_p = [];
tbl_full_np = [];
tbl_mean_p = [];
tbl_mean_np = [];

mods = [1, 100, 100];


userCnt = 0;
dataCell = cell(1,2);
dataCell_np = cell(1,2);

for userId = userIds
    userCnt = userCnt + 1;
    for visitId = 1:2
        tbl_p = table(repmat(categorical(userCnt),3,1),categorical(1:3).', categorical(visitId*ones(3,1)), zeros(3,1), zeros(3,1), zeros(3,1), 'VariableNames',vnames);
        tbl_np = table(repmat(categorical(userCnt),3,1),categorical(1:3).', categorical(visitId*ones(3,1)), zeros(3,1), zeros(3,1), zeros(3,1), 'VariableNames',vnames);

        tbl_m_p = table(categorical(userCnt), categorical(visitId), 0, 0, 0, 'VariableNames',vnames_mean);
        tbl_m_np = table(categorical(userCnt), categorical(visitId), 0, 0, 0, 'VariableNames',vnames_mean);
        for var = 1:length(outs)
            out = outs{var};
            if pareticRight{userCnt}
                dataSessions = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];
    
                dataSessions_np = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                            user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                            user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                            user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];
    
            else
                dataSessions = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                                        user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                                        user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                                        user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];
    
                dataSessions_np = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                    mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                        user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];
            end
    
            tbl_p.(out) = dataSessions.';
            tbl_np.(out) = dataSessions_np.';

            tbl_m_p.(out) = mean(dataSessions);
            tbl_m_np.(out) = mean(dataSessions_np);
            
            dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
            dataCell_np{visitId} = vertcat(dataCell_np{visitId},dataSessions_np);
        end
        tbl_full_p = vertcat(tbl_full_p,tbl_p);
        tbl_full_np = vertcat(tbl_full_np,tbl_np);
        tbl_mean_p = vertcat(tbl_mean_p,tbl_m_p);
        tbl_mean_np = vertcat(tbl_mean_np,tbl_m_np);
    end
end

%% mixed effects model
% Ensure 'type' is categorical
tbl_mean_p.type = categorical(tbl_mean_p.type);

disp('paretic')
disp('_____________________');
for var = 1:length(outs)
    out = outs{var};
    disp(out);
    m1 = tbl_mean_p.(out)(tbl_mean_p.type == categorical(1),:);
    m2 = tbl_mean_p.(out)(tbl_mean_p.type == categorical(2),:);

    disp('exo')
    disp([num2str(mean(m1)) ' +/- ' num2str(std(m1))]);
    disp(' ');
    disp('conv');
    disp([num2str(mean(m2)) ' +/- ' num2str(std(m2))]);
    disp(' ');

    [h,p,ci,stats] = ttest(m1,m2)

end


disp('non-paretic')
disp('_____________________');
for var = 1:length(outs)
    out = outs{var};
    disp(out);
    m1 = tbl_mean_np.(out)(tbl_mean_np.type == categorical(1),:);
    m2 = tbl_mean_np.(out)(tbl_mean_np.type == categorical(2),:);

    disp('exo')
    disp([num2str(mean(m1)) ' +/- ' num2str(std(m1))]);
    disp(' ');
    disp('conv');
    disp([num2str(mean(m2)) ' +/- ' num2str(std(m2))]);
    disp(' ');

    [h,p,ci,stats] = ttest(m1,m2)

end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% STRIDES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot stride length

xPos = [1 1.75 2.75 3.5];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
sgtitle("Stride Length");

userCnt = 0;
for userId = [userIds]
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        % if 0 exactly, eliminate
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.left.stride_length(...
                            user_p(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0);
    end

    for visitId = 1:2
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.right.stride_length(...
                            user_p(userId).visit(visitId).spatiotemporal.right.stride_length ~= 0);
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    if ~pareticRight{userCnt}
        label = {'Left*', 'Right', '', ''};
    else
        label = {'Left', 'Right*', '', ''};
    end
    h = boxplot(100*allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("Stride length [cm]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%% Plot stride length and clearance - paretic

xPos = [1 1.75 2.75 3.5];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
label = {'Length', 'Clearance', '', ''};
sgtitle("Paretic Stride Length & Foot Clearance");
userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        % if 0 exactly, eliminate
        if pareticRight{userCnt}
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.right.stride_length(...
                    user_p(userId).visit(visitId).spatiotemporal.right.stride_length ~= 0)]);
        else
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.left.stride_length(...
                    user_p(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0)]);
        end
    end

    for visitId = 1:2
        if pareticRight{userCnt}
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.right.stride_clearance(...
                    user_p(userId).visit(visitId).spatiotemporal.right.stride_clearance ~= 0)]);
        else
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.stride_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.left.stride_clearance(...
                    user_p(userId).visit(visitId).spatiotemporal.left.stride_clearance ~= 0)]);
        end
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    h = boxplot(100*allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("[cm]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%% plot stride length and clearance asymmetry

xPos = [1 1.75 2.75 3.5 4.5 5.25 6.25 7];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4)) mean(xPos(5:6)) mean(xPos(7:8))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
label = {'Length', 'Clearance', '', ''};
sgtitle("Stride Asymmetry");
userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        % dataCell{end + 1} = rmoutliers(user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_length);
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_length;
    end

    for visitId = 1:2
        % dataCell{end + 1} = rmoutliers(user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance);
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.asymmetry.stride_clearance;
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    % h = boxplot(allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    h = boxplot(allData, groups, 'Labels', label, 'Positions', xPos(groups));
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("Asymmetry [%]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% STEPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot step length

xPos = [1 1.75 2.75 3.5];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
sgtitle("Step Length");

userCnt = 0;
for userId = [userIds]
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        % if 0 exactly, eliminate
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.left.step_length(...
                            user_p(userId).visit(visitId).spatiotemporal.left.step_length ~= 0);
    end

    for visitId = 1:2
        dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.right.step_length(...
                            user_p(userId).visit(visitId).spatiotemporal.right.step_length ~= 0);
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    if ~pareticRight{userCnt}
        label = {'Left*', 'Right', '', ''};
    else
        label = {'Left', 'Right*', '', ''};
    end
    h = boxplot(100*allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("Stride length [cm]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%% Plot step length and clearance - paretic

xPos = [1 1.75 2.75 3.5];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
label = {'Length', 'Clearance', '', ''};
sgtitle("Paretic Step Length & Foot Clearance");
userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        % if 0 exactly, eliminate
        if pareticRight{userCnt}
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.right.step_length(...
                    user_p(userId).visit(visitId).spatiotemporal.right.step_length ~= 0)]);
        else
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.left.step_length(...
                    user_p(userId).visit(visitId).spatiotemporal.left.step_length ~= 0)]);
        end
    end

    for visitId = 1:2
        if pareticRight{userCnt}
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.right.step_clearance(...
                    user_p(userId).visit(visitId).spatiotemporal.right.step_clearance ~= 0)]);
        else
            dataCell{end + 1} = rmoutliers([...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length(...
                    % usernew(userId).visit(visitId).spatiotemporal.left.step_length ~= 0)]
                    user_p(userId).visit(visitId).spatiotemporal.left.step_clearance(...
                    user_p(userId).visit(visitId).spatiotemporal.left.step_clearance ~= 0)]);
        end
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    h = boxplot(100*allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("[cm]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%% plot step length and clearance asymmetry

xPos = [1 1.75 2.75 3.5 4.5 5.25 6.25 7];
xTickPos = [mean(xPos(1:2)) mean(xPos(3:4)) mean(xPos(5:6)) mean(xPos(7:8))];
figure;
ax = [];
tiledlayout(1, length(userIds));
% tiledlayout(2, ceil(length(userIds)/2));
label = {'Length', 'Clearance', '', ''};
sgtitle("Step Asymmetry");
userCnt = 0;
for userId = userIds
    userCnt = userCnt + 1;
    disp(['Subject' num2str(userId)]);

    if(isempty(ax)) % if this is the first plot initialize ax
        ax(1) = nexttile;
    else % else extend ax
        ax(end + 1) = nexttile;
    end

    dataCell = {};
    for visitId = 1:2
        dataCell{end + 1} = rmoutliers(user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_length);
        % dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_length;
    end

    for visitId = 1:2
        dataCell{end + 1} = rmoutliers(user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_clearance);
        % dataCell{end + 1} = user_p(userId).visit(visitId).spatiotemporal.asymmetry.step_clearance;
    end

    [allData, groups] = prepareDataForBoxplot(dataCell);
    h = boxplot(allData, groups, 'Labels', label, 'Positions', xPos(groups), 'symbol', '');
    % h = boxplot(allData, groups, 'Labels', label, 'Positions', xPos(groups));
    xticks(xTickPos)
    set(h, 'LineWidth', 3); % Make lines thicker

    % Find all box patch objects and set their properties
    boxes = findobj(gca, 'Tag', 'Box');
    for i = length(boxes):-1:1
        set(boxes(i), 'Color', 'black');      % Set the color of the box outline
        patch(get(boxes(i), 'XData'), get(boxes(i), 'YData'), colorCell{mod(i, 2) + 1}, 'FaceAlpha', .5); % Fill the box with color
    end

    ylabel("Asymmetry [%]")
    title("User " + num2str(userId))
    if userCnt == length(userIds)
        legend(["dyad", "conventional"], "Location","best", 'LineWidth', 0.1, 'EdgeColor', 'white')
    end
    grid on;

    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end

%% boxplot group
% data with group differences in a cell array
outs = {'step_clearance', 'step_length'};
labels = {'Paretic step clearance [cm]', 'Paretic step length [cm]'};

for var = 1:2
out = outs{var};
label = labels{var};

userCnt = 0;
dataCell = cell(1,2);
for userId = userIds
    userCnt = userCnt + 1;
    for visitId = 1:2
        if pareticRight{userCnt}
            dataSessions = 100*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];

        else
            dataSessions = 100*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];
        end
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
    end
end

group_names = {'dyad', 'conventional'};
condition_names = {'T1', 'T2', 'T3'};

% using linkline to emphasize interaction effects (group*condition)
figure;
h = daboxplot(dataCell,'linkline',1,...
    'xtlabels', condition_names,'legend',group_names,'scattersize',50,...
    'whiskers',0,'outliers',1,'outsymbol','r*','scatter',2,'boxalpha',0.6,'color',[colorCell{1}; colorCell{2}]);
ylabel(label);
ax = gca;
ax.FontSize = font_size;
ax.LineWidth = line_width;
ax.FontName = 'Times';
end

%% scatter group - length, height and work area
% data with group differences in a cell array

set(0,'DefaultFigureWindowStyle','default');

figs = {figure('Position', [83.7000  761.0000 880  960.0000])};

set(0,'CurrentFigure',figs{1});
% sgtitle(['Paretic and non-paretic spatial measures'],'FontSize',1.25*font_size,'FontName','Times');
hold on;

outs = {'poly_work_area','step_length', 'step_clearance'};
labels = {'Workspace area [cm^2]','Step length [cm]', 'Step height [cm]'};
labels_np = {'Workspace area [cm^2]', 'Step length [cm]', 'Step height [cm]'};
lims = {[-25 610],[10 45],[10 85]};
mods = [1, 100, 100];
for var = 1:length(outs)
out = outs{var};
label = labels{var};
label_np = labels_np{var};

userCnt = 0;
dataCell = cell(1,2);
dataCell_np = cell(1,2);

for userId = userIds
    userCnt = userCnt + 1;
    for visitId = 1:2
        if pareticRight{userCnt}
            dataSessions = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];

            dataSessions_np = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                        user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                    mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                        user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                    mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                        user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];

        else
            dataSessions = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];

            dataSessions_np = mods(var)*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];
        end
        dataSessions(end+1)= mean(dataSessions);
        dataSessions_np(end+1)= mean(dataSessions_np);
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
        dataCell_np{visitId} = vertcat(dataCell_np{visitId},dataSessions_np);
    end
end

group_names = {'dyad', 'conv'};
condition_names = {'T1', 'T2', 'T3', 'Tbar'};

% using linkline to emphasize interaction effects (group*condition)
subplot(length(outs),2,2*var-1);
jit = randn(length(dataCell{1}(:,1)),1)/100;
v1 = cell(4,1);
v2 = cell(4,1);
disp(out);
disp('paretic');
for s = 1:4
    plot(repmat([s-0.25 s+0.25],length(dataCell{1}(:,s)),1).'+jit.', [dataCell{1}(:,s) dataCell{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;

    disp(['session : ' num2str(s)]);
    disp('exo')
    disp([num2str(mean(dataCell{1}(:,s))) ' +/- ' num2str(std(dataCell{1}(:,s)))]);
    disp(' ');
    disp('conv');
    disp([num2str(mean(dataCell{2}(:,s))) ' +/- ' num2str(std(dataCell{2}(:,s)))]);
    disp(' ')


    v1{s} = scatter(s-0.25+jit,dataCell{1}(:,s),75,'MarkerFaceColor',colorCell{1},'MarkerFaceAlpha',0.5,'MarkerEdgeColor','none','MarkerEdgeAlpha',0.5,'LineWidth',2.0, 'DisplayName', group_names{1}); 
    v2{s} = scatter(s+0.25+jit,dataCell{2}(:,s),75,'MarkerFaceColor', colorCell{2},'MarkerFaceAlpha',0.5,'MarkerEdgeColor','none','MarkerEdgeAlpha',0.5,'LineWidth',2.0, 'DisplayName', group_names{2});  hold on;
    plot([s-0.25-0.15 s-0.25+0.15], [mean(dataCell{1}(:,s)), mean(dataCell{1}(:,s))], '-', 'Color', [colorCell{1}],'LineWidth',5.0);
    plot([s+0.25-0.15 s+0.25+0.15], [mean(dataCell{2}(:,s)), mean(dataCell{2}(:,s))], '-', 'Color', [colorCell{2}],'LineWidth',5.0);
end
disp(' ')
ylim(lims{var});
xlim([0.5 4.5]);
xticks([1 2 3 4]);
xticklabels(condition_names);
box('off');
if var == length(outs)
    lgd = legend([v1{1},v2{1}]);
    lgd.Position = [0.1   0.0148    0.1004    0.0505];
    % lgd.Box = 'off';
    xlabel('Training blocks');
end
ylabel(label);
% xlabel('Training blocks');
ax = gca;
ax.FontSize = font_size;
ax.LineWidth = line_width;
ax.FontName = 'Times';

% using linkline to emphasize interaction effects (group*condition)
subplot(length(outs),2,2*var);
jit = randn(length(dataCell_np{1}(:,1)),1)/100;
v1_np = cell(4,1);
v2_np = cell(4,1);
disp(out);
disp('non-paretic');
for s = 1:4
    plot(repmat([s-0.25 s+0.25],length(dataCell_np{1}(:,s)),1).'+jit.', [dataCell_np{1}(:,s) dataCell_np{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;



    disp(['session : ' num2str(s)]);
    disp('exo')
    disp([num2str(mean(dataCell_np{1}(:,s))) ' +/- ' num2str(std(dataCell_np{1}(:,s)))]);
    disp(' ');
    disp('conv');
    disp([num2str(mean(dataCell_np{2}(:,s))) ' +/- ' num2str(std(dataCell_np{2}(:,s)))]);
    disp(' ')

    v1_np{s} = scatter(s-0.25+jit,dataCell_np{1}(:,s),50,'MarkerFaceColor','none','MarkerFaceAlpha',0.5,'MarkerEdgeColor',colorCell{1},'MarkerEdgeAlpha',0.5,'LineWidth',2.0, 'DisplayName', 'dyad'); 
    v2_np{s} = scatter(s+0.25+jit,dataCell_np{2}(:,s),50,'MarkerFaceColor','none','MarkerFaceAlpha',0.5,'MarkerEdgeColor',colorCell{2},'MarkerEdgeAlpha',0.5,'LineWidth',2.0, 'DisplayName', 'conv');  hold on;

    plot([s-0.25-0.15 s-0.25+0.15], [mean(dataCell_np{1}(:,s)), mean(dataCell_np{1}(:,s))], '-', 'Color', [colorCell{1}],'LineWidth',5.0);
    plot([s+0.25-0.15 s+0.25+0.15], [mean(dataCell_np{2}(:,s)), mean(dataCell_np{2}(:,s))], '-', 'Color', [colorCell{2}],'LineWidth',5.0);
end
disp(' ');
ylim(lims{var});
xlim([0.5 4.5]);
xticks([1 2 3 4]);
xticklabels(condition_names);
box('off');
if var == length(outs)
    lgd = legend([v1_np{1},v2_np{1}]);
    lgd.Position = [0.4723    0.0148    0.1004    0.0505];
    % lgd.Box = 'off';
    xlabel('Training blocks');
end
% ylabel(label_np);
ax = gca;
ax.FontSize = font_size;
ax.LineWidth = line_width;
ax.FontName = 'Times';
end

set(0,'CurrentFigure',figs{1});
print('-painters','-dsvg','-r300',['Figures/spatial/group_spatial_both_limbs2-' date]);
%% scatter group - length asymmetry
% data with group differences in a cell array
outs = {'step_length'};
labels = {'Step length asymmetry [%]'};
lims = {[-30 30]};
figure;
for var = 1
out = outs{var};
label = labels{var};

userCnt = 0;
dataCell = cell(1,2);
for userId = userIds
    userCnt = userCnt + 1;
    for visitId = 1:2
        dataSessions = [mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){1}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){1} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){2}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){2} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){3}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){3} ~= 0))];
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
    end
end

group_names = {'dyad', 'conv'};
condition_names = {'T1', 'T2', 'T3'};

% using linkline to emphasize interaction effects (group*condition)
subplot(1,1,var);
plot([0.5 3.5],[0 0], '--', 'Color', [0 0 0 0.5],'LineWidth',1.0); hold on;
jit = randn(length(dataCell{1}(:,1)),1)/10000;
v1 = cell(3,1);
v2 = cell(3,1);
for s = 1:3
    plot(repmat([s-0.25 s+0.25],length(dataCell{1}(:,s)),1).'+jit.', [dataCell{1}(:,s) dataCell{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;
    plot([s-0.25-0.1 s-0.25+0.1], [mean(dataCell{1}(:,s)), mean(dataCell{1}(:,s))], '-', 'Color', [colorCell{1} 0.75],'LineWidth',5.0);
    plot([s+0.25-0.1 s+0.25+0.1], [mean(dataCell{2}(:,s)), mean(dataCell{2}(:,s))], '-', 'Color', [colorCell{2} 0.75],'LineWidth',5.0);

    v1{s} = scatter(s-0.25+jit,dataCell{1}(:,s),100,'MarkerFaceColor',colorCell{1},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'dyad'); 
    v2{s} = scatter(s+0.25+jit,dataCell{2}(:,s),100,'MarkerFaceColor',colorCell{2},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'conv');  hold on;
end
ylim(lims{var});
xlim([0.5 3.5]);
xticks([1 2 3]);
xticklabels(condition_names);
box('off');
if var == 1
    lgd = legend([v1{1},v2{1}]);
    lgd.Box = 'off';
end
ylabel(label);
xlabel('Training blocks');
ax = gca;
ax.FontSize = font_size;
ax.LineWidth = line_width;
ax.FontName = 'Times';
end




%% scatter last 3 - length and clearance
% data with group differences in a cell array
outs = {'step_length', 'step_clearance'};
labels = {'Paretic step length [cm]', 'Paretic step clearance [cm]'};
group_names = {'dyad', 'conv'};
condition_names = {'B','T1', 'T2', 'T3'};
lims = {[12.5 37.5],[17.5 72.5]};
textplace = {[0.6 35],[0.6 66]};
figure;
for var = 1:2
out = outs{var};
label = labels{var};

userCnt = 3;
userPlt = 0;
for userId = [6 9 11]
    userCnt = userCnt + 1;
    userPlt = userPlt + 1;
    dataCell = cell(1,2);
    for visitId = 1:2
        if pareticRight{userCnt}
            dataSessions = 100*[mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){4}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){4} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];

        else
            dataSessions = 100*[mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){4}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){4} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];
        end
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
    end

    % using linkline to emphasize interaction effects (group*condition)
    subplot(3,2,var+2*(userPlt-1));
    jit = randn(length(dataCell{1}(:,1)),1)/10000;
    v1 = cell(4,1);
    v2 = cell(4,1);
    for s = 1:4
        plot(repmat([s-0.25 s+0.25],length(dataCell{1}(:,s)),1).'+jit.', [dataCell{1}(:,s) dataCell{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;
        plot([s-0.25-0.1 s-0.25+0.1], [mean(dataCell{1}(:,s)), mean(dataCell{1}(:,s))], '-', 'Color', [colorCell{1} 0.75],'LineWidth',5.0);
        plot([s+0.25-0.1 s+0.25+0.1], [mean(dataCell{2}(:,s)), mean(dataCell{2}(:,s))], '-', 'Color', [colorCell{2} 0.75],'LineWidth',5.0);
    
        v1{s} = scatter(s-0.25+jit,dataCell{1}(:,s),100,'MarkerFaceColor',colorCell{1},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'dyad'); 
        v2{s} = scatter(s+0.25+jit,dataCell{2}(:,s),100,'MarkerFaceColor',colorCell{2},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'conv');  hold on;
    end
    ylim(lims{var});
    xlim([0.5 4.5]);
    xticks([1 2 3 4]);
    xticklabels(condition_names);
    box('off');
    if var == 2 && userPlt == 2
        lgd = legend([v1{1},v2{1}]);
        lgd.Box = 'off';
    end

    if userPlt == 2
        ylabel(label);
    end
    xlabel('Training blocks');
    text(textplace{var}(1),textplace{var}(2),['U', num2str(userCnt)],'FontSize',14);
    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end
end

%% scatter last 3 - area
% data with group differences in a cell array
outs = {'poly_work_area'};
labels = {'Paretic work area'};
group_names = {'dyad', 'conv'};
condition_names = {'B','T1', 'T2', 'T3'};
lims = {[-0.005 0.06]};
textplace = {[0.6 0.05]};
figure;
for var = 1
out = outs{var};
label = labels{var};

userCnt = 3;
userPlt = 0;
for userId = [6 9 11]
    userCnt = userCnt + 1;
    userPlt = userPlt + 1;
    dataCell = cell(1,2);
    for visitId = 1:2
        if pareticRight{userCnt}
            dataSessions = [mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){4}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){4} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.right.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.right.(out){3} ~= 0))];

        else
            dataSessions = [mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){4}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){4} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){1}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){1} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){2}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){2} ~= 0)),...
                                mean(user_p(userId).visit(visitId).spatiotemporal.left.(out){3}(...
                                    user_p(userId).visit(visitId).spatiotemporal.left.(out){3} ~= 0))];
        end
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
    end

    % using linkline to emphasize interaction effects (group*condition)
    subplot(3,1,userPlt);
    jit = randn(length(dataCell{1}(:,1)),1)/10000;
    v1 = cell(4,1);
    v2 = cell(4,1);
    for s = 1:4
        plot(repmat([s-0.25 s+0.25],length(dataCell{1}(:,s)),1).'+jit.', [dataCell{1}(:,s) dataCell{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;
        plot([s-0.25-0.1 s-0.25+0.1], [mean(dataCell{1}(:,s)), mean(dataCell{1}(:,s))], '-', 'Color', [colorCell{1} 0.75],'LineWidth',5.0);
        plot([s+0.25-0.1 s+0.25+0.1], [mean(dataCell{2}(:,s)), mean(dataCell{2}(:,s))], '-', 'Color', [colorCell{2} 0.75],'LineWidth',5.0);
    
        v1{s} = scatter(s-0.25+jit,dataCell{1}(:,s),100,'MarkerFaceColor',colorCell{1},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'dyad'); 
        v2{s} = scatter(s+0.25+jit,dataCell{2}(:,s),100,'MarkerFaceColor',colorCell{2},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'conv');  hold on;
    end
    ylim(lims{var});
    xlim([0.5 4.5]);
    xticks([1 2 3 4]);
    xticklabels(condition_names);
    box('off');
    if var == 1 && userPlt == 2
        lgd = legend([v1{1},v2{1}]);
        lgd.Box = 'off';
    end

    if userPlt == 2
        ylabel(label);
    end
    xlabel('Training blocks');
    text(textplace{var}(1),textplace{var}(2),['U', num2str(userCnt)],'FontSize',14);
    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end
end

%% scatter last 3 - asymmetry
% data with group differences in a cell array
outs = {'step_length'};
labels = {'Step length asymmetry [%]'};
group_names = {'dyad', 'conv'};
condition_names = {'B','T1', 'T2', 'T3'};
lims = {[-30 30]};
textplace = {[0.6 25]};
figure;
for var = 1
out = outs{var};
label = labels{var};

userCnt = 3;
userPlt = 0;
for userId = [6 9 11]
    userCnt = userCnt + 1;
    userPlt = userPlt + 1;
    dataCell = cell(1,2);
    for visitId = 1:2
        dataSessions = [mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){4}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){4} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){1}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){1} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){2}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){2} ~= 0)),...
                        mean(user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){3}(...
                            user_p(userId).visit(visitId).spatiotemporal.asymmetry.(out){3} ~= 0))];
        dataCell{visitId} = vertcat(dataCell{visitId},dataSessions);
    end

    % using linkline to emphasize interaction effects (group*condition)
    subplot(3,1,userPlt);
    jit = randn(length(dataCell{1}(:,1)),1)/10000;
    v1 = cell(4,1);
    v2 = cell(4,1);
    for s = 1:4
        plot(repmat([s-0.25 s+0.25],length(dataCell{1}(:,s)),1).'+jit.', [dataCell{1}(:,s) dataCell{2}(:,s)].', '-', 'Color', [0 0 0 0.2],'LineWidth',1.0); hold on;
        plot([s-0.25-0.1 s-0.25+0.1], [mean(dataCell{1}(:,s)), mean(dataCell{1}(:,s))], '-', 'Color', [colorCell{1} 0.75],'LineWidth',5.0);
        plot([s+0.25-0.1 s+0.25+0.1], [mean(dataCell{2}(:,s)), mean(dataCell{2}(:,s))], '-', 'Color', [colorCell{2} 0.75],'LineWidth',5.0);
    
        v1{s} = scatter(s-0.25+jit,dataCell{1}(:,s),100,'MarkerFaceColor',colorCell{1},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'dyad'); 
        v2{s} = scatter(s+0.25+jit,dataCell{2}(:,s),100,'MarkerFaceColor',colorCell{2},'MarkerEdgeColor','k','LineWidth',1.0, 'DisplayName', 'conv');  hold on;
    end
    ylim(lims{var});
    xlim([0.5 4.5]);
    xticks([1 2 3 4]);
    xticklabels(condition_names);
    box('off');
    if var == 1 && userPlt == 2
        lgd = legend([v1{1},v2{1}]);
        lgd.Box = 'off';
    end

    if userPlt == 2
        ylabel(label);
    end
    xlabel('Training blocks');
    text(textplace{var}(1),textplace{var}(2),['U', num2str(userCnt)],'FontSize',14);
    ax = gca;
    ax.FontSize = font_size;
    ax.LineWidth = line_width;
    ax.FontName = 'Times';
end
end
