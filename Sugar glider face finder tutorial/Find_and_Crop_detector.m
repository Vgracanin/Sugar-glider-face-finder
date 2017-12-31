%This code uses the sugarglider detector algorithm to find and crop the sugarglider face 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Firstly we add the path where the .xml file is located, so matlab can find it  
addpath('C:\Users\Vanja_000\Desktop\Sugar Glider face finder\')

% Next we find out how many folders there are and store their names in a struct 
filestoanalyse = dir('C:\Users\Vanja_000\Desktop\Sugar Glider face finder\folderimages');
nfiles = size(filestoanalyse);
numberfolders = nfiles(1);% Returns the number of folders in the "folderimages" folder 
% there are actualy +2 files on top of the actual number of folders (2 are
% hidden files)

% Next few lines, we extract the folder names and stores them in a struct of name "namefolders"
namefolders = struct('names',{});
for k = 1:numberfolders
    namefolders(k).names = filestoanalyse(k).name;
end

folders_choose = numberfolders+1; % here is the nunmber of folders to analyse 
% its default to total number of folders at the moment. The +1 is to work with the for loop  

%%
for foldernum = 3:folders_choose % 3: is the default to start from the beggining (assuming there is atleast one folder of images)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we acsess the jpg files in each folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
jpgFiles = 'C:\Users\Vanja_000\Desktop\Sugar Glider face finder\folderimages\';
currentfile = strcat(jpgFiles,filestoanalyse(foldernum).name);

% See how many jpeg images are in the current folder to be analysed 
jpgFiles = dir(strcat(currentfile,'\*.jpg'));
n = size(jpgFiles);
numFiles1 = n(1) % numFiles1 is number of images in the file 

% This extracts the names of the images in the folder and stores them in a struct of name s 
s= struct('names',{});
for k = 1:numFiles1
    s(k).names = jpgFiles(k).name;
end

% Create a unique folder for the croped images to go to 
cd 'C:\Users\Vanja_000\Desktop\Sugar Glider face finder\folderimages_cropped\' % change into the directory where cropped images will go
mkdir (filestoanalyse(foldernum).name) % make new cropped folder name for each folder of images 
% this is the directory that the cropped images are going into: 
croppdirectoryname= strcat('C:\Users\Vanja_000\Desktop\Sugar Glider face finder\folderimages_cropped\',filestoanalyse(foldernum).name);

% go back to the directory that the original images are being croped from 
cd(currentfile);

for j=1:numFiles1 
            I=imread(jpgFiles(j).name); % Read input image
            %imshow(I);
            % Use the newly trained classifier to detect a sugar gliders face in the image.
            detector = vision.CascadeObjectDetector('V2sugargliders.xml');
            % Detect faces
            bbox = step(detector, I);
            % Insert bounding box rectangles and return the marked image.
            detectedImg = insertObjectAnnotation(I,'rectangle',bbox,'V2sugar_glider');
            sd = size(bbox);
            row = sd(1);
 
            %some max area initialisation (finding the row with the dimensions of rectangle needed for croppping.
            % So we get the largest face selected and croped (ie, not faces that are further from camera) 
                for i = 1:row
                %I = bbox(1,:) %outputs first row 
                I1 = bbox(i,1); I2 = bbox(i,2); I3 = bbox(i,3); I4 = bbox(i,4);
                %length = abs(I1-I2); width = abs(I3-I4);
                area(i) = abs(I1-I2)*abs(I3-I4);
                %area(i) = length*width; 
                if area(i)> 0;
                X1 = [I1 I2 I3 I4]; 
                if I1 >200 && I2 >200 && I3>200 && I4>200 % basicaly only crop things worthwhile 
                croppedFace = imcrop(I,[X1]);
            %Display the cropped image 
            %figure; imshow(croppedFace);
            imwrite(croppedFace,strcat('cropped',jpgFiles(j).name)); % adding the word croped to original image name and creating image
            SS = strcat(currentfile,'\','cropped',jpgFiles(j).name)  % calling the location of the new croped image 
            movefile(SS,croppdirectoryname); % move the new croped image to the croped images folder 
                end
                end
                end    
end

end % this end the folder analysis 


