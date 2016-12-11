x = 0:.1:1;
A = [x; exp(x)];

fileID = fopen('exp.txt','w');
a = 'test';
fprintf(fileID,'%s',a);
fclose(fileID);