%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION OF HOLOGRAM OF AN OBJECT RECORDED WITH SPHERICAL WAVES
% IN PARAXIAL APPROXIMATION
% Author: Tatiana Latychevskaia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation for this code/algorithm or any of its parts:
% Tatiana Latychevskaia and Hans-Werner Fink
% "Practical algorithms for simulation and reconstruction of digital in-line holograms",
% Appl. Optics 54, 2424 - 2434 (2015)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The code is written by Tatiana Latychevskaia, 2002
% tatiana(at)physik.uzh.ch
% The version of Matlab for this code is R2010b

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS

N = 500;                   % number of pixels
lambda = 500*10^(-9);      % wavelength in meter
object_area = 0.001;       % object area sidelength in meter
z0 = 0.002;                % source-to-sample distance in meter
z = 0.1;                   % source-to-detector distance in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('hologram size in meters')
h = z*object_area/z0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATING OBJECT

object = zeros(N,N);    
    object0 = imread('psi500.jpg');   
    object(:,:) = object0(:,:,1);    
    object = (object - min(min(object)))/(max(max(object)) - min(min(object)));    
    figure, imshow(object, []);  
    object = double(1 - object);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATING HOLOGRAM

area = object_area;
prop = PropagatorS(N, lambda, area, z0);
U = IFT2Dc(FT2Dc(object).*conj(prop));
hologram = abs(U).^2;

figure, imshow(hologram, []);
colormap(gray)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVING HOLOGRAM

fid = fopen(strcat('a_hologram.bin'), 'w');
fwrite(fid, hologram, 'real*4');
fclose(fid);

p = hologram;
p = 255*(p - min(min(p)))/(max(max(p)) - min(min(p)));
imwrite (p, gray, 'a_hologram.jpg');
