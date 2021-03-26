%% Dumps the entire current workspace to a directory in a .mat file
%:Inputs:
% - Filename (Character Array) ; filename for the .mat file
% - Directory_Path (Character Array) ; if [\Workspace_Dumps] isn't the path requested
%:Outputs:
% - Success (Boolean)
function Success = Dump_Workspace(Workspace_Dump_Filename, Directory_Path)
    %% Assume dump can be completed
    Workspace_Dump_Valid = true;
    
    %if Directory_Path exists
    if(~exist('Directory_Path','var'))
        Directory_Path = 'Workspace_Dumps';
    end
    
    %% Verify dump directory exists
    Dump_Directory_Exists = Attempt_Directory_Creation(Directory_Path);
    if(~Dump_Directory_Exists)
        disp("Dump Directory not found, unable to dump workspace");
        Workspace_Dump_Valid = false;
    end
    clear Dump_Directory_Exists;
    
    %% Verify user filename
    %Check filename is valid
    Workspace_Dump_File_Filename_Match = regexpi(Workspace_Dump_Filename,'[A-Z0-9\-\_.\(\)]+', 'match');
    if(~strcmp(Workspace_Dump_File_Filename_Match, Workspace_Dump_Filename))
        disp("Invalid filename supplied, unable to dump workspace");
        Workspace_Dump_Valid = false;
    end
    clear Workspace_Dump_File_Filename_Match;
    
    %Check file has a .mat extension
    Dump_File_Extension_Exists = endsWith(Workspace_Dump_Filename,'.mat','IgnoreCase',true);
    if(~Dump_File_Extension_Exists)
        Workspace_Dump_Filename = strcat(Workspace_Dump_Filename,'.mat');
    end
    clear Dump_File_Extension_Exists;
    
    %Check filename has at least one character other than the extension
    if(length(Workspace_Dump_Filename) <= 4)
        disp("Invalid filename supplied, unable to dump workspace");
        Workspace_Dump_Valid = false;
    end
    
    %% If the filename is valid and the dump directory exists
    if(Workspace_Dump_Valid)
        clear Workspace_Dump_Valid;
        %% Save parent workspace to temporary file
        evalin('base','save Workspace_Dumps\TEMPORARY_WORKSPACE_DUMP.mat -v7.3');
        %% Rename the temporary file
        movefile('Workspace_Dumps\TEMPORARY_WORKSPACE_DUMP.mat', strcat(Directory_Path, filesep, Workspace_Dump_Filename));
        
        %% If the file can be found
        if(exist(strcat(Directory_Path, filesep, Workspace_Dump_Filename), 'file') == 2)
            %% Verify the MAT file contents
            %Get variable information from parent function
            Parent_Function_Variables = evalin('caller', 'whos');
            
            %Get variable information from MAT file
            MAT_File_Object = matfile(strcat(Directory_Path, filesep, Workspace_Dump_Filename));
            Dump_File_Variables = whos(MAT_File_Object);
            
            %Remove nesting field from both structures
            Parent_Function_Variables = rmfield(Parent_Function_Variables,'nesting');
            Dump_File_Variables = rmfield(Dump_File_Variables,'nesting');
            
            %Compare contents of structures
            Success = isequaln(Parent_Function_Variables, Dump_File_Variables);
        else
            %No file exists
            Success = false;
        end
    else
        %User inputs invalid
        Success = false;
    end
end