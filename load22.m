h = 0.497621;
lw = 4.562213;
t = -0.002;
flsd = 0.01;
over = false;
wrinkle = false;
w = h/lw;
p = evalfis([flsd,t,w],pressure);
a = evalfis([w,t,flsd],axial_feed);
if over && p > 0
    p = log(p);
end
if wrinkle 
    a = log(a);
end