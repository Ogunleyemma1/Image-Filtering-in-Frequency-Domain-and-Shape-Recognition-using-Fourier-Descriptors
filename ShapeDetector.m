classdef ShapeDetector
    properties
        trainDescriptor
    end
    
    methods
        function obj = ShapeDetector(trainImagePath, threshold)
            % Constructor: preprocess the training image and extract the descriptor
            binaryImage = obj.preprocessAndBinarizeImage(trainImagePath, threshold);
            obj.trainDescriptor = obj.extractBoundaryDescriptor(binaryImage);
        end
        
        function matchedBoundaries = detectShapes(obj, testImagePaths, testThresholds)
            % Detect shapes in test images and return matched boundaries
            testBinaryImages = cellfun(@(path, thresh) obj.preprocessAndBinarizeImage(path, thresh), ...
                                       testImagePaths, num2cell(testThresholds), 'UniformOutput', false);
            
            matchedBoundaries = cell(size(testBinaryImages));
            for i = 1:numel(testBinaryImages)
                testBinaryImage = testBinaryImages{i};
                testBoundaries = obj.getBoundaries(testBinaryImage);
                matchedBoundaries{i} = obj.findMatchingBoundaries(testBoundaries);
            end
        end
        
        function displayResults(obj, testImagePaths, matchedBoundaries)
            % Display the results with matched boundaries for each test image
            numImages = numel(testImagePaths);
            figure;
            for i = 1:numImages
                subplot(1, numImages, i);
                testBinaryImage = obj.preprocessAndBinarizeImage(testImagePaths{i}, 0);
                imshow(testBinaryImage);
                title(sprintf('Identified boundaries of %s', testImagePaths{i}));
                obj.plotBoundaries(matchedBoundaries{i}, 'r', 2);
            end
        end

        
        
        
        function displayMultipleResults(obj, testImagePaths, matchedBoundaries, titles, numCols)
            % Display multiple results with customized titles and layout
            numImages = numel(testImagePaths);
            numRows = ceil(numImages / numCols);
            figure;
            for i = 1:numImages
                subplot(numRows, numCols, i);
                testBinaryImage = obj.preprocessAndBinarizeImage(testImagePaths{i}, 0);
                imshow(testBinaryImage);
                title(titles{i});
                obj.plotBoundaries(matchedBoundaries{i}, 'r', 2);
            end
        end
        
        function binaryImage = preprocessAndBinarizeImage(~, imagePath, threshold)
            % Preprocess and binarize image
            image = imread(imagePath);
            grayImage = rgb2gray(image);
            normalizedImage = mat2gray(grayImage);
            binaryImage = imbinarize(normalizedImage, threshold);
        end
        
        function descriptor = extractBoundaryDescriptor(obj, binaryImage)
            % Extract boundary descriptor
            boundaries = obj.getBoundaries(binaryImage);
            mainBoundary = obj.getLargestBoundary(boundaries);
            descriptor = obj.computeShapeDescriptor(mainBoundary);
        end
        
        function boundaries = getBoundaries(~, binaryImage)
            % Get boundaries from binary image
            [boundaries, ~] = bwboundaries(binaryImage, 'noholes');
        end
        
        function mainBoundary = getLargestBoundary(~, boundaries)
            % Find the largest boundary
            maxLength = 0;
            mainBoundary = [];
            for i = 1:length(boundaries)
                boundary = boundaries{i};
                if length(boundary) > maxLength
                    maxLength = length(boundary);
                    mainBoundary = boundary;
                end
            end
        end
        
        function complexBoundary = convertBoundaryToComplex(~, boundary)
            % Convert boundary to complex numbers
            complexBoundary = boundary(:, 2) + 1j * boundary(:, 1);
        end
        
        function complexBoundary = transposeComplexBoundary(~, complexBoundary)
            % Transpose the complex boundary
            complexBoundary = complexBoundary';
        end
        
        function descriptor = computeShapeDescriptor(obj, boundary)
            % Compute shape descriptor
            complexBoundary = obj.convertBoundaryToComplex(boundary);
            complexBoundary = obj.transposeComplexBoundary(complexBoundary);
            fourierTransform = obj.computeFourierTransform(complexBoundary);
            fourierTransform = obj.truncateFourierTransform(fourierTransform);
            fourierTransform = obj.normalizeFourierTransform(fourierTransform);
            descriptor = abs(fourierTransform);
        end
        
        function fourierTransform = computeFourierTransform(~, complexBoundary)
            % Compute the Fourier Transform
            fourierTransform = fft(complexBoundary);
        end
        
        function fourierTransform = truncateFourierTransform(~, fourierTransform)
            % Truncate the Fourier Transform
            fourierTransform = fourierTransform(2:25);
        end
        
        function fourierTransform = normalizeFourierTransform(~, fourierTransform)
            % Normalize the Fourier Transform
            fourierTransform = fourierTransform / abs(fourierTransform(1));
        end
        
        function distance = computeDistance(~, descriptor1, descriptor2)
            % Compute the distance between two descriptors
            distance = mean(abs(descriptor1 - descriptor2));
        end
        
        function isSameShape = compareDescriptors(obj, descriptor1, descriptor2)
            % Compare shape descriptors
            threshold = 0.096;
            distance = obj.computeDistance(descriptor1, descriptor2);
            isSameShape = distance < threshold;
        end
        
        function matchedBoundaries = findMatchingBoundaries(obj, testBoundaries)
            % Find matching boundaries
            matchedBoundaries = {};
            for i = 1:length(testBoundaries)
                boundary = testBoundaries{i};
                if size(boundary, 1) > 24
                    testDescriptor = obj.computeShapeDescriptor(boundary);
                    if obj.compareDescriptors(obj.trainDescriptor, testDescriptor)
                        matchedBoundaries{end+1} = boundary;
                    end
                end
            end
        end
        
        function plotBoundaries(~, boundaries, color, lineWidth)
            % Plot boundaries
            hold on;
            for i = 1:length(boundaries)
                boundary = boundaries{i};
                plot(boundary(:, 2), boundary(:, 1), color, 'LineWidth', lineWidth);
            end
            hold off;
        end
    end
end
