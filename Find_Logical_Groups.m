%% Finds the starting and end indicies of groups of logical data within a 1D logical array
function [Group_Start, Group_End] = Find_Logical_Groups(Input_Array)
    %% Input Handling
    if(nargin ~= 1)
        error("Find Logical Groups : Expected single logical array as input");
    end
    if(~islogical(Input_Array))
        error("Find Logical Groups : Expected logical array as input");
    end
    %% Validate array is the correct orientation
    Array_Size = size(Input_Array);
    if(numel(Array_Size) > 2)
        error("Expected one dimensional array.");
    end
    
    %% If the array requires flipping or not
    Flip_Array = false;
    if(Array_Size(1) == 1)
        if(Array_Size(2) == 1)
            error("Expected one dimensional array wtih more than one element.");
        else
            Flip_Array = true;
        end
    else
        if(Array_Size(2) == 1)
            %No flip required
        else
            error("Expected one dimensional array.");
        end
    end
    %% Flip array to be linear list
    if(Flip_Array)
        Input_Array = Input_Array';
    end
    %% Array Padding
    %Shift array one place to the right, pad with 0 at the beginning (always catch start condition)
    Input_Array = Shift_Array(Input_Array, 1, 0);
    %pad with 0 at the end (always catch end condition)
    Input_Array(end + 1) = 0;
    %% Find the start and end indicies of groups
    Group_Start = strfind(Input_Array', [0, 1]);
    Group_End = strfind(Input_Array', [1, 0]) - 1;
    %% Sense-Check Output
    if(length(Group_Start) ~= length(Group_End))
        warning("Find Logical Grouping : Unexpected error, differing lengths for Start and End.");
    end
end