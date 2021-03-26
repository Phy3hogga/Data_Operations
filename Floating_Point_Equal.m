function yn = Floating_Point_Equal(A, B)
% ISEQUALFP  Check two values for equality within floating point precision
% It is widely known that floating point computation has a fundamental
%   limitation: not every value can be represented exactly.  This can
%   lead to surprising results for those unfamiliar with this
%   limitation, especially since 'double' is MATLAB's default numerical
%   data type.
% This function accepts two float values (single or double) or arrays
%   of floats, and returns a logical value indicating whether they
%   are equal within floating point precision.  Mixed single and double
%   inputs will be evaluated based on single floating point precision.
% Floating point accuracy reference:
%   http://blogs.mathworks.com/loren/2006/08/23/a-glimpse-into-floating-point-accuracy/
% Usage:
%   yn = isequalfp(a,b)
%     a,b: floats or arrays of floats to compare
%      yn: logical scalar result indicating equality
% Example:
%   a = 0.3;
%   b = 0.1*3;
%   isequal(a,b)     % ans = 0
%   isequalfp(a,b)   % ans = 1
%   c = a+2*eps(a)   % c = 0.3000...
%   isequalfp(a,c)   % ans = 0
%
% See also: EPS, ISEQUAL

%% Check arguments
narginchk(2,2);
assert(isfloat(A) && isfloat(B), 'inputs a and b must be floats');

%Ensure the length of Dimensions_A and Dimensions_B match
Dimensions_A = size(A);
Dimensions_B = size(B);
if(length(Dimensions_A) == length(Dimensions_B))
    %Continue
else
    %Add '1' to missing dimensions for elementwise comparison
    Dimension_List = [length(Dimensions_A), length(Dimensions_B)];
    for Current_Dimension = min(Dimension_List):max(Dimension_List)
        if(Dimension_List(1) > Dimension_List(2))
            Dimensions_B(Current_Dimension) = 1;
        else
            Dimensions_A(Current_Dimension) = 1;
        end
    end
end
Size_A = numel(A);
Size_B = numel(B);
if(Dimensions_A == Dimensions_B)
    %Identical sizes already
elseif((Size_A == 1) || (Size_B == 1))
    if(Size_A == 1)
        A = repmat(A, size(B));
    elseif(Size_B == 1)
        B = repmat(B, size(A));
    else
        assert(all(size(A) == size(B)), 'Unknown input condition');
    end
else
    assert(all(size(A) == size(B)), 'inputs a and b must be the same size');
end

%% Check for equivalence of each element, within the tolerance
yn = abs(A - B) <= eps(max(abs(A), abs(B)));
%yn = all(yn);  % scalar logical output
