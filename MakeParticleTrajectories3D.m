sizeSTR = {'background stream line','10um','15um','20um'};
N = numel(sizeSTR);
%copy and pasting is fastest because comsol sucks
%define Migs3D as the migration velocity before using this
icx = -3;
icy = 0.25;
icz = 4;
figure
hold on
trajs = cell(N,1);
opts = odeset('RelTol',1e-8,'AbsTol',1e-8);
Yi = [icz,icy,icx];
for i =1:N
    Mxi = scatteredInterpolant(Migs3D(:,2),Migs3D(:,3),Migs3D(:,1),Migs3D(:,3*i+1),'linear');
    Myi = scatteredInterpolant(Migs3D(:,2),Migs3D(:,3),Migs3D(:,1),Migs3D(:,3*i+2),'linear');
    Mzi = scatteredInterpolant(Migs3D(:,2),Migs3D(:,3),Migs3D(:,1),Migs3D(:,3*i+3),'linear');
    odeMigi = @(t,X) [Mzi(X(1,:),X(2,:),X(3,:)); Myi(X(1,:),X(2,:),X(3,:)); Mxi(X(1,:),X(2,:),X(3,:))];
    Xend = icx;
    Yend = icy;
    Zend = icz;
    count = 0;
   while Xend<1 && Xend>-20 && abs(Yend)<1 && Zend>0 && Zend <20 && count < 30  
       ystore = Yi;
       [T,Yi] = ode45(odeMigi,[0,1.2^count*50],[icz;icy;icx],opts);
       Xend = Yi(end,3);
       Yend = Yi(end,2);
       Zend = Yi(end,1);
       count = count+1;
   end
   
   plot3(ystore(1:end,1),ystore(1:end,2),ystore(1:end,3))
   trajs{i} = ystore;
end
legend(sizeSTR)
axis image

%scatter3(Migs3D(:,2),Migs3D(:,3),Migs3D(:,1))
%this part is ugly, sue me
CD = 20; %cavity depth
AR = 1;
pvFront =  [-6  7/8   0
0 7/8  0
0 7/8 -CD
CD*AR+0   7/8  -CD
CD*AR+0  7/8  0
35  7/8   0
35  7/8  1
-6   7/8  1  ];
fill3(pvFront(:,1),pvFront(:,2),pvFront(:,3),'r','faceColor','none')

pvBack =  [-6  -7/8   0
0 -7/8  0
0 -7/8 -CD
CD*AR+0   -7/8  -CD
CD*AR+0  -7/8  0
35  -7/8   0
35  -7/8  1
-6   -7/8  1  ];
fill3(pvBack(:,1),pvBack(:,2),pvBack(:,3),'r','faceColor','none')


pvIn = [-6  -7/8  1
    -6   7/8   1
    -6  7/8   0
    -6   -7/8  0];
fill3(pvIn(:,1),pvIn(:,2),pvIn(:,3),'r','faceColor','none')


pvOut = [35  -7/8  1
    35   7/8   1
    35   7/8   0
    35   -7/8  0];
fill3(pvOut(:,1),pvOut(:,2),pvOut(:,3),'r','faceColor','none')
pv1 = [0  -7/8  0
    0   7/8   0
    0  7/8   -CD
    0   -7/8  -CD];
fill3(pv1(:,1),pv1(:,2),pv1(:,3),'r','faceColor','none')

pv2 = [0+AR*CD  -7/8  0
    0+AR*CD   7/8   0
    0+AR*CD  7/8   -CD
    0+AR*CD   -7/8  -CD];
fill3(pv2(:,1),pv2(:,2),pv2(:,3),'r','faceColor','none')
view(56,15)