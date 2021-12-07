function [delta_xc delta_xp time] = DirectCompute(Camera, MapPoint, H, g)
    timer1=tic;
    V = inv(H)*g;
    delta_xc = V(1:Camera);
    delta_xp = V(Camera+1:end);
    time = toc(timer1);
end