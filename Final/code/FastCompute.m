function [delta_xc delta_xp time] = FastCompute(Camera, MapPoint, B, C, E, v, w)
    timer1=tic;
    %C inverse
    C_inv = C;
    for i = 1:MapPoint
        C_inv(i,i) = 1/C_inv(i,i);
    end

    %Marginalization
    H11 = B-E*C_inv*E';
    H12 = zeros(Camera, MapPoint);
    H21 = E';
    H22 = C;
    g11 = v-E*C_inv*w;
    g21 = w;

    % H_margin = [B-E*C_inv*E' zeros(Camera, MapPoint);E' C];
    % g_margin = [v-E*C_inv*w;w];
%     H11 = roundn(H11,-4);
%     u=chol(H11);
%     tu=u/u(end,end);
%     H11_inv=tu*tu';
%     delta_xc = H11_inv*g11;
    delta_xc = inv(H11)*g11;
    delta_xp = C_inv*(g21-H21*delta_xc);
    time = toc(timer1);
end