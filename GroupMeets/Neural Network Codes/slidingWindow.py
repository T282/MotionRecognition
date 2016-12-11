__author__ = 'saisagarjinka'

import imutils
import cv2


def pyramid(image, scale=1.5, min_size=(30, 30)):
    #yield image
    x = []

    while True:
        w = int(image.shape[1] / scale)
        image = imutils.resize(image, width=w)

        if image.shape[0] < min_size[1] or image.shape[1] < min_size[0]:
            break
        x.append(image)
        #yield image
    return x


'''
def sliding_window(image, stepSize, windowSize):
    images = []
    # slide a window across the image
    for y in xrange(0, image.shape[0], stepSize):
        for x in xrange(0, image.shape[1], stepSize):
            # yield the current window
            images.append((image[y:y + windowSize[1], x:x + windowSize[0]],(x,y)))
    return images
'''


def sliding_window(image, stepSize, windowSize):
    list_images = []
    for y in xrange(0, image.shape[0], stepSize):
        for x in xrange(0, image.shape[1], stepSize):
            list_images.append((x, y, image[y:y + windowSize[1], x:x + windowSize[0]]))
    return list_images


image = cv2.imread('/Users/saisagarjinka/Downloads/Datasets/ICDAR2015/Ground_2015/img_165.jpg')
print image.shape

(winW, winH) = (500, 500)
im = pyramid(image, scale=2)
'''
for i in range(im.__len__()):
    cv2.imshow("p",im[i])
    cv2.waitKey(-1)
print pyramid(image, scale=1.5).__len__()
'''
images = sliding_window(image, stepSize=150, windowSize=(winW, winH))
#for resized in pyramid(image, scale=1.5):
for z in images:
        (x, y, window) = z
        if window.shape[0] != winH or window.shape[1] != winW:
            continue
        clone = image.copy()
        cv2.rectangle(clone, (x, y), (x + winW, y + winH), (0, 255, 0), 2)
        d = image[x:x+winW, y:y+winW]
        cv2.imshow("Window", window)
        cv2.waitKey(-1)
