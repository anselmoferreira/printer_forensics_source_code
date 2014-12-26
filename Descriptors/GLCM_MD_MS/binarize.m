function binary_image = binarize(image, invert)
    % The threshold used by this method was determined by observation.
    % Other methods, as the mean(min(image), max(image)) apply.
    
    [M,N] = size(image);    
    binary_image = zeros(M, N);
    
    for x = 1:M
        for y = 1:N
            if (image(x,y) >= 150) % worked fine for most images*
                binary_image(x,y) = 1;
            else
                binary_image(x,y) = 0;
            end
        end
    end
    
    if (invert == true)
       binary_image = (1 - binary_image);
    end
    
    binary_image = logical(binary_image);
end

% * Use MATLAB's graythresh(image) for better results, if needed.