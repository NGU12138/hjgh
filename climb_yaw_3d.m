function [yaw] = climb_yaw_3d(next,path,length,width,a)
%CLIMB_YAW_3D 此处显示有关此函数的摘要
%   此处显示详细说明
n=size(path,2);
if(n<2)
    print('路径还不足两个节点')
    return
end

[prex,prey,prez]=coord_3d(path(n-1),length,width,a);
[nowx,nowy,nowz]=coord_3d(path(n),length,width,a);
[nextx,nexty,nextz]=coord_3d(next,length,width,a);

ax=nowx-prex;ay=nowy-prey;az=nowz-prez;
bx=nowx-nextx;by=nowy-nexty;bz=nowz-nextz;

a=[ax,ay,az];
b=[bx,by,bz];

yaw=acos(dot(a,b)/(norm(a)*norm(b)));  %求偏航角，最后结果是弧度

% a=[ax,az];
% b=[bx,bz];
% 
% climb=acos(dot(a,b)/(norm(a)*norm(b)));  %求偏航角，最后结果是弧度


end

