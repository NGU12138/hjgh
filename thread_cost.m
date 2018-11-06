function [maxcost] = thread_cost(Thread,i,Length,Width,a)
%THREAD_COST 此处显示有关此函数的摘要
%   此处显示详细说明
nthread=size(Thread,1);
maxcost=-inf;
for k=1:nthread
    tx=Thread(k,1);ty=Thread(k,2);tz=Thread(k,3);
    num=coord2num_3d(tx,ty,tz,Length,Width);
    if i==num
        Cost=1;
    else
        [x,y,z]=coord_3d(i,Length,Width,a);
        Cost=0.001*((x-tx)^2+(y-ty)^2+(z-tz)^2);
    end
    if Cost>maxcost
        maxcost=Cost;
    end
    
end
end

