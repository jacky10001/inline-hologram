%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RECONSTRUCTION OF HOLOGRAMS RECORDED WITH PLANE WAVES 
% Author: Tatiana Latychevskaia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
area = 0.002;              % area size in meter
z_start = 0.06;            % z start in meter
z_end = 0.10;              % z end in meter
z_step = 0.005;            % z step in meter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READING HOLOGRAM OBJECT

    fid = fopen('a_hologram.bin', 'r');
    hologramO = fread(fid, [N, N], 'real*4');
    fclose(fid);      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECT RECONSTRUCTED AT DIFFERENT Z-DISTANCES

S = round((z_end - z_start)/z_step);
reconstructionO = zeros(N,N,S);

for ii=1:S 
z = z_start + ii*z_step
prop = Propagator(N, lambda, area, z);
recO = abs(IFT2Dc(FT2Dc(hologramO).*prop));
reconstructionO(:,:,ii) = recO(:,:);

imshow(abs(reconstructionO(:,:,ii)), []);
colormap(gray)
pause(0.01);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE RECONSTRUCTION AS BIN FILE

fid = fopen(strcat('b_reconstruction_z_',int2str(z*1000000),'um.bin'), 'w');
fwrite(fid, recO, 'real*4');
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE RECONSTRUCTION AS JPG FILE
p = recO;
p = 255*(p - min(min(p)))/(max(max(p)) - min(min(p)));
imwrite (p, gray, strcat('b_reconstruction_z_',int2str(z*1000000),'um.jpg'));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
