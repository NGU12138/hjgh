function [Ex,Ey,Ez] = coord_3d(E,length,width,a)
%COORD_3D ��������
%   �˴���ʾ��ϸ˵��
Ez=a*floor((E-1)/(length*width));%  ��ֹ���z����

after_z=mod(E,length*width); %����Ϳ��Լ���z,y������

Ex=a*(mod(after_z,length)-0.5);    %��ֹ�������
if Ex==-0.5 
    Ex=a*(length-0.5); 
end 
Ey=a*(ceil(after_z/length)-0.5); %��ֹ��������
if Ey==-0.5 
    Ey=a*(width-0.5); 
end 
end

