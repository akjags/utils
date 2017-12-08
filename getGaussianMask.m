% getGaussianMask(center, width, maskSize)
%
%   Generates a 2D gaussian
%
%   Inputs:
%     - maskSize: Size of the image e.g. [100, 100]
%     - center: center of the gaussian
%     - width: width of the gaussian
%
function mask = getGaussianMask(center, width, maskSize)
x = center(1); y = center(2);

[X,Y] = meshgrid(1:maskSize(1), 1:maskSize(2));
Z = mvnpdf([X(:) Y(:)], center, [width 0; 0 width]);
Z = reshape(Z, length(Y), length(X));
mask = Z.* (1 / max(Z(:)));

