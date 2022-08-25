[A,B] = meshgrid(2:0.1:18,-10:0.1:0.5);
Acol = reshape(A,numel(A),1);
Bcol = reshape(B,numel(B),1);
figure
hold on
surf(A,B,reshape(((abs(((Mxi(Acol',Bcol')-Mxbg(Acol',Bcol')).^2+(Mzi(Acol',Bcol')-Mzbg(Acol',Bcol')).^2).^0.5./((Mxbg(Acol',Bcol')).^2+(Mzbg(Acol',Bcol')).^2).^0.5)))/log(10),size(A)),'lineStyle','none')
colorbar