clear;clc;
[x,y,z]=peaks(20);
z=abs(z);%自己把数据改掉
figure('name','原始图')
% mesh(z,'EdgeColor','k');

colormap(gray);
surf(z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','染色图');
map=colormap;
userdefcolor=[.5 .5 .5];%假设你想染成这个颜色（50%灰），你可以自己改
c=round((z-min(z(:)))/(max(z(:))-min(z(:)))*(size(map,1)-1))+1;
c(z>3&x>-2&x<0&y>0&y<2)=size(map,1)+1;%假设高度大于3并且x∈[-2,0]，y∈[0,2]的区域染色
map=[map;userdefcolor];
colormap(map);
surf(x,y,z,c,'CDataMapping','direct');