%% Train Sugar glider 
% Load the positive samples data from a MAT file. The file contains
% a table specifying bounding boxes for several obect categories.
% The table was exported from the Training Image Labeler app.
%%
% clear the directory 
% Load positive samples.
load('V2sugargliders.mat');
%%
% Select the bounding boxes for V2sugargliders from the table.
positiveInstances = V2sugargliders(:,1:2); % make sure you have it in the directory your working in 
%%
% Add the image directory to the MATLAB path.
imDir = 'C:\Users\Vanja_000\Desktop\Sugar Glider face finder\V2sugargliders_positive';
addpath(imDir);
%%
% Specify the folder for negative images.
negativeFolder = 'C:\Users\Vanja_000\Desktop\Sugar Glider face finder\V2sugargliders_negative';
addpath(negativeFolder);
%%
% Create an |imageDatastore| object containing negative images.
negativeImages = imageDatastore(negativeFolder);
%%
% Train a cascade object detector called 'V2sugargliders.xml'
% using HOG features.
% NOTE: The command can take several minutes to run.
trainCascadeObjectDetector('V2sugargliders.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',4);
%%
rmpath(imDir); 
