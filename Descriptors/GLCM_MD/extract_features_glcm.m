% The parameters to produce a MATLAB GLCM correctly is using this sequence:
% Let I be a 256 grayscale image:
% [glcm, SI] = graycomatrix(I, 'NumLevels', 256, 'G', []);
% glcm will be the GLCM (you don't say), Si is the scaled image MATLAB
% produces in order to calculate the GLCM (in this case, it is the matrix
% itself added plus 1), and G is the GrayLimits parameter. In this case it
% is using [min(I(:)) max(I(:))]. You can specify by [MIN MAX] ([0 255],
% canonically).

%% Feature vector extraction
function feature_vector = extract_features_glcm(image, offset)
    % Extracts the features from a given image
    
    RoI = extract_RoI(binarize(image, true));
    glcm = glcm_generate(image, RoI, offset, 256);
    
    % R is defined as the number of pixel in the RoI
    % Rglcm is defined as the number of pixels that are both in the RoI and
    % have its neighbors in the RoI.
    
    % Rglcm is kinda the area of the RoI, but a pixel is counted only if
    % it's neighbour (i+dr, j+dc) is also contained in the RoI.
    dr = offset(1); dc = offset(2);
    [H W] = size(RoI);
    padded_RoI = false(size(RoI));
    
    % The case dr or dc are 0 implies no transformation, nevertheless I'm
    % considering the null identity in the >= case so padded RoI has
    % actually some value when it reaches "if (dc ...)" rather than 0
    if (dr >= 0)
        padded_RoI = [zeros(dr, W); RoI(1:(H-dr), 1:W)];
    else
        padded_RoI = [RoI((1-dr):H, 1:W); zeros(-dr, W)];
    end
    
    if (dc >= 0)
        padded_RoI = [zeros(H, dc) padded_RoI(1:H, 1:(W-dc))];
    else
        padded_RoI = [padded_RoI(1:H, (1-dc):W) zeros(H, -dc)];
    end
    
    % Old padded_RoI (broken?) construction
    %padded_RoI((1+dr):H, (1+dc):W) = RoI(1:(H-dr), 1:(W-dc));
    
    Rglcm = sum(sum(RoI .* padded_RoI));
    
    clear padded_RoI;
    
    % p_glcm should be a valued function. Instead, it's a matrix. Lots moar
    % fun. As a matrix, it's being called P_glcm
    P_glcm = (1 / Rglcm) * glcm;

    % Pr and Pc are marginal prob dens functions that count only on certain
    % rows or columns, respectively. Using line vectors (MATLAB's default)
    Pr = sum(P_glcm, 2)';
    Pc = sum(P_glcm, 1);
    
    % ur and uc are means of those functions (the same, by the way)
    ur = sum(Pr * (0:255)');
    uc = sum(Pc * (0:255)');
    
    % sr and sc are variances (s from "sigma")
    indexes = 0:255; % starting from 0 as described in the paper
    
    %sr = sum(indexes.^2 .* Pr - ur^2);
    %sc = sum(indexes.^2 .* Pc - uc^2);
    
    sr = sum(Pr * (indexes' - ur).^2);
    sc = sum(Pc * (indexes' - uc).^2);
    
    energy = sum(sum(glcm .^2));
    
    %hxy1 = 0; hglcm = 0;
    % grants P_glcm, Pr and Pc have no 0 entries
    P_glcm = double(P_glcm);
    Pr = double(Pr);
    Pc = double(Pc);
    
    % hxy1 = - sum(sum( P_glcm(n,m) * log2(Pr(n) * Pc(m)) ))
    % Basically, hxy2 = - sum(sum( P_glcm .* log2(Pr' * Pc) ))          (1)
    % Let innerprod = Pr' * Pc.
    % Then (1) can also be written P_glcm(:) * log2(innerprod(:)')
    % So, if we first take out any null term of innerprod and trim P_glcm
    % so the same components are taken out too, then we can write
    % (considering both P_glcm and innerprod line-vectors):
    % hxy2 = - P_glcm * log2(innerprod');
    pglcm = P_glcm(:);
    innerprod = Pr' * Pc;
    innerprod = innerprod(:);
    
    bininnerprod = pglcm .* innerprod;
    bininnerprod(bininnerprod > 0) = 1;
    
    pglcm = pglcm .* bininnerprod;
    innerprod = innerprod .* bininnerprod;
    
    pglcm(pglcm == 0) = [];
    innerprod(innerprod == 0) = [];
    
    hxy1 = - (pglcm') * log2(innerprod);
    
    clear innerprod bininnerprod;
    
    prpc = Pr .* Pc;
    prpc(prpc == 0) = [];
    hxy2 = - prpc * log2(prpc)';
    
    hglcm = - (pglcm') * log2(pglcm);
    
    % Maximum Likelihood Estimation. As P_glcm is a probability density
    % function, a simple max search returns the desired result.
    MaxProb = max(max(P_glcm));
    
    % Matrices needed for rho_nm, a kind of correlation. A and B are used
    % later on diagcorr.
    A = repmat((0:255)', 1, 256);
    B = repmat((0:255), 256, 1);
    C = (A - ur) .* (B - uc);
    
    rho_nm = (1 / (sr * sc)) * sum(sum( C .* P_glcm ));
    clear C;
    
    C = abs(A - B);
    D = (A + B) - ur - uc;
    
    diagcorr = sum(sum( C .* D .* P_glcm ));
    clear A B C D;
    
    % Now we define the difference and sum histograms and compute a couple
    % of things from them.
    % IMPORTANT: Indexing starts at 1, but pictured values are in between 0
    % and 255 (or 510).
    D = zeros(256, 1);
    S = zeros(511, 1);
    
    % One-pass counting for both histograms
    for n = 0:255
        for m = 0:255
            D(1 + abs(n - m)) = D(1 + abs(n - m)) + P_glcm(1+n, 1+m);
            S(1 + (n + m)) = S(1 + (n + m)) + P_glcm(1+n, 1+m);
        end
    end
    
    % Features for D(k): energy (Denergy), entropy (hD), inertia(ID) and local
    % homogeneity (HD)
    
    % IMPORTANT: The energy for this feature was defined incorrectly.
    Denergy = sum(D.^2);
    
    hD = entropy(D);
    
    ID = ((0:255).^2) * D;
    
    HD = (1./(1 + (0:255).^2)) * D;
    
    % Features for S(k): energy (Senergy), entropy (hS), 
    % variance (varS), cluster shade (AS) and cluster prominence (BS). The
    % mean (uS) is required for varS.
    % Note: the paper says AD and BD, prolly just mistyped.
    
    % IMPORTANT: The energy for this feature was defined incorrectly.
    Senergy = sum(S.^2);
    
    hS = entropy(S);
    
    k = 0:510;
    uS = k * S;
    
    varS = (k - uS).^2 * S;
    clear uS;
    
    somehow_combined_var = sr - sc + 2*sqrt(sr)*sqrt(sc);
    
    AS = ((k - ur - uc).^3) * S ./ (somehow_combined_var)^(3/2);
    
    BS = ((k - ur - uc).^4) * S ./ (somehow_combined_var)^2;
    
    % At this point, D(k) and S(k) are not used anymore. So is the k array.
    % We still need two metrics from the whole image, so let's clean up a
    % bit, then.
    clear D S k;
    
    % Variance of RoI: The variance of the filtered out RoI from the image,
    % times the area of the image, divided by the area of the RoI.
    filtered_roi = image .* uint8(RoI);
    area_roi = sum(sum(RoI));
    area_image = H * W;
    
    simg = ( area_image * var(double(filtered_roi(:))) ) / area_roi;
    
    clear area_image;
    
    % For the entropy, we will need one more histogram
    p_img = zeros(256, 1);
    
    % Shame on me again. One more double for.
    for i = 1:H
       for j = 1:W
           if (RoI(i,j))
               p_img(1 + image(i,j)) = p_img(1 + image(i,j)) + 1;
           end
       end
    end
    
    p_img = p_img / area_roi;
    
    % Finally, the entropy
    h_img = entropy(p_img);
    
    % MATLAB's entropy implementation can be adjusted to hasten the
    % calculation. I am not fixing this yet, I am plotting without a solid
    % assurance about its correctness. This is now a TODO.
    
    % Problems with: hxy1, hxy2, hglcm, hD, hS and h_img. All NaNs.
    feature_vector = [ur uc sr sc energy hxy1 hxy2 hglcm MaxProb rho_nm ...
        diagcorr Denergy hD ID HD Senergy hS varS AS BS simg h_img];
end
