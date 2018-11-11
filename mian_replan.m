%蚁群算法三维航迹规划主函数
%考虑了雷达，高度代价
clc;
clear;
tic;
[Hx,Hy,Hz]=peaks(20);
Hz=abs(Hz);%自己把数据改掉   最大值是7.556
figure('name','无人机三维航迹规划')
% mesh(z,'EdgeColor','k');
colormap(gray);
surf(Hz);
hold on;


Height=8; 
Length=20;
Width=20;  %长宽高，表示网格的个数

D=G2D_3d(Height,Length,Width); %得到邻接矩阵
MM=size(D,1);                    
Tau=ones(MM,MM);        % Tau 初始信息素矩阵
Tau=8.*Tau; 
K=50;                             %迭代次数（指蚂蚁出动多少波）
M=20;                              %蚂蚁个数
% S=1 ;                              %最短路径的起始点
% E=1200;                        %最短路径的目的点
Ex=20;
Ey=20;
Ez=Hz(Ex,Ey);
E=coord2num_3d(Ex,Ey,Ez,Length,Width);
Sx=1;
Sy=1;
Sz=Hz(Ex,Ey);
S=coord2num_3d(Sx,Sy,Sz,Length,Width);
%定义威胁源
Thread = thread_3d(Hz+0.5);
nthread=size(Thread,1);
hold on;
scatter3(Thread(:,1),Thread(:,2),Thread(:,3),100,'r','filled');

Alpha=2;                           % Alpha 表征信息素重要程度的参数
Beta=5;                            % Beta 表征启发式因子重要程度的参数
Rho=0.5 ;                          % Rho 信息素蒸发系数
Q=2;                               % Q 信息素增加强度系数 
maxkl=-inf; 
maxk=0; 
maxl=0; 
N=size(D,1);               %N表示问题的规模（象素个数）
a=1;                     %小方格象素的边长
[Ex,Ey,Ez] = coord_3d(E,Length,Width,a);  %计算终止点的坐标
Lta=zeros(N,1);  %路线长度的代价
Tds=zeros(N,1);  %每个点每个点到威胁源的威胁代价，离最近威胁源的距离的倒数
Hcs=zeros(N,1);
Eta=zeros(N,1);             %启发式信息，总的代价
for i=1:N 
     [ix,iy,iz]=coord_3d(i,Length,Width,a);
     if i~=E
        Lta(i)=1/((ix-Ex)^2+(iy-Ey)^2+(iz-Ez)^2)^0.5;  %这里相当于是代价函数，添加威胁元代价和高度代价
     else
         Lta(i)=2;
     end
     Tds(i)=thread_cost(Thread,i,Length,Width,a);
     if iz~=0
        Hcs(i)=1/iz;
     else
         Hcs(i)=2;
     end
     %Eta(i)=0.6*Lta(i)+0.3*Tds(i)+0.1*1/(iz+0.1);  %分别是距离代价，
end 
Lta=(Lta-mean(Lta))/std(Lta);
Tds=(Tds-mean(Tds))/std(Tds);
Hcs=(Hcs-mean(Hcs))/std(Hcs);
%Eta=0.95*Lta+0.06*Tds+0.04*Hcs;
Eta=Lta;
Eta=(Eta-min(Eta))/(max(Eta)-min(Eta));

% Tds=(Tds-min(Tds))/(max(Tds)-min(Tds));
% Lta=(Lta-min(Lta))/(max(Lta)-min(Lta));
% Hcs=(Hcs-min(Hcs))/(max(Hcs)-min(Hcs));

ROUTES=cell(K,M);     %用细胞结构存储每一代的每一只蚂蚁的爬行路线
PL=zeros(K,M);         %用矩阵存储每一代的每一只蚂蚁的爬行路线代价

