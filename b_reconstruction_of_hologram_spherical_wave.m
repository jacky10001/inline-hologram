%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCTION OF HOLOGRAMS RECORDED WITH SPHERICAL WAVES 
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

addpath('C:/Program Files/MATLAB/R2010b/myfiles');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS

N = 500;                   % number of pixels
lambda = 500*10^(-9);      % wavelength in meter
h = 0.050;                 % hologram size in meter
z = 0.1;                   % source-to-detector distance in meter
z0_start = 0.001;          % start source-to-sample distance in meter
z0_end = 0.003;            % end source-to-sample distance in meter
z0_step = 0.0002;          % step source-to-sample distance in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READING HOLOGRAM

    fid = fopen('a_hologram.bin', 'r');
    hologramO = fread(fid, [N, N], 'real*4');
    fclose(fid);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECT RECONSTRUCTED AT DIFFERENT Z-DISTANCES

S = round((z0_end - z0_start)/z0_step);
reconstructionO = zeros(N,N,S);

for ii=1:S 
z0 = z0_start + ii*z0_step
area = z0*h/z;

prop = PropagatorS(N, lambda, area, z0);
recO = abs(IFT2Dc(FT2Dc(hologramO).*prop));
reconstructionO(:,:,ii) = recO(:,:);

imshow(abs(reconstructionO(:,:,ii)), []);
colormap(gray)
pause(0.01);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE RECONSTRUCTIONS AS BIN FILES

fid = fopen(strcat('b_reconstruction_z0_',int2str(z0*100000),'_area_',int2str(area*100000),'um.bin'), 'w');
fwrite(fid, recO, 'real*4');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE RECONSTRUCTIONS AS JPG FILES

p = recO;
p = 255*(p - min(min(p)))/(max(max(p)) - min(min(p)));
imwrite (p, gray, strcat('b_reconstruction_z0_',int2str(z0*100000),'_area_',int2str(area*100000),'um.jpg'));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
