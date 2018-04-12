function cntr = extractContour(bw, max_size)
%% extractContour: find contour of single image
% This function blah
%
% Usage:
%   cntr = extractContour(bw, max_size)
%
% Input:
%   bw: bw image
%   max_size: number of coordinates to normalize boundaries
%
% Output:
%   cntr: various data from contour at given frame
%

%% Get boundaries of inputted bw image
bndAll = bwboundaries(bw, 'noholes');
[~, lrg] = max(cellfun(@numel, bndAll));
bnds = bndAll{lrg};
%     bnds = bndAll{1};

%% Interpolate distances to an equalized number of coordinates
intrps = interpolateOutline(bnds, max_size);

% %% Arc lengths of countour (distances between points)
% d  = diff(bnds, 1, 1);
% dL = sum(d .* d, 2) .^ 0.5;
% 
% %% Interpolate distances to an equalized number of coordinates
% L = cumsum([0 ; dL]);
% 
% % Interpolate along x-coordinates
% xv     = bnds(:,1);
% xq     = linspace(L(1), L(end), max_size);
% I(:,1) = interp1(L, xv, xq);
% 
% % Interpolate along y-coordinates
% yv     = bnds(:,2);
% yq     = linspace(L(1), L(end), max_size);
% I(:,2) = interp1(L, yv, yq);

%% Output final structure
cntr = ContourJB('Outline', bnds, 'InterpOutline', intrps);
cntr.ReindexCoordinates;
end