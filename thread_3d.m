function [Thread] = thread_3d(Hz)
%THREAD_3D 用于定义威胁源的位置，所有威胁源仅仅看做是一个质点
%
%定义威胁源
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

