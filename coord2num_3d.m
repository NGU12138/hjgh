function [num] = coord2num_3d(Ex,Ey,Ez,Length,Width)
%COORD2NUM_3D 此处显示有关此函数的摘要
%   此处显示详细说明
x=ceil(Ex);y=ceil(Ey);z=ceil(Ez);
num=z*Length*Width+(y-1)*Length+x;
end

