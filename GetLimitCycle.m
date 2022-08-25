I = rgb2gray(imread('testCycle..png'));
Icomplement = imcomplement(I);
BW = imbinarize(Icomplement);
figure
imshow(BW)
Gaussian=fspecial('gaussian', 5, 1);
Lap=[0 -1 0; -1 4 -1; 0 -1 0];
j4=conv2(BW, Gaussian, 'same');
j5=conv2(j4, Gaussian, 'same');
figure
out = bwskel(imbinarize(j5),'MinBranchLength',1000);
imshow(labeloverlay(I,out,'Transparency',0))
[X,Y] = meshgrid