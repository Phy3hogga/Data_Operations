%% Creates a lookup table and index matrix for a set of numeric input data 
function [Index_Sorted, LUT_Sorted] = Array_To_Index(Image, LUT_Entries, Linear_Interp)
    %Input validation
    Linear_Override = 0;
    Fractional_Number_Of_Bins = 0;
    LUT_Number_Of_Bins = 0;
    Continue = 1;
    if(0 < nargin && nargin <= 3)
        if(nargin >= 1)
            if(~isnumeric(Image))
                error("Data supplied non-numeric");
                Continue = 0;
            else
                if(numel(Image) == 0)
                    error("Data supplied empty");
                    Continue = 0;
                elseif(numel(Image) > 0)
                    %Valid
                else
                    error("Data supplied unknown error");
                    Continue = 0;
                end
            end
        end
        if(nargin >= 2)
            if(isnumeric(LUT_Entries))
                if(isinteger(LUT_Entries))
                    %Valid
                else
                    if(0 < LUT_Entries && LUT_Entries <=1)
                        Fractional_Number_Of_Bins = 1;
                    else
                        disp("LUT entries rounded to nearest integer");
                        LUT_Entries = uint64(round(LUT_Entries));
                    end
                end
                if(LUT_Entries > 0)
                    LUT_Number_Of_Bins = LUT_Entries;
                else
                    disp("LUT Entries negative");
                    Continue = 0;
                end
            else
                disp("LUT Entries non-numeric");
                Continue = 0;
            end
        end
        if(nargin >= 3)
            if(isnumeric(Linear_Interp))
                if(Linear_Interp == 1)
                    Linear_Override = 1;
                else
                    Linear_Override = 0;
                end
            else
                Linear_Override = 0;
            end
        end

    else
        error("Invalid Input");
        Continue = 0;
    end
    %Input valid
    if(Continue)
        %Create LUT and Index matrix
        if(numel(Image) > 0)
            %Valid input, variables for LUT, LUT element counting and Index matrix
            Index = zeros(size(Image),'uint64');
            LUT_Value = [];
            LUT_element = 0;
            for Linear_Index = 1:numel(Image)
                %Compare LUT to array element
                LUT_FP_Equal = Floating_Point_Equal(LUT_Value, Image(Linear_Index));
                if(sum(LUT_FP_Equal) == 0)
                    %New Value
                    LUT_element = LUT_element + 1;
                    LUT_Value(LUT_element) = Image(Linear_Index);
                    Index(Linear_Index) = LUT_element;
                elseif(sum(LUT_FP_Equal) >= 1)
                    %Matching Existing LUT Indicies
                    LUT_FP_Equal_Index = find(LUT_FP_Equal == 1);
                    %Single match, use single value
                    if(length(LUT_FP_Equal_Index) == 1)
                        Index(Linear_Index) = LUT_FP_Equal_Index;
                    %Multiple values, use closest value
                    elseif(length(LUT_FP_Equal_Index) > 1)
                         [~,Multiple_Match_Index] = min(abs(LUT_Value(LUT_FP_Equal_Index) - Image(Linear_Index)));
                         Index(Linear_Index) = LUT_FP_Equal_Index(Multiple_Match_Index);
                    else
                        error("Error: Unhandled Multiple Match");
                    end
                else
                    error("Error: Unhandled Multiple Match");
                end
            end
            
            %Determine appropriate datatype by number of entries within LUT, convert to use less RAM
            if(numel(LUT_Value) <= 255)
                Index = uint8(Index);
                Index_Empty = zeros(size(Image),'uint8');
            elseif(numel(LUT_Value) <= 65535)
                Index = uint16(Index);
                Index_Empty = zeros(size(Image),'uint16');
            elseif(numel(LUT_Value) <= 4294967295)
                Index = uint32(Index);
                Index_Empty = zeros(size(Image),'uint32');
            else
                %do nothing, use 64bit int
                Index_Empty = zeros(size(Image),'uint64');
            end
            Index_Sorted = Index_Empty;

            %Sort and swap indicies so they are in numerical order
            [LUT_Sorted, LUT_Index_Sorted] = sort(LUT_Value,'ascend');
            %Re-order index data
            for Current_Index = 1:length(LUT_Sorted)
                %Find related pixels
                Index_Match = find(Index == LUT_Index_Sorted(Current_Index));
                %Copy ordered index
                Index_Sorted(Index_Match) = repmat(Current_Index, length(Index_Match), 1);
            end
            %Reassign variables to the original index
            LUT_Value = LUT_Sorted;
            Index = Index_Sorted;
            %Clear sorted array for re-use
            Index_Sorted = Index_Empty;
            LUT_Sorted = [];
            
            %Calculate fractional number of bins
            if(Fractional_Number_Of_Bins)
                LUT_Number_Of_Bins = round(numel(LUT_Value)*LUT_Entries);
            end
            LUT_Index = 1:1:numel(LUT_Value);
            %if rebinning the LUT to a specific number of channels
            if(LUT_Number_Of_Bins > 1)
                if(LUT_Number_Of_Bins > numel(LUT_Value))
                    disp("Rebinning not performed; asking for more bins than originally found");
                    LUT_Sorted = LUT_Value;
                    Index_Sorted = Index;
                else
                    %Bin index relative to original LUT (non-integer intervals)
                    Rebinned_LUT_Index_Correspond = linspace(1, numel(LUT_Value), LUT_Number_Of_Bins);
                    %New bin index (integer intervals)
                    Rebinned_LUT_Index_New = 1:1:LUT_Number_Of_Bins;
                    %Switch between linear (from min->max) or pchip interpolation
                    if(Linear_Override)
                        LUT_Sorted = linspace(min(LUT_Value), max(LUT_Value), LUT_Number_Of_Bins);
                    else
                        LUT_Sorted = interp1(LUT_Index, LUT_Value, Rebinned_LUT_Index_Correspond, 'pchip');
                    end
                    %Translate between the two LUTs
                    for Translate_Index = 1:numel(LUT_Index)
                        [~,Rebinned_LUT_Index(Translate_Index)] = min(abs(LUT_Index(Translate_Index) - Rebinned_LUT_Index_Correspond));
                    end
                    %Swap between different indexing LUT tables
                    for Current_Index = 1:length(LUT_Index)
                        %Find related pixels
                        Index_Match = find(Index == Current_Index);
                        %Copy ordered index
                        Index_Sorted(Index_Match) = repmat(Rebinned_LUT_Index(Current_Index), length(Index_Match), 1);
                    end
                    %Determine appropriate datatype by number of entries within LUT, convert to use less RAM
                    if(numel(LUT_Sorted) <= 255)
                        Index_Sorted = uint8(Index_Sorted);
                    elseif(numel(LUT_Sorted) <= 65535)
                        Index_Sorted = uint16(Index_Sorted);
                    elseif(numel(LUT_Sorted) <= 4294967295)
                        Index_Sorted = uint32(Index_Sorted);
                    else
                        %do nothing, use 64bit int
                    end
                end
            end
            
        else
            %Output validation
            LUT_Sorted = [];
            Index_Sorted = [];
        end
    else
        %Output validation
        LUT_Sorted = [];
        Index_Sorted = [];
    end
end