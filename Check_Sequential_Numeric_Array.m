%% Verifies if a matrix is sequential
function Sequential = Check_Sequential_Numeric_Array(Array)
    %% Input validation
    %Number of arguments
    if(nargin ~= 1)
        error("Verify_Sequential: Expected singular input.");
    end
    %If numeric
    if(~isnumeric(Array))
        error("Verify_Sequential: Expected numeric input.");
    end
    %If integer
    if(~all(Array - round(Array) < eps))
        warning("Verify_Sequential: Expected integer input.");
    end
    %% Verify array contents are sequential
    Sequential = true;
    %Sort array
    Array = sort(Array);
    %If more than one element exists in the array
    if(numel(Array) ~= 1)
        %Verify all elements are sequential
        if(sum(diff(Array)==1) ~= numel(Array) - 1)
            Sequential = false;
        end
    end
end