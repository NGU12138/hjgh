clear;clc;
[x,y,z]=peaks(20);
z=abs(z);%�Լ������ݸĵ�
figure('name','ԭʼͼ')
% mesh(z,'EdgeColor','k');

colormap(gray);
surf(z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','Ⱦɫͼ');
map=colormap;
userdefcolor=[.5 .5 .5];%��������Ⱦ�������ɫ��50%�ң���������Լ���
c=round((z-min(z(:)))/(max(z(:))-min(z(:)))*(size(map,1)-1))+1;
c(z>3&x>-2&x<0&y>0&y<2)=size(map,1)+1;%����߶ȴ���3����x��[-2,0]��y��[0,2]������Ⱦɫ
map=[map;userdefcolor];
colormap(map);
surf(x,y,z,c,'CDataMapping','direct');