import os
t_file = open('t','r');
t = t_file.read();
t_file.close();
t = int(t);
while t<=51:
	all_cla = open('all_cla','r');
	for te in range(0,t):
		class_name = all_cla.readline();
	class_name = class_name[0:-1];
	all_cla.close();
	i_file = open('i','r');
	i = i_file.read();
	i = int(i);
	i_file.close();
	fi = open('video_names/'+class_name,'r');
	lin = fi.readline();
	num_videos = 0;
	while lin:	#counting the number of videos in that class
		lin = fi.readline();
		num_videos+=1;
	fi.close();
	fi = open('video_names/'+class_name,'r');
	re = fi.read();	#string which contain all the videos of that file
	while i<=num_videos:
		j_file = open('j','r');
		j = j_file.read();
		j = int(j);
		j_file.close();
		k = j;
		while re[j]!='\n' and re[j]!='':
			j+=1;
		st = 'mkdir -p output/c3d/'+re[k:j-4];	#creating the output folder for that video
		nu = '';
		l1 = 0;
		while l1<3-len(str(i)):
			nu+='0';
			l1+=1;
		l2 = 0;
		nu_s = str(i);
		while l2<len(nu_s):
			nu+=nu_s[l2];
			l2+=1;
		os.system(st);
		os.system('cp prototxt/inp/'+class_name+'/input_'+class_name+'_'+nu+' prototxt/input_list_video.txt');
		os.system('cp prototxt/out/'+class_name+'/output_'+class_name+'_'+nu+' prototxt/output_list_video_prefix.txt');
		os.system('GLOG_logtosterr=1 ../../build/tools/extract_image_features.bin prototxt/c3d_sport1m_feature_extractor_video.prototxt conv3d_deepnetA_sport1m_iter_1900000 -1 50 1 prototxt/output_list_video_prefix.txt fc7-1 fc6-1 prob');
		j+=1;
		i+=1;
		i_file = open('i','w');
		i_file.write(str(i));
		i_file.close();
		j_file = open('j','w');
		j_file.write(str(j));
		j_file.close();
		os.system('cd ~/C3D/examples/c3d_feature_extraction');
		print i
		print t;
	os.system('mkdir output/'+class_name);
	os.system('cp output/c3d/* output/'+class_name+'/');
	os.system('rm -rf output/c3d/*');
	i_file = open('i','w');
	i_file.write('1');
	i_file.close();
	j_file = open('j','w');
	j_file.write('0');
	j_file.close();
	t+=1;
	t_file = open('t','w');
	t_file.write(str(t));
	t_file.close();
