%% Shifts an array right (+ve places) or left (-ve places).
%% Pads array with Pad_Value for number of places on the right of the matrix before shifting if a value is set.
function Shifted_Array = Shift_Array(Input_Array, Places, Pad_Value)
    %% Input Handling
    if(nargin >= 2)
    else
        error("Shift Array : Insufficient Inputs");
    end
    if(nargin == 3)
        Pad_Array = true;
    end
    %Ensure array direction is always common
    Input_Array_Size = size(Input_Array);
    Flip_Array_Direction = false;
    if(Input_Array_Size(1) == 1)
        if(Input_Array_Size(2) == 1)
            %Single Value
        else
            Input_Array = Input_Array';
            Flip_Array_Direction = true;
        end
    else
        if(Input_Array_Size(2) == 1)
            %Default Direction
        else
            %2D Array; unsupported
            error("Shift 2D Array : Does not support multidimensional arrays");
        end
    end
    %If padding the array on the right
    if(Pad_Array)
        Input_Array(end + 1:end + abs(Places)) = Pad_Value;
    end
    %Shifts the array circularly
    Shifted_Array = circshift(Input_Array, Places);
    %Return shifted array in the same direction as was input
    if(Flip_Array_Direction)
        Shifted_Array = Shifted_Array';
    end
end