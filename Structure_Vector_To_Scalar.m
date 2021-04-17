%% Turns a 1D vectorised structure into a Scalar Structure (1x1)
function Scalar_Structure = Structure_Vector_To_Scalar(Data_Structure)
    Fieldnames = fieldnames(Data_Structure);
    Scalar_Structure = struct();
    for Current_Field = 1:length(Fieldnames)
        Scalar_Structure.(Fieldnames{Current_Field}) = [Data_Structure.(Fieldnames{Current_Field})];
    end
end