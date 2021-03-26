function Binary = Float_To_Binary(Float)
%This function converts a floating point number to a binary string.
%
%Input: f - floating point number, either double or single
%Output: b - string of "0"s and "1"s in IEEE 754 floating point format
%
%Floating Point Binary Formats
%Single: 1 sign bit, 8 exponent bits, 23 significand bits
%Double: 1 sign bit, 11 exponent bits, 52 significand bits
%
%Programmer: Eric Verner
%Organization: Matlab Geeks
%Website: matlabgeeks.com
%Email: everner@matlabgeeks.com
%Date: 22 Oct 2012
%
%I allow the use and modification of this code for any purpose.
%Input checking
if ~isfloat(Float)
  disp('Input must be a floating point number.');
  return;
end
hex = '0123456789abcdef'; %Hex characters
h = num2hex(Float);	%Convert from float to hex characters
hc = num2cell(h); %Convert to cell array of chars
nums =  cellfun(@(x) find(hex == x) - 1, hc); %Convert to array of numbers
bins = dec2bin(nums, 4); %Convert to array of binary number strings
Binary = reshape(bins.', 1, numel(bins)); %Reshape into horizontal vector
