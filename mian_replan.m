%��Ⱥ�㷨��ά�����滮������
%�������״�߶ȴ���
clc;
clear;
tic;
[Hx,Hy,Hz]=peaks(20);
Hz=abs(Hz);%�Լ������ݸĵ�   ���ֵ��7.556
figure('name','���˻���ά�����滮')
% mesh(z,'EdgeColor','k');
colormap(gray);
surf(Hz);
hold on;


Height=8; 
Length=20;
Width=20;  %�����ߣ���ʾ����ĸ���

D=G2D_3d(Height,Length,Width); %�õ��ڽӾ���
MM=size(D,1);                    
Tau=ones(MM,MM);        % Tau ��ʼ��Ϣ�ؾ���
Tau=8.*Tau; 
K=50;                             %����������ָ���ϳ������ٲ���
M=20;                              %���ϸ���
% S=1 ;                              %���·������ʼ��
% E=1200;                        %���·����Ŀ�ĵ�
Ex=20;
Ey=20;
Ez=Hz(Ex,Ey);
E=coord2num_3d(Ex,Ey,Ez,Length,Width);
Sx=1;
Sy=1;
Sz=Hz(Ex,Ey);
S=coord2num_3d(Sx,Sy,Sz,Length,Width);
%������вԴ
Thread = thread_3d(Hz+0.5);
nthread=size(Thread,1);
hold on;
scatter3(Thread(:,1),Thread(:,2),Thread(:,3),100,'r','filled');

Alpha=1;                           % Alpha ������Ϣ����Ҫ�̶ȵĲ���
Beta=9;                            % Beta ��������ʽ������Ҫ�̶ȵĲ���
Rho=0.6 ;                          % Rho ��Ϣ������ϵ��
Q=2;                               % Q ��Ϣ������ǿ��ϵ�� 
minkl=inf; 
mink=0; 
minl=0; 
N=size(D,1);               %N��ʾ����Ĺ�ģ�����ظ�����
a=1;                     %С�������صı߳�
[Ex,Ey,Ez] = coord_3d(E,Length,Width,a);  %������ֹ�������
Lta=zeros(N,1);  %·�߳��ȵĴ���
Tds=zeros(N,1);  %ÿ����ÿ���㵽��вԴ����в���ۣ��������вԴ�ľ���ĵ���
Hcs=zeros(N,1);
Eta=zeros(N,1);             %����ʽ��Ϣ���ܵĴ���
for i=1:N 
     [ix,iy,iz]=coord_3d(i,Length,Width,a);
     if i~=E
        Lta(i)=1/((ix-Ex)^2+(iy-Ey)^2+(iz-Ez)^2)^0.5;  %�����൱���Ǵ��ۺ�����������вԪ���ۺ͸߶ȴ���
     else
         Lta(i)=2;
     end
     Tds(i)=thread_cost(Thread,i,Length,Width,a);
     if iz~=0
        Hcs(i)=1/iz;
     else
         Hcs(i)=2;
     end
     %Eta(i)=0.6*Lta(i)+0.3*Tds(i)+0.1*1/(iz+0.1);  %�ֱ��Ǿ�����ۣ�
end 
Lta=(Lta-mean(Lta))/std(Lta);
Tds=(Tds-mean(Tds))/std(Tds);
Hcs=(Hcs-mean(Hcs))/std(Hcs);
Eta=0.9*Lta+0.05*Tds+0.05*Hcs;

Eta=(Eta-min(Eta))/(max(Eta)-min(Eta));

% Tds=(Tds-min(Tds))/(max(Tds)-min(Tds));
% Lta=(Lta-min(Lta))/(max(Lta)-min(Lta));
% Hcs=(Hcs-min(Hcs))/(max(Hcs)-min(Hcs));

ROUTES=cell(K,M);     %��ϸ���ṹ�洢ÿһ����ÿһֻ���ϵ�����·��
PL=zeros(K,M);         %�þ���洢ÿһ����ÿһֻ���ϵ�����·�ߴ���

