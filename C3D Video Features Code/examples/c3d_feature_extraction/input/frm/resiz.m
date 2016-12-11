names1 = dir('v_ApplyEyeMakeup_g01_c01/');
names2 = dir('v_BaseballPitch_g01_c01/');
for i=3:length(names2)
    I = imread(strcat('v_BaseballPitch_g01_c01/',names2(i).name));
    I = imresize(I,0.1);
    imwrite(I,names2(i).name);
end