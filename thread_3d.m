function [Thread] = thread_3d(Hz)
%THREAD_3D ���ڶ�����вԴ��λ�ã�������вԴ����������һ���ʵ�
%
%������вԴ
thread=[16,18;
        10,10;
        5,5;];
nthread=size(thread,1);
for i=1:nthread
    z=Hz(thread(i,1),thread(i,2));
    x=thread(i,1)-0.5;
    y=thread(i,2)-0.5;
    Thread(i,:)=[x,y,z];
end

end

