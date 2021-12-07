function [H, g, B, C, E, v, w] = CreateMatrix(Camera, MapPoint, mask_probability)
%     Camera = 5;
%     MapPoint = 10;
%     mask_probability = 0.8;

    B = eye(Camera).*rand(Camera,Camera);
    C = eye(MapPoint).*rand(MapPoint,MapPoint);;
    E = rand(Camera,MapPoint);
    mask = rand(Camera,MapPoint);
    E = E.*(mask > (1-mask_probability));
    ET = E';
    v = rand(Camera, 1);
    w = rand(MapPoint, 1);
    H = [B E;ET C];
    g = [v;w];
end