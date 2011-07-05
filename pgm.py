#!/usr/bin/python
from struct import *
import math
import copy

class PGM:
    "PGM image file class"
    def __init__(self):
        self.data = []

    def read(self,filename):
        try:
            print "reading %(filename)s" %locals()
            f = open(filename, "rb")
            #read head
            self.magicnumber = f.readline()
            self.width_height = f.readline()
            [self.width,self.height] = self.width_height.rsplit(' ')
            self.range = f.readline()
                        
            while 1 :
                line = f.readline()
                if line == "":
                    break
                line = line.rsplit(' ')
                line.pop()
                for element in line:
                    self.data.append(element)
            print "Done"
            
        except:
            print "Error in reading"
            exit

    def write(self,filename):
        try:
            print "writting %(filename)s" %locals()
            f = open(filename,"wb")

            #write header
            f.write(self.magicnumber)
            f.write("%(a)s %(b)s" %{'a':self.width,'b':self.height})
            f.write(self.range)

            for i in range(int(self.height)*int(self.width)):
                f.write(self.data[i])
                f.write(' ')
                if(i%int(self.width) == 0):
                    f.write('\n')
            print "Done"
        except:
           print "Error in writting"
           exit


def nuritubushi(ipgm):
    rpgm = ipgm
    for i in range(int(ipgm.height)*int(ipgm.width)):
        rpgm.data[i] = str(0)
    return rpgm

def edge(ipgm):
    #sobel filter
    rpgm = copy.deepcopy(ipgm)

    for i in range(int(ipgm.height)*int(ipgm.width)):
        height = i / int(ipgm.width)
        width = i % int(ipgm.width)
        #hx = higher,mx = middle,lx =lower
        #xl = left, xc = center, xr = right
        #ex) hc = higher center
        if height <= 0:
            hl = 0
            hc = 0
            hr = 0
        else:
            if width <= 0:
                hl = 0
            else:
                hl = ipgm.data[(height -1)*int(ipgm.width) + width-1]

            hc = ipgm.data[(height -1)*int(ipgm.width) + width]

            if width >= int(ipgm.width)-1:
                hr = 0
            else:
                hr = ipgm.data[(height -1)*int(ipgm.width) + width+1]

        if width <= 0:
            ml = 0
        else:
            ml = ipgm.data[(height)*int(ipgm.width) + width-1]

        mc = 0

        if width >= int(ipgm.width)-1:
            mr = 0
        else:
            mr = ipgm.data[height*int(ipgm.width) + width+1]

        if height >= int(ipgm.height)-1:
            ll = 0
            lc = 0
            lr = 0
        else:
            if width <= 0:
                ll = 0
            else:
                ll = ipgm.data[(height +1)*int(ipgm.width) + width-1]

            lc = ipgm.data[(height +1)*int(ipgm.width) + width]

            if width >= int(ipgm.width)-1:
                lr = 0
            else:
                lr = ipgm.data[(height +1)*int(ipgm.width) + width+1]

        hl = int(hl);hc = int(hc);hr = int(hr);
        ml = int(ml);mr = int(mr)
        ll = int(ll);lc = int(lc);lr = int(lr);

        ghs = (hl*-1)+(hc*0)+(hr*1)+(ml*-2)+(mc*0)+(mr*2)+(ll*-1)+(lc*0)+(lr*1)
        gvs = (hl*-1)+(hc*-2)+(hr*-1)+(ml*0)+(mc*0)+(mr*0)+(ll*1)+(lc*2)+(lr*1)
        #print [[height,width],hl,hc,hr,ml,mc,mr,ll,lc,lr]
        #print [ghs,gvs]
        g = (ghs*ghs + gvs*gvs)**0.5
        if g > 255:
            g = 255
        rpgm.data[(height)*int(ipgm.width) + width] = str(int(g))
        
    return rpgm

def hough(pgm):
    max_circles = 3
    circles = []
    if int(pgm.width) < int(pgm.height):
        radius_max = int(pgm.width)
    else:
        radius_max = int(pgm.height)

    radius_max = 30

    counter = int(pgm.width)*[int(pgm.height)*[radius_max*[0]]]

    for x in range(0,int(pgm.width)):
        for y in range(0,int(pgm.height)):
            if pgm.data[int(pgm.width)*y+x] > 1:
                for center_x in range(0,int(pgm.width)):
                    distx = math.fabs(x - center_x)
                    for center_y in range(0,int(pgm.height)):
                        disty = math.fabs(y - center_y)
                        radius = math.sqrt((y*y + x*x) + 0.5)
                        if radius < radius_max:
                            counter[int(center_x)][int(center_y)][int(radius)] += 1
    
    while len(circles) < max_circles:
        print len(circles)
        counter_max = 0
        for center_x in range(0,int(pgm.width)):
            for center_y in range(0,int(pgm.height)):
                for radius in range(0,radius_max):
                    if counter[int(center_x)][int(center_y)][int(radius)] > counter_max:
                        counter_max = counter[int(center_x)][int(center_y)][int(radius)]
                        circle = [radius,center_x,center_y]
        for k in range(-5,5):
            if(circle[2]+k < 0 or int(pgm.height) < circle[2]+k):
                continue
            else:
                for j in range(-5,5):
                    if(circle[1]+j < 0 or int(pgm.width) < circle[1]+j):
                        continue
                    else:
                        for i in range(-5,5):
                            if(circle[0]+i < 0 or int(radius_max) < circle[0]+i):
                                continue
                            else:
                                counter[circle[0]+i][circle[1]+j][circle[2]+k] = 0

        circles.append(circle)
        
    return circles

def write_circle(ipgm,radius,center_x,center_y):
    rpgm = copy.deepcopy(ipgm)
    max_h = int(rpgm.height)
    max_w = int(rpgm.width)
    min_h = 0
    min_w = 0

    for theta in range(360):
        theta = theta*2
        width = int(center_x + radius*math.cos(theta/180.0*math.pi))
        height = int(center_y + radius*math.sin(theta/180.0*math.pi))
        if 0 <= height and height <= int(rpgm.height):
            if 0<= width and width <= int(rpgm.width):
                rpgm.data[int(rpgm.width)*height + width] = str(int(0))
    return rpgm

pgm = PGM()
#pgm.read("uzumaki.pgm")
pgm.read("bubble.pgm")
circles = hough(edge(pgm))
for circle in circles:
    pgm = write_circle(pgm,circle[0],circle[1],circle[2])
pgm.write("data.pgm")
