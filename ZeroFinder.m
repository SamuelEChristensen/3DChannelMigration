test = readtable('unsteadyStressletTest.txt');
test = (table2array(test));
signChange =(sign([test(:,1);0]) - (sign([0;test(:,1)])));
ind = find((signChange == 2)+([test(:,1);10]<0.1)==2);
plot(test(ind,1))
ind = ind(1:2:numel(ind));
x1 = test(ind,1);
fx1 = test(ind,2);
x2 = test(ind-1,1);
fx2 = test(ind-1,2);
ystar = fx1-x1.*(fx2-fx1)./(x2-x1);
plot(ystar)