function RoI = extract_RoI(image)
% "For actual text this will not work since the edges of the text are not 
% well defined and the background is not uniform graylevel 0. To remedy 
% this problem, we first process the block of text with a 5x5 close-open 
% morphological filter. This operation will produce a mask which marks the 
% locations of the text characters with graylevel 255, and the background 
% with graylevel 0. This mask is then used to extract the runs and their 
% locations are then mapped back onto the original block for analysis."
% Mikkilineni et al., Signature-Embedding In Printed Documents for Security
% and Forensic Applications.

    % NOTE: I am, first of all, assuming the structuring element is a
    % square one. Secondly, I am changing the side of the quare to 2
    % pixels, since the original authors had 180x160 pixels characters.
    % Mine are 38x32 approx. Since 38*5/180 = 1.05, I am probably reducing
    % it too much.
    SE = strel('square', 2);
    RoI = imopen(imclose(image, SE), SE);
end

