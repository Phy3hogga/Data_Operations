%% Histogram function that allows weighted arguments to provide a cumulative weighting result from a histogram distribution
function Histogram = Histogram_Weighted(Values, Weights, BinEdges)
    %Linearise inputs
    Values = Values(:);
    Weights = Weights(:);
    %Calculate histogram index for each value,
    Bin_Locations = discretize(Values, BinEdges);
    Unique_Bin_Locations = unique(Bin_Locations);
    %Empty histogram
    Histogram = zeros(length(BinEdges) - 1, 1);
    %Only calculate histogram values for bins that have elements
    for Current_Bin_Index = 1:numel(Unique_Bin_Locations)
        %Get current bin
        Current_Bin = Unique_Bin_Locations(Current_Bin_Index);
        if(~isnan(Current_Bin))
            %Find corresponding bin indicies
            Value_Logical_Index = Bin_Locations == Current_Bin;
            if(~isempty(Value_Logical_Index))
                if(isempty(Weights))
                    %Default to providing a standard histogram, providing cululative elements
                    Histogram(Current_Bin) = count(Value_Logical_Index);
                else
                    %provide a histogram consisting of cumulative weightings
                    Histogram(Current_Bin) = sum(Weights(Value_Logical_Index),[],'omitnan');
                end
            end
        end
    end
end