for k=1:K   %K�ǵ����Ĵ���
    for m=1:M  %M�����ϵĸ���
        W=S;                  %��ǰ�ڵ��ʼ��Ϊ��ʼ��
        Path=S;                %����·�߳�ʼ��
        PLkm=0;               %����·�ߴ��۳�ʼ��
        TABUkm=ones(N);       %���ɱ���ʼ������ʾ�����Ѿ��߹��Ľڵ�
        TABUkm(S)=0;          %�Ѿ��ڳ�ʼ���ˣ����Ҫ�ų�
        DD=D;                 %�ڽӾ����ʼ��
        %��һ������ǰ���Ľڵ�
        DW=DD(W,:); 
        DW1=find(DW); 
        
        for j=1:length(DW1)
            if TABUkm(DW1(j))==0  %���������ڽ��ɱ����Ѿ�����
                DW(DW1(j))=0;
            end
                %�жϽڵ�߶�������ε�Ҫ��
            [x,y,z]=coord_3d(DW1(j),Length,Width,a);

            if z<(Hz(x+0.5,y+0.5)+0.5) %�ڶ����ڵ�ѡ��Ҫ����߶�Լ��
                DW(DW1(j))=0; 
            end

        end
        LJD=find(DW); %��ѡ��Ľڵ�
        Len_LJD=length(LJD);%��ѡ�ڵ�ĸ���
        while W~=E&&Len_LJD>=1 
            %ת�ֶķ�ѡ����һ����ô��
            PP=zeros(Len_LJD); 
            for i=1:Len_LJD 
                PP(i)=(Tau(W,LJD(i))^Alpha)*((Eta(LJD(i)))^Beta); 
            end 
            sumpp=sum(PP); 
            PP=PP/sumpp;%�������ʷֲ�
            Pcum(1)=PP(1); 
            for i=2:Len_LJD 
              Pcum(i)=Pcum(i-1)+PP(i); 
            end 
            Select=find(Pcum>=rand); 
            to_visit=LJD(Select(1)); 
            %״̬���ºͼ�¼
            Path=[Path,to_visit];                %·������
            PLkm=PLkm+Eta(to_visit);    %·����������
            W=to_visit;                   %�����Ƶ���һ���ڵ�
            for kk=1:N 
              if TABUkm(kk)==0 
                 DD(W,kk)=0; 
                 DD(kk,W)=0; 
              end 
            end 
            TABUkm(W)=0;                %�ѷ��ʹ��Ľڵ�ӽ��ɱ���ɾ��
            DW=DD(W,:); 
            DW1=find(DW); 
            for j=1:length(DW1)     %���Ѿ��Ǵӵ������ڵ㿪ʼ�ˡ�
                if TABUkm(DW1(j))==0 
                   DW(DW1(j))=0; 
                end 
                %�жϽڵ�߶�������ε�Ҫ��
                [x,y,z]=coord_3d(DW1(j),Length,Width,a);
                
                if z<(Hz(x+0.5,y+0.5)+0.5) %���ǵ���ɢ�����������һ����ԣ��
                    DW(DW1(j))=0; 
                end
                
                %�ж������Ǻ�ƫ�����Ƿ��������Ҫ��
                yaw=climb_yaw_3d(DW1(j),Path,Length,Width,a);
                if yaw<pi/2
                    DW(DW1(j))=0; 
                end
                
            end 
            LJD=find(DW); 
            Len_LJD=length(LJD);%��ѡ�ڵ�ĸ���
        end
         ROUTES{k,m}=Path; 
         if Path(end)==E 
            PL(k,m)=PLkm; 
            if PLkm<minkl 
                mink=k;minl=m;minkl=PLkm; 
            end 
         else 
            PL(k,m)=0; 
         end    
    end
    %������Ϣ��
    Delta_Tau=zeros(N,N);%��������ʼ��
       for m=1:M 
         if PL(k,m)  
            ROUT=ROUTES{k,m}; 
            TS=length(ROUT)-1;%����
             PL_km=PL(k,m); 
            for s=1:TS 
              x=ROUT(s); 
              y=ROUT(s+1); 
              Delta_Tau(x,y)=Delta_Tau(x,y)+Q/PL_km; 
              Delta_Tau(y,x)=Delta_Tau(y,x)+Q/PL_km; 
            end 
         end 
      end 
    Tau=(1-Rho).*Tau+Delta_Tau;%��Ϣ�ػӷ�һ���֣�������һ����
end


%��ͼ


if mink==0
    print('�޷��ҵ�����Լ����·����������������ֹ��');
    plotif=0;
else
    plotif=1;%�Ƿ��ͼ�Ŀ��Ʋ���
end
if plotif==1 %����������
    title('�����滮demo'); 
    xlabel('����x'); 
    ylabel('����y');
    ROUT=ROUTES{mink,minl}; 
    LENROUT=length(ROUT); 
    Rx=ROUT; 
    Ry=ROUT; 
    Rz=ROUT;
    for ii=1:LENROUT 
        [Rx(ii),Ry(ii),Rz(ii)]=coord_3d(ROUT(ii),Length,Width,a);
    end 
    plot3(Rx,Ry,Rz);
    minPL=zeros(K); 
   for i=1:K 
     PLK=PL(i,:); 
     Nonzero=find(PLK); 
     PLKPLK=PLK(Nonzero); 
     minPL(i)=min(PLKPLK); 
   end 
   figure(2) 
   plot(minPL); 
   hold on 
   grid on 
   title('�������߱仯����'); 
   xlabel('��������'); 
   ylabel('��С·������'); %������ͼ
end 
toc;
