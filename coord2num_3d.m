function [num] = coord2num_3d(Ex,Ey,Ez,Length,Width)
%COORD2NUM_3D �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x=ceil(Ex);y=ceil(Ey);z=ceil(Ez);
num=z*Length*Width+(y-1)*Length+x;
end

