function ssim = SSIM(A, B, c1, c2)
    if nargin<1
        A = imread('picture1.PNG');
        A = rgb2gray(A);
        B = imread('picture2.PNG');
        B = rgb2gray(B);
        c1 = 1 / sqrt(255);
        c2 = 1 / sqrt(255);
    end
    
    A = double(A);
    B = double(B);
    L = 255;

    [M, N] = size(A);
    mean_A = mean(mean(A));
    mean_B = mean(mean(B));
    variance_A = sum(sum((A-mean_A).^2)) / (M*N);
    variance_B = sum(sum((B-mean_B).^2)) / (M*N);
    covariance_AB = sum(sum((A-mean_A).*(B-mean_B))) / (M*N);

    ssim = (2*mean_A*mean_B + (c1*L)^2) / (mean_A^2 + mean_B^2 + (c1*L)^2) * (2*covariance_AB + (c2*L)^2) / (variance_A + variance_B + (c2*L)^2);
end