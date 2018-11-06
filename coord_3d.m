function [Ex,Ey,Ez] = coord_3d(E,length,width,a)
%COORD_3D 计算坐标
%   此处显示详细说明
Ez=a*floor((E-1)/(length*width));%  终止点的z坐标

after_z=mod(E,length*width); %下面就可以计算z,y坐标了

Ex=a*(mod(after_z,length)-0.5);    %终止点横坐标
if Ex==-0.5 
    Ex=a*(length-0.5); 
end 
Ey=a*(ceil(after_z/length)-0.5); %终止点纵坐标
if Ey==-0.5 
    Ey=a*(width-0.5); 
end 
end

