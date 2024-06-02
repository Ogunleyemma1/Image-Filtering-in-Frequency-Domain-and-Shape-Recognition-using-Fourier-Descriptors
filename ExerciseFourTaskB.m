function ExerciseFourTaskB

% Part B: Shape Recognition Using Fourier Descriptors
% -------------------------------------------------------------------

% Define the training image
trainImage = 'trainB.png';

% Perform processing for steps a - d on the train image
[trainDescriptors, trainBoundaries] = ProcessImage(trainImage);

testImages = {'test1B.jpg', 'test2B.jpg', 'test3B.jpg'};

% Perform processing on the test images and identify objects of interest
for i = 1:length(testImages)
    IdentifyObjects(testImages{i}, trainDescriptors, trainBoundaries);
end

end

% Task d:
% Implementing a function to preprocess images and compute descriptors
function [descriptors, boundaries] = ProcessImage(image)

% Task a: Read the Image and Convert it to grayscale Image
inputImage = double(imread(image)) / 255; % Reading the input image
greyImage = rgb2gray(inputImage); % Convert to grayscale image

% Task b: Derive Binary mask of the Image where 1 represents the object of
% interest and 0 represents background
threshold = graythresh(greyImage); % Compute the threshold
binaryMask = imbinarize(greyImage, threshold); % Create binary mask

% Task c: Build Fourier descriptors based on the binary mask
[descriptors, boundaries] = BuildFourierDescriptor(binaryMask);

end


% Implementing a function to build Fourier Descriptors
function [Df, boundaries] = BuildFourierDescriptor(binaryMask)

% Task c(i): Extraction of the boundaries of the binary mask
boundaries = bwboundaries(binaryMask);

% Initialize the Fourier Descriptor
Df = [];

% Initialize counter for boundary index
m = 0;

% Initialize boundary_34 variable
boundary_34 = [];

% Processing each boundary found in the image
for k = 1:length(boundaries)
    boundary = boundaries{k}; % get the current boundary

    % Task c(ii): Use n = 24 elements for the descriptor
    n = 24;

    % Obtain the boundary coordinates
    x = boundary(:, 2);
    y = boundary(:, 1);

    % Compute the complex coordinate
    z = x + 1i * y;

    % Compute the Fourier transform
    Z = fft(z);

    % Truncate or zero-pad the descriptor to n elements
    if length(Z) > n
        Df_k = Z(1:n);
    else
        Df_k = [Z; zeros(n - length(Z), 1)];
    end

    % Task c(iii): Make the descriptor invariant to translation, orientation and
    % scale
    % Translation invariance: Remove the DC component
    Df_k(1) = 0;

    % Scale Invariance: Normalize the descriptor
    Df_k = Df_k / abs(Df_k(2));

    % Rotation Invariance: Normalize the phase
    Df_k = Df_k .* exp(-1i * angle(Df_k(2)));

    % Append the current descriptor to the list of descriptors
    Df = [Df; Df_k(:).'];

    % Increment counter for boundary index
    m = m + 1;
    
    % Task d: Access the 34th array of boundary coordinates
    if m == 34
        boundary_34 = boundary;
    end
end

% Output the 34th array of boundary coordinates
disp('Coordinates of the 34th boundary:');
disp(boundary_34);

end


% Task e: Implementing a function to identify objects in test images
function IdentifyObjects(testImage, trainDescriptors, trainBoundaries)

% Process the test image and compute Fourier descriptors for each boundary
[testDescriptors, testBoundaries] = ProcessImage(testImage);

% Threshold for matching
threshold = 0.09;

% Initialize match flag
matchFound = false;

% Compare each test descriptor with the train descriptors
for i = 1:size(testDescriptors, 1)
    for j = 1:size(trainDescriptors, 1)
        % Compute the Euclidean distance between descriptors
        distance = norm(trainDescriptors(j, :) - testDescriptors(i, :));

        % Check if the distance is below the threshold
        if distance < threshold
            matchFound = true;
            disp(['Match found in ', testImage, ' for boundary ', num2str(i), ' with distance ', num2str(distance)]);

            % Plot the identified boundary on the test image
            figure;
            imshow(testImage);
            hold on;
            boundary = testBoundaries{i}; % Access the ith boundary coordinates
            plot(boundary(:, 2), boundary(:, 1), 'r', 'LineWidth', 2);
            title(['Identified Boundary in ', testImage]);
            hold off;
        end
    end
end

if ~matchFound
    disp(['No Match found in ', testImage]);
end

end

