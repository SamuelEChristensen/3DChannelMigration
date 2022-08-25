sizeSTR = {'background stream line','10um','15um', '20um'};
N = numel(sizeSTR);
%copy and pasting is fastest because comsol sucks
%define Migs3 as the migration velocity before using this
icx = -5;
icz = 10;
figure
hold on
trajs = cell(N,1);
opts = odeset('RelTol',1e-8,'AbsTol',1e-8); %kinda overkill but needed for pretty limit cycles
for i = 3
    Mxi = scatteredInterpolant(Migs3(:,2),Migs3(:,1),Migs3(:,2*i+1),'natural');
    Mzi = scatteredInterpolant(Migs3(:,2),Migs3(:,1),Migs3(:,2*i+2),'natural');
    odeMigi = @(t,X) [Mzi(X(1,:),X(2,:));Mxi(X(1,:),X(2,:))];
    Xend = icx;
    Zend = icz;
    count = 10;
   while Xend<1 && Xend>-20 && Zend>0 && Zend <20 && count < 15  
       ystore = Yi;
       [T,Yi] = ode23s(odeMigi,[0,1.15^count*2048],[icz;icx],opts);
       Xend = Yi(end,2);
       Zend = Yi(end,1);
       count = count+1;
   end
   migNorm = ((Mxi(ystore(end/2:end,1)',ystore(end/2:end,2)')-Mxbg(ystore(end/2:end,1)',ystore(end/2:end,2)')).^2+(Mzi(ystore(end/2:end,1)',ystore(end/2:end,2)')-Mzbg(ystore(end/2:end,1)',ystore(end/2:end,2)')).^2).^0.5;
   migxValue = Mxi(ystore(end/2:end,1)',ystore(end/2:end,2)')-Mxbg(ystore(end/2:end,1)',ystore(end/2:end,2)');
   advecNorm = ((Mxbg(ystore(end/2:end,1)',ystore(end/2:end,2)')).^2+(Mzbg(ystore(end/2:end,1)',ystore(end/2:end,2)')).^2).^0.5;
   x = ystore(end/2:end,1)';
y = ystore(end/2:end,2)'; z = 0*ystore(end/2:end,1)';
col = migxValue./advecNorm;  % This is the color, vary with x in this case.
surface([x;x],[y;y],[z;z],[col;col],...
'facecol','no',...
'edgecol','interp',...
'linew',3);
   trajs{i} = ystore;
end
colorbar
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
fill(pvFront(:,1),pvFront(:,3),'r','faceColor','none','lineWidth',2.5)
