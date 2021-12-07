function [delta_xc delta_xp time] = SVDcompute(Camera, MapPoint, H, g)
    timer1=tic;
    A = [H -g];
    [U,S,V] = svd(A);
    V(:,end) = V(:,end) / V(end, end);
    delta_xc = V(1:Camera, end);
    delta_xp = V(Camera+1:end-1, end);
    time = toc(timer1);
end