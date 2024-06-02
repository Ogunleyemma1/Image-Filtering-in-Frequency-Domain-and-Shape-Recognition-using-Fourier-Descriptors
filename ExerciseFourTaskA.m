function ExerciseFourTaskA

%Part A: Image Filtering in Frequency Domain
%------------------------------------------------------------------

%Task a: Read input Image and convert to grey scale
InputImage = double(imread("taskA.png"))/255; % reading input image
greyImage = rgb2gray(InputImage); %Convert Image to grey scale

%Task b: Add Gaussian Noise to the image and plot
noisyImage = imnoise(greyImage, 'gaussian', 0, 0.01); %function for adding gaussian noise
figure; imshow(noisyImage); %plotting the noise image
title("Task A. Test Image with Gaussian Noise");

%Task c: Filter the Noisy Image with self-computed 2D Gaussian Filter
%Computing in Frequency Domain

sigma = 0.5; % Defining a standard deviation for Gaussian Filter Computation

%Computing the gaussian Filter
gaussianFilter = ComputeGaussianFilter(noisyImage, sigma);

%Perforing filtering using Image and Filter in frequency domain
filteredImage = FilteringInFrequencyDomain(noisyImage, gaussianFilter);

%plotting the resulting filtered image
figure; imshow(filteredImage, []);
title(["Task A. Filtered Image with Gaussian Filter, \sigma = ", num2str(sigma)]);

%Task d: Plotting the image spectrum, logarithmic scaled image spectrum,
%and centered scaled image spectrum for Noise Image, Guassian Filter and
%Filtered Image

PlotImageSpectrum(noisyImage, gaussianFilter, filteredImage);
end


%Implementing a function to compute Gaussian Filter
function gaussianFilter = ComputeGaussianFilter(image, sigma)

[row, col] = size(image); % obtaining the size of the image pixels

%Creating a 2D Guassian filter in spatial domain
[x, y] = meshgrid(-floor(col/2) : floor(col/2) - 1, -floor(row/2) : floor(row/2) -1);

%Calculating the gaussianFilter
gaussianFilter = (1/(2 * pi * sigma^2)) * exp(-(x.^2 + y.^2)/ (2 * sigma^2));

%Normalizing the filter
gaussianFilter = gaussianFilter / sum(gaussianFilter(:));

end

%Implementing a function to filter image in frequency domain
function filteredImage   = FilteringInFrequencyDomain(image, filter)

[row, col] = size(image); % obtaining the size of the image pixels

%Padding and Transforming the filter into frequency domain
H = fftshift(fft2(ifftshift(filter), row, col));

%Transforming the Image into frequency domain
F = fft2(image);

%Applying the filter to the image in the frequency domain
G = H .* F;

%Transforming the result of filtering back to spartial domain
filteredImage = real(ifft2(G));

end

%Implement a function to plot image spectrum, logarithmic sacled image
%spectrum and
function PlotImageSpectrum(noisyImage, gaussianFilter, filteredImage)

% Plotting for Noisy Image
figure('Position', [100, 100, 900, 400]);
sgtitle('Noisy Image');

% Noisy Image
subplot(1, 3, 1);
imagesc(abs(noisyImage));
axis square;
colorbar;
title('Noisy Image');

% Noisy Image Spectrum
subplot(1, 3, 2);
imagesc(log(abs(fft2(noisyImage))));
axis square;
colorbar;
title('Logarithmic Scaled Image Spectrum');

subplot(1, 3, 3);
imagesc(log(abs(fftshift(fft2(noisyImage)))));
axis square;
colorbar;
title('Centered Scaled Image Spectrum');

% Plotting for Gaussian Filter
figure('Position', [100, 100, 900, 400]);
sgtitle('Gaussian Filter');

% Gaussian Filter
subplot(1, 3, 1);
imagesc(abs(gaussianFilter));
axis square;
colorbar;
title('Gaussian Filter');

% Gaussian Filter Spectrum
subplot(1, 3, 2);
imagesc(log(abs(fft2(gaussianFilter, size(noisyImage, 1), size(noisyImage, 2)))));
axis square;
colorbar;
title('Logarithmic Scaled Image Spectrum');

subplot(1, 3, 3);
imagesc(log(abs(fftshift(fft2(gaussianFilter, size(noisyImage, 1), size(noisyImage, 2))))));
axis square;
colorbar;
title('Centered Scaled Image Spectrum');

% Plotting for Filtered Image
figure('Position', [100, 100, 900, 400]);
sgtitle('Filtered Image');

% Filtered Image
subplot(1, 3, 1);
imagesc(abs(filteredImage));
axis square;
colorbar;
title('Filtered Image');

% Filtered Image Spectrum
subplot(1, 3, 2);
imagesc(log(abs(fft2(filteredImage))));
axis square;
colorbar;
title('Logarithmic Scaled Image Spectrum');

subplot(1, 3, 3);
imagesc(log(abs(fftshift(fft2(filteredImage)))));
axis square;
colorbar;
title('Centered Scaled Image Spectrum');

end

