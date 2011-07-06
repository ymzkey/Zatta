import struct
class BMP:
    def __init__(self):
        self.width = 0
        self.height = 0
        self.data = 0*[{"r":0,"g":0,"b":0}]

    def newImage(self,width,height,data):
    #data = rgb dictionary
        self.width = width
        self.height = height
        self.data = data

    def read(self,filename):
        print "open %(filename)s" % locals()
        up = struct.unpack
        code = {1:"c",2:"H",4:"I",8:"L"}
        bmpdata = {}
        image = []
        f = open(filename,"rb")
        
        #read file imfomation header
        fType = f.read(2)
        for set in[
            #read file infomation
            ["fSize",4],
            ["fReservered1",2],# always 0
            ["fReservered2",2],# always 0
            ["fOffbit",4],
            #read bitmap information
            ["headSize",4],
            ]:
            bmpdata[set[0]] = up(code[set[1]],f.read(set[1]))[0]

        #this two parameta is signed
        bmpdata["width"]  = up("i",f.read(4))[0]
        bmpdata["height"] = up("i",f.read(4))[0]
            
        for set in[
            #read bitmap information
            ["bmpPlanes",2],
            ["bitCount",2],
            ["compression",4],
            ["imageSize",4],
            ["xPixPerM",4],
            ["yPixPerM",4],
            ["clr",4],
            ["clrImportant",4],
            ["blue",1],
            ["green",1],
            ["red",1],
            ["rgbReserved",1],
            ]:
            print set[0]
            bmpdata[set[0]] = up(code[set[1]],f.read(set[1]))[0]

        #read image data
        line = bmpdata["bitCount"]/8*bmpdata["width"]
            
        print image

        print "read done"

bmp = BMP()
bmp.read("niwatori.bmp")
