function C = GetConnectivity(labelMap)
maxNum=max(labelMap(:));
C=zeros(maxNum,maxNum);
[height width]=size(labelMap);
for i=1:height-1
    for j=1:width-1
        cur=labelMap(i,j);
        if labelMap(i+1,j)~=cur;
            C(cur,labelMap(i+1,j))=1;
            C(labelMap(i+1,j),cur)=1;
        end
        if labelMap(i,j+1)~=cur;
            C(cur,labelMap(i,j+1))=1;
            C(labelMap(i,j+1),cur)=1;
        end 
        if labelMap(i+1,j+1)~=cur;
            C(cur,labelMap(i+1,j+1))=1;
            C(labelMap(i+1,j+1),cur)=1;
        end
    end
end
end
