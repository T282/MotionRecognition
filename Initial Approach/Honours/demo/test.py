import cv
import cv2

capture = cv.CaptureFromFile("videos_train/brush_hair/April_09_brush_hair_u_nm_np1_ba_goo_0.avi")
if capture != None:
    # Need a frame to get the output video dimensions
    frame = cv.RetrieveFrame(capture) # Will return None if there are no frames
    # New video file
    fourcc = cv2.cv.CV_FOURCC(*'XVID') 
    video_out = cv.CreateVideoWriter("testing.mpeg", fourcc, 20, frame.shape, 1)
    # Write the frames
    cv.WriteFrame(video_out, frame)
    while 1:
        frame = cv.RetrieveFrame(capture) # Will return None if there are no frames
        if frame != None:
        	cv.WriteFrame(video_out, frame)
        else:
        	break