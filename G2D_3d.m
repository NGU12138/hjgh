function D=G2D_3d(Height,length,width)
%��ʾ��ά���ڽӾ������ȡ
%��ͼ��һ����׼��20*20*10��������
%�������ϰ���

% 
% Height=10;
% length=20;
% width=20;  %����ߣ���ʾ����ĸ���

MM=Height*length*width;

D=zeros(MM,MM);
for k=1:Height
    for j=1:width
        for i=1:length
            for m=1:Height
               for n=1:width
                   for p=1:length
                       km=abs(k-m);jn=abs(j-n);ip=abs(i-p);
                       if km+jn+ip==1||((km+jn+ip==2)&&km*jn*ip==0&&max([km,jn,ip])==1)||(km==1&&jn==1&&ip==1)
                           D((k-1)*length*width+(j-1)*width+i,(m-1)*length*width+(n-1)*width+p)=(km+jn+ip)^0.5;         
                       end
                   end
               end
            end
        end
    end
end
end


