%%EE 441000 Yi-Chun Hung 103061145 HW2 12/19/2016 
% Introduction to Biomedical Imaging,   Fall 2016
%   Template of HW2
%					Edited by Meng-Lin Li, Ph. D., 12/06/2016
%					Dept. of Electrical Engineering, National Tsing Hua University

clear all;
close all;
%% ----------- Quiz 1 ------------
% Hand writing


%% ----------- Quiz 2 ------------
% --- read the provided data
% read the real component
fid = fopen('hw2_r.dat','rb');
data_r = fread(fid,[256 256],'int32').'; % why .' ?, check the reconstructed images with and without .', you will find it out
fclose(fid);
% read the imaginary component
fid = fopen('hw2_i.dat','rb');
data_i = fread(fid,[256 256],'int32').';
fclose(fid);

KspaceData = data_r+sqrt(-1)*data_i; % k-space data



%% --- (a) ---
% Show the real and imaginary components, respectively (by Matlab instruction: imagesc()), 
% and check the data range (by Matlab instructions: colorbar, max() and min(), or mean2()... etc.).
% -- real part
figure(1)
imagesc(data_r);
axis image
axis off
colormap(gray);
colorbar
title('Real Part');
data_r_max = max(max(data_r));
data_r_min = min(min(data_r));
data_r_mean = mean2(data_r);
% -- imaginary part
figure(2)
imagesc(data_i);
axis image
axis off
colormap(gray);
colorbar
title('Imaginary Part');
data_i_max = max(max(data_i));
data_i_min = min(min(data_i));
data_i_mean = mean2(data_i);

% Do you find out that the data suffer a constant DC offset?

%% --- (b) ---
% Discuss the effects on the image when the receiver channel has a constant DC offset arising from the electronics
% Justify your findings
ImData = abs(ifftshift(ifft2(KspaceData)));
figure(3)
imagesc(ImData)
axis image
axis off
colormap(gray)
title('Image with DC offset')
%% --- (c) ---
% remove DC offset
KspaceData_DCRemoved = KspaceData - mean2(KspaceData);
ImData_DCRemoved = abs(ifftshift(ifft2(KspaceData_DCRemoved)));
figure(4)
imagesc(ImData_DCRemoved)
axis image
axis off
colormap(gray)
title('Image without DC offset')

%% --- (d) ---
% Reconstruct the imaging by using only the even samples along the ky direction (i.e., column direction)
NewKspaceData = KspaceData_DCRemoved(:,2:2:end);
NewImData_DCRemoved = abs(ifftshift(ifft2(NewKspaceData)));
figure(5)
imagesc(NewImData_DCRemoved)
axis image
axis off
colormap(gray)
title('Reconstruct with even samples along the kx direction');
%% --- (e) ---
% Use the same set of data to try implementing half Fourier imaging which saves you about half of the scan time. 
% acquire half of k-space data, remove DC offset, 
%then use the conjugate-symmetry property of Fourier transform for a real signal to build the full k-space and reconstruct the MRI image
[col,row] = size(KspaceData);
TopKspace = KspaceData(:,1:col/2);
TopKspaceDCRemoved = TopKspace - mean2(TopKspace);
BottomKspaceDCRemoved = conj(fliplr(flipud(TopKspaceDCRemoved)));
HalfKspaceDCRemoved = [TopKspaceDCRemoved BottomKspaceDCRemoved];
HalfImDataDCRemoved = abs(ifftshift(ifft2((HalfKspaceDCRemoved))));

figure(6)
imagesc(HalfImDataDCRemoved)
axis image
axis off
colormap(gray)
title('Reconstruct by left half k-space')
%% --- (f) ---
% introduce different gain over I and Q channels, and 2D inverse Fourier transform the data
GainICh = 3i;
GainQCh = 5i;
NewKspaceData = GainICh*real(KspaceData_DCRemoved)+GainQCh*sqrt(-1)*imag(KspaceData_DCRemoved); % ???: a large enough number, can be real, can be complex (real, complex, any diffences?)
%NewKspaceDataDCRemoved = NewKspaceData - mean2(NewKspaceData);
NewImDataDCRemoved = abs(ifftshift(ifft2((NewKspaceData))));


figure(7)
imagesc(NewImDataDCRemoved)
axis image
axis off
colormap(gray)
title('GainQCh = 3i GainICh = 5i')











