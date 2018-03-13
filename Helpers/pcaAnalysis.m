function [PCA_custom, PCA_builtin] = pcaAnalysis(rawD, numC, Dname, vis)
%% pcaAnalysis: custom pca analysis
% This function takes in rasterized data set of size [N x d] and returns a structure containing all
% data extracted after pca analysis. User defines number of components to reduce to.
%
% Usage:
%   [PCA_custom, PCA_builtin] = pcaAnalysis(rawD, numC, Dname, vis)
%
% Input:
%   rawD: rasterized data set to conduct analysis
%   numC: number of PCA components to reduce
%   Dname: name for data being analyzed (for figure names)
%   vis: visualize various output from analysis
%
% Output:
%   PCA_custom: structure containing data using my custom pca function
%   PCA_builtin: structure containing data using MATLAB's built-int pca function
%
%

%% PCA using my custom pca function
% Find and subtract off means
avgD  = mean(rawD, 1);
subD  = bsxfun(@minus, rawD, avgD);

% Get Variance-Covariance Matrix
covD = (subD' * subD) / size(subD,1);

% Get Eigenvector and Eigenvalues
[eigV, eigX] = eigs(covD, numC);

% Simulate data points by projecting eigenvectors onto original data 
pcaS = subD * eigV;
simD = ((pcaS * eigV') + avgD);

%% Setup output structure
PCA_custom = struct('InputData',    rawD, ...
                    'MeanVals',     avgD, ...
                    'MeanCentered', subD, ...
                    'VarCovar',     covD, ...
                    'EigVectors',   eigV, ...
                    'EigValues',    eigX, ...
                    'PCAscores',    pcaS, ...
                    'SimData',      simD);

%% ---------------------------------------------------------------------------------------------- %%
%% PCA using MATLAB's built-in pca function
warning('off','stats:pca:ColRankDefX'); % Turn off T-squared warning message for using > 3 PCs 
[C, S, L, T, E, M] = pca(rawD, 'NumComponents', numC, 'Algorithm', 'eig');
PCA_builtin        = struct('COEFF',     C, ...
                            'SCORE',     S, ...
                            'LATENT',    L, ...
                            'TSQUARED',  T, ...
                            'EXPLAINED', E, ...
                            'MU',        M);

%% ---------------------------------------------------------------------------------------------- %%
%% Show output from custom PCA analysis 
if vis
    figure;    
    colormap cool;
    
    subplot(311);
    imagesc(rawD);
    title('Raw Rasterized Data');
    xlabel('Dimension');
    ylabel('Index');
    
    subplot(312);
    imagesc(subD);
    title('Mean Centered Data');
    xlabel('Dimension');
    ylabel('Index');
    
    subplot(313);
    imagesc(covD);
    title('Variance-Covariance Matrix');
    
    figure;
    colormap cool;
    
    subplot(211);
    imagesc(eigX);
    title('Eigenvectors');
    
    subplot(212);
    imagesc(eigV);
    title('Eigenvalues in descending order');
    

%% Show output from built-in pca analysis
    figure;
    subplot(231); imagesc(PCA_builtin.COEFF);     title('Coefficients (Variables to each X)');
    subplot(232); imagesc(PCA_builtin.EXPLAINED); title('Explained (% variance by each PC and Mu');
    subplot(233); imagesc(PCA_builtin.LATENT);    title('Latent (PC variances)');
    subplot(234); imagesc(PCA_builtin.MU);        title('Mu (Mean of each X)');
    subplot(235); imagesc(PCA_builtin.SCORE);     title('Scores (PC for each X)');
    subplot(236); imagesc(PCA_builtin.TSQUARED);  title('T-Squared of each X');

    % Reshape COEFF and plot individual PCs
    % Replace (1, 800) with generalized reshape size
    PCA_builtin.resCOEFF = reshape(PCA_builtin.COEFF, 1, 800, numC);      
    figure;
    imagesc(PCA_builtin.SCORE);
    title(sprintf('%d Principal Components: %s', numC, Dname)), colormap cool;

    figure;
    for i = 1 : numC
        subplot(round(numC/2), 2, i);
        plot(PCA_builtin.resCOEFF(:,:,i));
        title(sprintf('PC %d', i));
    end



end

end




