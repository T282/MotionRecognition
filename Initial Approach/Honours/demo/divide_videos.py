import os
import cv
import cv2


def writeVideoClips(filename):
	cap = cv2.VideoCapture(filename)
	fd = 0
	frames = []
	no_of_frame = 0
	video_no = 1
	video_length = 200
	while(cap.isOpened()):
		ret, frame = cap.read()
		print frame.shape
		if ret==True:
			if len(frames) < video_length:
				frames.append(frame)
			else:
				print len(frames)
				frames.append(frame)
				height , width , layers =  frames[0].shape
				fourcc = cv2.cv.CV_FOURCC(*'XVID') 
				out = cv2.VideoWriter('output'+str(video_no)+'.avi',fourcc, 20, (height,width))
				for x in xrange(0,video_length):
					out.write(frames[x])
				frames = frames[int(video_length/2) + video_length%2:]
				video_no += 1
				out.release()
			if cv2.waitKey(1) & 0xFF == ord('q'):
				break            
		else:
		    break

myPath = "videos_train/"
classes =  next(os.walk(myPath))[1]
i = 0
for oneclass in classes:
	i += 1
	mypath = myPath + oneclass + "/"
	onlyfiles = [f for f in os.listdir(mypath) if os.path.isfile(os.path.join(mypath, f)) and not f.startswith(".")]
	for myfile in onlyfiles:
		filename = mypath + myfile
		writeVideoClips(filename)
		break
	# break
