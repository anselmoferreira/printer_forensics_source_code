function features = extract_glcm(printer_names, mode)
%EXTRACT_GLCM Extracts GLCM features from an image.
%   Extracts GLCM texture features for each printer's image.
%   mode = 'byChar' extracts per character
%   mode = 'byPage' acumulates characters and extracts per page

    % Call for all printers:
    %{'Brother-HL4070CDW', 'Canon-D1150', 'Canon-MF3240', 'Canon-MF4370DN', 
    %'HP-CLJ-CP2025A', 'HP-CLJ-CP2025B', 'HP-JL-CP1518', 'Lexmark-E260D', 
    %'OKI-C330', 'Samsung-CLP315'}

    %% Makes sure we're dealing with a vector
    if (size(printer_names(:), 1) == 0)
        error('Invalid input parameter: no printers specified.');
    else
        printer_names = printer_names(:);
    end
    
    %% Sets constants and needed variables
    if (strcmp(mode, 'byCharacter'))
        base_path = '..\..\dataset\characters\';
    elseif (strcmp(mode, 'byPage'))
        base_path = '..\..\dataset\characters\';
    end
    
    features = cell(size(printer_names, 1), 2);
    
    %% Festure extraction for each printer
    for i = 1:length(printer_names)
        disp(['Starting printer ' printer_names{i}]);
        
        printer_path = fullfile(base_path, char(printer_names(i)));
        
        if (strcmp(mode, 'byCharacter'))
            features{i, 2} = printer_features_by_char(printer_path);
        elseif (strcmp(mode, 'byPage'))
            features{i, 2} = printer_features_by_page(printer_path);
        end
        
        disp(['Printer ' printer_names{i} ' finished.']);
    end
    
    % features{i, 1} must be defined now, away from features{i, 2} so 
    % MATLAB doesn't think parfor will explode.
    for i = 1:length(printer_names)
        features{i, 1} = printer_names{i};
    end
end
