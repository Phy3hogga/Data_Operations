%% Creates or selects a figure without making it the active window in Windows
%:Inputs:
% - Figure_ID (Handle) ; Handle reference to the figure window
% - Hide_Figure (boolean) ; If the figure should be hidden or not
function Figure_ID = Get_Figure(Figure_ID, Hide_Figure)
    %Only figure ID parsed
    if(nargin == 1)
        %% Check if figure exists
        if(isempty(Figure_ID))
            %% Figure doesn't exist
            %create figure
            Figure_ID = figure();
        elseif(~ishandle(Figure_ID))
            %% Figure doesn't exist
            %create figure
            Figure_ID = figure();
        else
            %% Figure exists
            %Select figure
            set(0, 'CurrentFigure', Figure_ID);
        end
    %Figure ID and hide argument stated
    elseif(nargin == 2)
        %% Check if figure exists
        if(isempty(Figure_ID))
            %% Figure doesn't exist
            %create figure
            Figure_ID = figure();
            %if hiding graphs from user
            if(Hide_Figure)
                set(Figure_ID,'visible','off');
            else
                set(Figure_ID,'visible','on');
            end
        elseif(~ishandle(Figure_ID))
            %% Figure doesn't exist
            %create figure
            Figure_ID = figure();
            %if hiding graphs from user
            if(Hide_Figure)
                set(Figure_ID,'visible','off');
            else
                set(Figure_ID,'visible','on');
            end
        else
            %% Figure exists
            %Select figure
            set(0, 'CurrentFigure', Figure_ID);
            %if hiding graphs from user
            if(Hide_Figure)
                set(Figure_ID,'visible','off');
            else
                set(Figure_ID,'visible','on');
            end
        end
    else
        %% No inputs specified; Figure existance can't be verified - create a new figure
        Figure_ID = figure();
    end
end