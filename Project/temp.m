clear all;close all;

filename = './Templates/beat68.jpg';
img = imread(filename);
img2 = imresize(img, 0.8);

imwrite(img2, filename);