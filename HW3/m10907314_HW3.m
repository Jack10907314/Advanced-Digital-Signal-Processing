function m10907314_HW3(path_of_image)
    
    if nargin<1
       RGB = imread('fireworks.jpg');
    else
       RGB = imread(path_of_image);
    end
    RGB_to_YCbCr = [0.299 0.587 0.114;-0.169 -0.331 0.500;0.500 -0.419 -0.081];
    YCbCr_to_RGB = inv(RGB_to_YCbCr);
    image(RGB)
    title('RGB')
    
    [m,n,d] = size(RGB);
    RGB_transpose = double(permute(RGB, [3 2 1]));
    RGB_transform = reshape(RGB_transpose, 3, []);
    YCbCr_transform = RGB_to_YCbCr*RGB_transform;
    YCbCr = reshape(YCbCr_transform, d, n, m);

    Y = YCbCr(1,:,:);
    Cb = YCbCr(2,:,:);
    Cr = YCbCr(3,:,:);

    Cb_reduce = Cb(:,1:2:n,1:2:m);
    Cr_reduce = Cr(:,1:2:n,1:2:m);

    Cb_reconstruct = zeros(1,n,m);
    Cr_reconstruct = zeros(1,n,m);

    n_index = 1:1:n;
    n_index_resize = 1:2:n;
    m_index = 1:1:m;
    m_index_resize = 1:2:m;

    Cb_reconstruct(1,n_index_resize,m_index_resize) = Cb_reduce;
    Cr_reconstruct(1,n_index_resize,m_index_resize) = Cr_reduce;
    for i=1:m/2
        Cb_reconstruct(1,:,m_index_resize(i)) = interp1(n_index_resize,Cb_reconstruct(1,n_index_resize,m_index_resize(i)),n_index);
        Cr_reconstruct(1,:,m_index_resize(i)) = interp1(n_index_resize,Cr_reconstruct(1,n_index_resize,m_index_resize(i)),n_index);
    end
    for i=1:n
        Cb_reconstruct(1,i,:) = interp1(m_index_resize,squeeze(Cb_reconstruct(1,i,m_index_resize)),m_index);
        Cr_reconstruct(1,i,:) = interp1(m_index_resize,squeeze(Cr_reconstruct(1,i,m_index_resize)),m_index);
    end
    Cb_reconstruct(1,n,:) = Cb_reconstruct(1,n-1,:);
    Cb_reconstruct(1,:,m) = Cb_reconstruct(1,:,m-1);
    Cr_reconstruct(1,n,:) = Cr_reconstruct(1,n-1,:);
    Cr_reconstruct(1,:,m) = Cr_reconstruct(1,:,m-1);

    YCbCr_reconstruct = [Y;Cb_reconstruct;Cr_reconstruct];
    YCbCr_reconstruct_transform = reshape(YCbCr_reconstruct, 3, []);
    RGB_reconstruct_transform = YCbCr_to_RGB*YCbCr_reconstruct_transform;
    RGB_reconstruct_transpose = reshape(RGB_reconstruct_transform, 3, n, m);
    RGB_reconstruct = uint8(permute(RGB_reconstruct_transpose, [3 2 1]));
    figure;
    image(RGB_reconstruct)
    title('RGB reconstruct')
    
    MAX = 255;
    MES = sum(sum(sum((RGB_reconstruct-RGB).^2)))/(m*n*3);
    PSNR = 10*log10(MAX*MAX / MES)
end