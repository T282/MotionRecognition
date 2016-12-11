fi = open('brush_hair','r');
re = fi.read();
i = 0;
nuu = 1;
while 1:
	j = i;
	while 1:
		i+=1;
		if re[i]==' ':
			break;
	st = re[j:i];
	i+=1;
	j = i;
	while re[i]!='\n' and re[i]!='':
		i+=1;
	nu = re[j:i];
	nu = int(nu);
	k = 0;
	file_no = '';
	t1 = 0;
	while t1<3-len(str(nuu)):
		file_no += '0';
		t1+=1;
	t2 = 0;
	nu_stri = str(nuu);
	while t2<len(nu_stri):
		file_no += nu_stri[t2];
		t2+=1;
	print file_no
	wr1 = open('../inp/brush_hair/input_brush_hair_'+file_no,'w');
	wr2 = open('../out/brush_hair/output_brush_hair_'+file_no,'w');
	while k+16<nu-3:
		wr1.write(st);
		wr1.write(' ');
		wr1.write(str(k));
		wr1.write(' 0\n');
		wr2.write('output/c3d/');
		wr2.write(st[10:-4]);
		wr2.write('/');
		out_no = '';
		j1 = 0;
		out_no_1 = str(k);
		while j1<6-len(out_no_1):
			out_no += '0';
			j1+=1;
		j2 = 0;
		while j2<len(out_no_1):
			out_no += out_no_1[j2];
			j2+=1;
		wr2.write(out_no);
		wr2.write('\n');
		k+=10;
	wr1.close();
	wr2.close();
	i+=1
	nuu+=1;
	if i>=len(re):
		break;
