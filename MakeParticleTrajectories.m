sizeSTR = {'background stream line','10um','15um', '20um'};
N = numel(sizeSTR);
%copy and pasting is fastest because comsol sucks
%define Migs3 as the migration velocity before using this
icx = -2;
icy = 0.05;
icz = 3;
figure
hold on
trajs = cell(N,1);
opts = odeset('RelTol',1e-8,'AbsTol',1e-8);
for i =1:N
    Mxi = scatteredInterpolant(Migs3(:,2),Migs3(:,1),Migs3(:,2*i+1),'natural');
    Mzi = scatteredInterpolant(Migs3(:,2),Migs3(:,1),Migs3(:,2*i+2),'natural');
    odeMigi = @(t,X) [Mzi(X(1,:),X(2,:));Mxi(X(1,:),X(2,:))];
    Xend = icx;
    Zend = icz;
    count = 0;
   while Xend<1 && Xend>-20 && Zend>0 && Zend <20 && count < 35  
       ystore = Yi;
       [T,Yi] = ode45(odeMigi,[0,1.15^count*2048],[icz;icx]);
       Xend = Yi(end,2);
       Zend = Yi(end,1);
       count = count+1;
   end
   
   plot3(ystore(end/2:end,1),0*ystore(end/2:end,1),ystore(end/2:end,2))
   trajs{i} = ystore;
end
legend(sizeSTR)
axis image


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