# Data Operations

Matlab scripts that provide some simple quality of life functions while performing transformations on data or datatype conversions. This is a supporting submodule for other repositories.

### Functions
#### Array_to_Index.m
Quantises a grayscale image consisting of floating point data into an integer representation with an associated lookup table.  LUT_Entries dictates the number of grayscale levels, Linear_Interp set to true forces the LUT to be  spaced linearly rather than by using pchip for non-evenly distributed data (false, default).
```matlab
Image = rand(100, 100);
LUT_Entries = 100;
Linear_Interp = true;
[Index_Sorted, LUT_Sorted] = Array_To_Index(Image, LUT_Entries, Linear_Interp)
```

#### Binary_To_Float.m<sup>1</sup>
Converts a binary vector to a floating point number.
```matlab
Binary = '0011111111110100110011001100110011001100110011001100110011001101';
Float= Binary_To_Float(Binary);
Float = 1.3;
```

#### Bit_String_To_Vector.m<sup>1</sup>
Converts a string to a vector of bit values.
```matlab
Bit_Vector = [0 1 0 1 1 1 1 0];
Bit_String = Bit_String_To_Vector(Bit_Vector);
Bit_String = '01011110';
```


#### Bit_Vector_To_String.m<sup>1</sup>
Converts a vector of bit values to a string of 1's and 0's.
```matlab
Bit_Vector = [0 1 0 1 1 1 1 0];
Bit_String = Bit_Vector_To_String(Bit_Vector);
Bit_String = '01011110';
```


#### Float_To_Binary.m<sup>1</sup>
Converts a floating point number into a binary string.
```matlab
Float = 1.3;
Binary = Float_To_Binary(Float);
Binary = '0011111111110100110011001100110011001100110011001100110011001101';
```

#### Floating_Point_Equal.m
Avoids floating point calculation errors with extremely small numbers. This function is capable of comparing
* Two scalars
* One vector against one scalar
* Two *equally sized* vectors.
```matlab
%Create a vector and scalar value to compare
A = rand(5,1);
B = rand(1);
%Get array with the comparison results
Boolean_Vector = Floating_Point_Equal(A, B);
```


#### Get_Figure.m
Circular reference to a figure. If no inputs are supplied, a new figure is created. If a figure is specified by one instance of this function, on the next iteration of the loop it will re-select this figure as being active. This function must be called initially with no input to generate the initial window. The figure can be shown (default) or shown by specifying Hide_Figure as being true.
```matlab
%Create two figures initially
Hide_Figure = false;
Figure_1 = Get_Figure();
Figure_2 = Get_Figure();
for i = 1:10
	%re-select first figure
	Figure_1 = Get_Figure(Figure_1, Hide_Figure);
	%Plot stuff
	%re-select second figure
	Figure_2 = Get_Figure(Figure_2, Hide_Figure);
	%Plot stuff
end
```


#### Moving_STD_2D.m
2-dimensional moving standard deviation that creates a window of size (2*K + 1) by (2*K + 1).
```matlab
Data = rand(50);
K = 2;
%Creates a 5x5 window calculating a moving standard deviation across Data
Std_Dev = Moving_STD_2D(Data, K);
```


#### NaN_Conv.m<sup>2</sup>
Does a 2D convolution while ignoring NaN values. Varagin allows various parameters to be set regarding the shape, edges and dimensionality of the inputs (information found within the script for more information).
```matlab
Data = rand(50);
K = 2;
Convolution = NaN_Conv(Data, K, varargin);
```

## Built With

* [Matlab R2018A](https://www.mathworks.com/products/matlab.html)
* [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)

## References
* **Alex Hogg** - *Initial work* - [Phy3hogga](https://github.com/Phy3hogga)
* **Eric Verner** - *Binary and Bit String conversion<sup>1</sup>* - [Matlab File Exchange](https://uk.mathworks.com/matlabcentral/fileexchange/39113-floating-point-number-conversion)
*  **Benjamin Kraus** - *2D convolution ignoring NaN values<sup>2</sup>* - [Matlab File Exchange](https://uk.mathworks.com/matlabcentral/fileexchange/41961-nanconv)