for k=1:K   %K是迭代的次数
    for m=1:M  %M是蚂蚁的个数
        W=S;                  %当前节点初始化为起始点
        Path=S;                %爬行路线初始化
        PLkm=0;               %爬行路线代价初始化
        TABUkm=ones(N);       %禁忌表初始化，表示的是已经走过的节点
        TABUkm(S)=0;          %已经在初始点了，因此要排除
        DD=D;                 %邻接矩阵初始化
        %下一步可以前往的节点
        DW=DD(W,:); 
        DW1=find(DW);  %DW1是所有非零元素的位置
        
        for j=1:length(DW1)
            if TABUkm(DW1(j))==0  %如果这个点在禁忌表中已经有了
                DW(DW1(j))=0;
            end
                %判断节点高度满足地形的要求
            [x,y,z]=coord_3d(DW1(j),Length,Width,a);

            if z<(Hz(x+0.5,y+0.5)+0.5) %第二个节点选择要满足高度约束
                DW(DW1(j))=0; 
            end
        end
        LJD=find(DW); %可选择的节点
        Len_LJD=length(LJD);%可选节点的个数
        while W~=E&&Len_LJD>=1 
            %转轮赌法选择下一步怎么走
            PP=zeros(Len_LJD); 
            for i=1:Len_LJD 
                PP(i)=(Tau(W,LJD(i))^Alpha)*((Eta(LJD(i)))^Beta); 
            end 
            sumpp=sum(PP); 
            PP=PP/sumpp;%建立概率分布
            Pcum(1)=PP(1); 
            for i=2:Len_LJD 
              Pcum(i)=Pcum(i-1)+PP(i); 
            end 
            Select=find(Pcum>=rand); 
            to_visit=LJD(Select(1)); 
            %状态更新和记录
            Path=[Path,to_visit];                %路径增加
            PLkm=PLkm+Eta(to_visit);    %路径长度增加
            W=to_visit;                   %蚂蚁移到下一个节点
            for kk=1:N 
              if TABUkm(kk)==0 
                 DD(W,kk)=0; 
                 DD(kk,W)=0; 
              end 
            end 
            TABUkm(W)=0;                %已访问过的节点从禁忌表中删除
            DW=DD(W,:); 
            DW1=find(DW); 
            for j=1:length(DW1)     %这已经是从第三个节点开始了。
                if TABUkm(DW1(j))==0 
                   DW(DW1(j))=0; 
                end 
                %判断节点高度满足地形的要求
                [x,y,z]=coord_3d(DW1(j),Length,Width,a);                
                if z<(Hz(x+0.5,y+0.5)+0.5) %考虑到离散化后的误差，留有一定的裕度
                    DW(DW1(j))=0; 
                end
                
                %判断爬升角和偏航角是否满足地形要求
                yaw=climb_yaw_3d(DW1(j),Path,Length,Width,a);
                if yaw<pi/2
                    DW(DW1(j))=0; 
                end
                
            end 
            LJD=find(DW); 
            Len_LJD=length(LJD);%可选节点的个数
        end
         ROUTES{k,m}=Path; 
         if Path(end)==E 
            PL(k,m)=PLkm; 
            if PLkm>maxkl 
                maxk=k;maxl=m;maxkl=PLkm; 
            end 
         else 
            PL(k,m)=0; 
         end    
    end
    %更新信息素
    Delta_Tau=zeros(N,N);%更新量初始化
       for m=1:M 
         if PL(k,m)  
            ROUT=ROUTES{k,m}; 
            TS=length(ROUT)-1;%跳数
             PL_km=PL(k,m); 
            for s=1:TS 
              x=ROUT(s); 
              y=ROUT(s+1); 
              Delta_Tau(x,y)=Delta_Tau(x,y)+Q*PL_km; 
              Delta_Tau(y,x)=Delta_Tau(y,x)+Q*PL_km; 
            end 
         end 
      end 
    Tau=(1-Rho).*Tau+Delta_Tau;%信息素挥发一部分，新增加一部分
end


%绘图


if maxk==0
    print('无法找到满足约束的路径，请重新输入终止点');
    plotif=0;
else
    plotif=1;%是否绘图的控制参数
end
if plotif==1 %绘收敛曲线
    title('航迹规划demo'); 
    xlabel('坐标x'); 
    ylabel('坐标y');
    ROUT=ROUTES{maxk,maxl}; 
    LENROUT=length(ROUT); 
    Rx=ROUT; 
    Ry=ROUT; 
    Rz=ROUT;
    for ii=1:LENROUT 
        [Rx(ii),Ry(ii),Rz(ii)]=coord_3d(ROUT(ii),Length,Width,a);
    end 
    plot3(Rx,Ry,Rz);
    maxPL=zeros(K); 
   for i=1:K 
     PLK=PL(i,:); 
     Nonzero=find(PLK); 
     PLKPLK=PLK(Nonzero); 
     maxPL(i)=min(PLKPLK); 
   end 
   
   figure(2) 
   plot(maxPL); 
   hold on 
   grid on 
   title('收敛曲线变化趋势'); 
   xlabel('迭代次数'); 
   ylabel('最小路径长度'); %绘爬行图
end 
toc;




