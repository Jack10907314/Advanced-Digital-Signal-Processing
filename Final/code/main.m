t1 = [0];
t2 = [0];
t3 = [0];
Point = [0];
for i = 1:10
    Camera = 200;
    MapPoint = 200*(i-1);
    [H g B C E v w] = CreateMatrix(Camera, MapPoint, 0);
    [delta_xc1 delta_xp1 time1] = DirectCompute(Camera, MapPoint, H, g);
    [delta_xc2 delta_xp2 time2] = FastCompute(Camera, MapPoint, B, C, E, v, w);
    [delta_xc3 delta_xp3 time3] = CholeskyCompute(Camera, MapPoint, B, C, E, v, w);
    t1 = [t1 time1];
    t2 = [t2 time2];
    t3 = [t3 time3];
    Point = [Point MapPoint];
end
figure;
hold on;
plot(Point, t1, 'r');
plot(Point, t2, 'm');
plot(Point, t3, 'b');
xlabel('map point');
ylabel('time(second)');
legend('directly inverse','Schur','Schur and cholesky');


t1 = [0];
t2 = [0];
t3 = [0];
camera = [0];
for i = 1:10
    Camera = 300*i;
    MapPoint = 1000;
    [H g B C E v w] = CreateMatrix(Camera, MapPoint, 0);
    [delta_xc1 delta_xp1 time1] = DirectCompute(Camera, MapPoint, H, g);
    [delta_xc2 delta_xp2 time2] = FastCompute(Camera, MapPoint, B, C, E, v, w);
    [delta_xc3 delta_xp3 time3] = CholeskyCompute(Camera, MapPoint, B, C, E, v, w);
    t1 = [t1 time1];
    t2 = [t2 time2];
    t3 = [t3 time3];
    camera = [camera Camera];
end
figure;
hold on;
plot(camera, t1, 'r');
plot(camera, t2, 'm');
plot(camera, t3, 'b');
xlabel('camera');
ylabel('time(second)');
legend('directly inverse','Schur','Schur and cholesky');
