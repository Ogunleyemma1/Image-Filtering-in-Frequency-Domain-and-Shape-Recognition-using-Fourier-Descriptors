# Image-Filtering-in-Frequency-Domain-and-Shape-Recognition-using-Fourier-Descriptors
# Image filtering in the frequency domain
*   Read the input image taskA.png and convert it to a grayscale image (double values between 0.0 and 1.0).
*   Add Gaussian noise to the image (imnoise, parameters e.g. M=0, V=0.01) and plot the result.
*   Filter the noisy image with a self-computed 2D Gaussian filter in the frequency-domain (fft2, ifft2). Which 𝜎 is suitable to remove the noise? Plot the result.
*   Plot the logarithmic centered image spectra of the noisy image, the (padded) Gaussian filter and the filtered image (imagesc, log, abs and fftshift).
  
# Shape recognition using Fourier descriptors
*  Read the image trainB.png and convert it to a grayscale image (double values between 0.0 and 1.0).
*  Derive a binary mask (data type logical) of the image where 1 represents the object of interest and 0 represents the background (graythresh and im2bw).
*  Build a Fourier-descriptor 𝐷𝑓 based on the binary mask of b.
*   I. Extraction of boundaries of the binary mask (bwboundaries).
*   ii. Use 𝑛=24 elements for the descriptor.
*   iii. Make the descriptor invariant to translation, orientation, and scale.
* Apply steps a.-c. on the images test1B.jpg, test2B.jpg and test3B.jpg in order to identify all potential object boundaries in the images. Note that here more than one boundaries will be identified by bwboundaries.
* Identify the object of interest by comparing the trained Fourier descriptor (result of step c) with all identified descriptors of the test images from step d. Use the Euclidean distance of the Fourier-descriptors for identification, i.e. norm(𝐷𝑓,𝑡𝑟𝑎𝑖𝑛−𝐷𝑓,𝑡𝑒𝑠𝑡)<0.09
* Plot the identified boundaries on your mask (result of task b.) in order to validate the results (imshow, hold on and plot)

  
