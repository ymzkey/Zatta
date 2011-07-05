class BMP:
    def __init__(self):
        self.width = 0
        self.height = 0
        self.data = 0*[{"r":0,"g":0,"b":0}]

    def newImage(self,width,height,data): #data = rgb dictionary
        self.width = width
        self.height = height
        self.data = data

    def read(self,filename):
        print "open %(filename)s" % locals()
        f = open(filename,"rb")
        for line in f:
            print line
        print "done"

bmp = BMP()
bmp.read("baboon.bmp")
