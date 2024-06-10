function ExerciseFourTaskB

% Create an instance of ShapeDetector
detector = ShapeDetector('trainB.png', 0.1);

% Detect shapes in test images
testImagePaths = {'test1B.jpg', 'test2B.jpg', 'test3B.jpg'};
testThresholds = [0.22, 0.28, 0.28];
matchedBoundaries = detector.detectShapes(testImagePaths, testThresholds);

% Display the results
detector.displayResults(testImagePaths, matchedBoundaries);

end 