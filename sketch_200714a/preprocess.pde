class Img {
  PImage img, mean, threshold, variance, kMeans, kNearest, sobel, sobelx, sobely,sobelMax,sobelMin,sobelGradient, blur;
  int [][]SobelH = {{-1, -2, -1}, 
                    {0, 0, 0}, 
                    {1, 2, 1}};

  int [][]SobelV = {{-1, 0, 1}, 
                    {-2, 0, 2}, 
                    {-1, 0, 1}};

  int [][]SobelH_ = {{-1, -1, 0}, 
                    {-1, 0, -1}, 
                    {0, -1, -1}};

  int [][]SobelV_ = {{0, -1, -1}, 
                    {-1, 0, -1}, 
                    {-1, -1, 0}};

  int [][]LapLacian = {{0, 1, 0}, 
                      {-1, 4, -1}, 
                      {0, 1, 0}};

  int [][]LapLacianD = {{-1, -1, -1}, 
                        {-1, 8, -1}, 
                        {-1, -1, -1}};
  int [][]edge = {{-1, 1, -1}, 
                  {-1, 0, -1}, 
                  {-1, -1, -1}};
  color [][]neighbours;
  Img(String s) {
    img = loadImage(s);
    neighbours = new color[img.width][img.height];
  };

  Img(PImage p) {
    img = p;
  };




  void threshold(float a) {
    threshold = new PImage(img.width, img.height, RGB);
    img.loadPixels();
    threshold.loadPixels();
    if (mean==null) {
      for (int i=0; i<img.width; i++) {
        for (int j=0; j<img.height; j++) {
          int p = i + j * img.width;
          float b = brightness(img.pixels[p]);
          if (b>a)b = 0;
          threshold.pixels[p] = color(255-b);
        }
      }
    } else {
      //for (int i=0; i<mean.width; i++) {
      //  for (int j=0; j<mean.height; j++) {
      //    int p = i + j * mean.width;
      //    float b = brightness(mean.pixels[p]);
      //    //if (b>a)b = 0;
      //    threshold.pixels[p] = color(b);
      //  }
      //}
    }

    threshold.updatePixels();

    threshold.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(mean.pixels[i]);
      //println(b);
      if (b<a)b=0;
      
      threshold.pixels[i] = color(b);
    }
    threshold.updatePixels();
  };

  void threshold(float a, PImage k) {
    threshold = new PImage(k.width, k.height, RGB);
    k.loadPixels();

    threshold.loadPixels();
    for (int i=0; i<k.pixels.length; i++) {
      float b = brightness(k.pixels[i]);
      //println(b);
      if (b<a)b=0;
      else b = 255;
      //b = 255;

      threshold.pixels[i] = color((b));
      //threshold.pixels[i] = color(b);
    }
    threshold.updatePixels();
  };

  void mean() {

    mean = new PImage(img.width, img.height, RGB);
    float mean_ = 0;
    img.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(img.pixels[i]);
      mean_ += b;
    }

    mean_ /= img.pixels.length;

    mean.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(img.pixels[i]);
      float a = mean_ - b;
      mean.pixels[i] = color(255-a);
    }

    mean.updatePixels();
  };

  void mean(float k) {

    mean = new PImage(img.width, img.height, RGB);
    float mean_ = 0;
    img.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(img.pixels[i]);
      mean_ += b;
    }

    mean_ /= img.pixels.length;
    mean_ = k + mean_;

    mean.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(img.pixels[i]);
      float a = mean_ - b;
      mean.pixels[i] = color(255-a);
    }

    mean.updatePixels();
  };

  void mean(int a) {
    mean = new PImage(img.width, img.height, RGB);

    mean.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        //float b = brightness(img.pixels[p]);

        float mean_ = getNeighboursMean(i, j, a);
        //println(mean_);
        float a1 = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
        float a2 = red(img.pixels[p]);
        float a3 = green(img.pixels[p]);
        float a4 = blue(img.pixels[p]);

        float a5 = brightness(img.pixels[p]);
        mean.pixels[p] = color((mean_-a5));
        mean.pixels[p] = color(255-(mean_-a5)*mult);
      }
    }
    mean.updatePixels();
  };
  
  void mean(int a,PImage img) {
    mean = new PImage(img.width, img.height, RGB);

    mean.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        
        float mean_ = getNeighboursMean(i, j, a);
        float a1 = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
        float a2 = red(img.pixels[p]);
        float a3 = green(img.pixels[p]);
        float a4 = blue(img.pixels[p]);
        float a5 = brightness(img.pixels[p]);
        mean.pixels[p] = color((mean_-a5));
        mean.pixels[p] = color(255-(mean_-a5)*mult);
      }
    }
    mean.updatePixels();
  };

  void mean(int a, float k) {
    mean = new PImage(img.width, img.height, RGB);

    mean.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        //float b = brightness(img.pixels[p]);

        float mean_ = getNeighboursMean(i, j, a);
        //println(mean_);
        float b = brightness(img.pixels[p]);
        //println(mean_ - b);
        //img.pixels[p] = color(b);
        mean.pixels[p] = color(255-(mean_ -b)+k);
      }
    }
    mean.updatePixels();
  };

  void meanR(int a) {
    mean = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);
        img.pixels[p] = color(b);
      }
    }
  };

  void meanG(int a) {
    mean = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);
        img.pixels[p] = color(b);
      }
    }
  };

  void meanB(int a) {
    mean = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);
        img.pixels[p] = color(b);
      }
    }
  };

  void meanRGB() {
    mean = new PImage(img.width, img.height, RGB);
    float mean_ = 0;
    img.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float b = brightness(img.pixels[i]);
      mean_ += b;
    }

    mean_ /= img.pixels.length;
    mean_ = 150 +mean_;

    mean.loadPixels();
    for (int i=0; i<img.pixels.length; i++) {
      float r = red(img.pixels[i]);
      float g = green(img.pixels[i]);
      float b = blue(img.pixels[i]);
      float br = brightness(img.pixels[i]);
      float a = mean_ - (r+g+b+br)/4;
      mean.pixels[i] = color(255-a);
    }

    mean.updatePixels();
  };

  void localMean() {
    mean = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);
      }
    }
  };

  void kMeans() {
    kMeans = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        //float b = map(brightness(img.pixels[p]),0,255,0,100);
        float b = brightness(img.pixels[p]);
        img.pixels[p] = color(b);
      }
    }
  };

  void kNearest(float a) {
    variance = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);

        img.pixels[p] = color(b);
      }
    }
  };

  void variance() {
    variance = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float var = getNeighboursVar(0, 0, 0);
        float a1 = red(img.pixels[p]);
        float a2 = green(img.pixels[p]);
        float a3 = blue(img.pixels[p]);
        float a4 = brightness(img.pixels[p]);

        float a = var-a4;
        variance.pixels[p] = color(255-a);
      }
    }
  };

  void variance(int a) {
    variance = new PImage(img.width, img.height, RGB);
    img.loadPixels();
    variance.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        
        int p = i + j * img.width;
        float var = getNeighboursVar(i, j, a);
        
        float av = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
        float a1 = red(img.pixels[p]);
        float a2 = green(img.pixels[p]);
        float a3 = blue(img.pixels[p]);
        float a4 = brightness(img.pixels[p]);

        //float r = (var)-av;?
        float r = (var);
        variance.pixels[p] = color((r));
      }
    }
    variance.updatePixels();
  };

  void kNearest() {
    variance = new PImage(img.width, img.height, RGB);
    img.loadPixels();

    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float b = brightness(img.pixels[p]);

        img.pixels[p] = color(b);
      }
    }
  };

  void blur(int a) {
    blur = new PImage(img.width, img.height, RGB);

    blur.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {
        int p = i + j * img.width;
        float mean_ = getNeighboursBlur(i, j, a);
        blur.pixels[p] = color((mean_));
      }
    }
    blur.updatePixels();
  };
  
  float getNeighboursBlur(int x, int y,int a){
    float mean = 0;
    int count = 0;
    for (int i=x-a; i<=x+a; i++) {
      for (int j=y-a; j<=y+a; j++) {
        int p = i + j * img.width;
        if (p<img.pixels.length&&p>0) {
          float b = (red(img.pixels[p])+green(img.pixels[p])+blue(img.pixels[p])+brightness(img.pixels[p]))/4;
           mean += brightness(img.pixels[p]);
           count++;
      }}
    }
    return mean/count;
  };

  void getNeighboursAv(int x, int y) {
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {
      }
    }
  };

  float getNeighboursMean(int x, int y, int a) {
    float mean = 0;
    int count = 0;
    int count2 = 0;
    int p1 = x + y * img.width;
    float b1 = (red(img.pixels[p1])+green(img.pixels[p1])+blue(img.pixels[p1])+brightness(img.pixels[p1]))/4;
    float k = 40;
    for (int i=x-a; i<=x+a; i++) {
      for (int j=y-a; j<=y+a; j++) {
        int p = i + j * img.width;
        if (p<img.pixels.length&&p>0) {
          float b = (red(img.pixels[p])+green(img.pixels[p])+blue(img.pixels[p])+brightness(img.pixels[p]))/4;
            mean += brightness(img.pixels[p]);
          count++;
        }
      }
    }
    return mean/count;
  };

  float getNeighboursVar(int x, int y, int a) {
    float variance = 0;
    int count = 0;
    int count2 = 0;
    for (int i=x-a; i<=x+a; i++) {
      for (int j=y-a; j<=y+a; j++) {
        int p = i + j * img.width;
        if (p<img.pixels.length&&p>0) {
          //float a1 = (red(m.pixels[p]) + green(threshold.pixels[p]) + blue(threshold.pixels[p]) + brightness(thresholdmean.pixels[p]))/4;
          float a1 = (red(threshold.pixels[p]) + green(threshold.pixels[p]) + blue(threshold.pixels[p]) + brightness(threshold.pixels[p]))/4;
          float a2 = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
          //variance += brightness(threshold.pixels[p]) - brightness(img.pixels[p]);
          variance += (a1-a2)*(a1-a2);

          count++;
          if (brightness(threshold.pixels[p])>10)count2++;
        }
      }
    }
    return sqrt(variance/count);
  };

  void getNeighbours2Min(int x, int y, int a, int b) {
    for (int i=x-a; i<=x+b; i++) {
      for (int j=y-a; j<=y+b; j++) {
      }
    }
  };

  void getNeighbours2Min(int x, int y, int a) {
    for (int i=x-a; i<=x+a; i++) {
      for (int j=y-a; j<=y+a; j++) {
      }
    }
  };
  
  void sobel() {
    sobel = new PImage(img.width, img.height, RGB);
    sobel.loadPixels();
    sobelx = new PImage(img.width, img.height, RGB);
    sobelx.loadPixels();
    sobely = new PImage(img.width, img.height, RGB);
    sobely.loadPixels();
    sobelGradient = new PImage(img.width, img.height, RGB);
    sobelGradient.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {

        int p = i + j * img.width;
        float[] val = getSobel(i, j);
        float b = (red(img.pixels[p])+green(img.pixels[p])+blue(img.pixels[p])+brightness(img.pixels[p]))/4;
        float r = red(img.pixels[p]);
        float g = green(img.pixels[p]);
        float b1 = blue(img.pixels[p]);
        float b2 = brightness(img.pixels[p]);
        float v = val[0];

        float k = (v)*mult;
        sobel.pixels[p] = color(255-k+offset);
        sobelx.pixels[p] = color(val[1]);
        sobely.pixels[p] = color(val[2]);
        sobelGradient.pixels[p] = color(0,0,0,val[4]);
      }
    }
    sobel.updatePixels();
    sobelx.updatePixels();
    sobely.updatePixels();
    sobelGradient.updatePixels();
  };

  void sobel(PImage img) {
    sobel = new PImage(img.width, img.height, RGB);
    sobel.loadPixels();
    sobelx = new PImage(img.width, img.height, RGB);
    sobelx.loadPixels();
    sobely = new PImage(img.width, img.height, RGB);
    sobely.loadPixels();
    sobelGradient = new PImage(img.width, img.height, RGB);
    sobelGradient.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {

        int p = i + j * img.width;
        float[] val = getSobel(i, j);
        float b = (red(img.pixels[p])+green(img.pixels[p])+blue(img.pixels[p])+brightness(img.pixels[p]))/4;
        float r = red(img.pixels[p]);
        float g = green(img.pixels[p]);
        float b1 = blue(img.pixels[p]);
        float b2 = brightness(img.pixels[p]);
        float v = val[0];

        float k = (v)*mult;
        sobel.pixels[p] = color(255-k+offset);
        sobelx.pixels[p] = color(val[1]);
        sobely.pixels[p] = color(val[2]);
        sobelGradient.pixels[p] = color(0,0,0,val[4]);
      }
    }
    sobel.updatePixels();
    sobelx.updatePixels();
    sobely.updatePixels();
    sobelGradient.updatePixels();
  };

  float []getSobel(int x, int y) {
    float val = 0;
    float vy = 0;
    float vx = 0;
    img.loadPixels();
    int count = 0;
    int count2 = 0;
    int p1 = x + y * img.width;
    float b1 = (red(img.pixels[p1])+green(img.pixels[p1])+blue(img.pixels[p1])+brightness(img.pixels[p1]))/4;
    float k = 40;
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {

        int p = i + j * img.width;
        if (p>0&&p<img.pixels.length) {
          float b = (red(img.pixels[p])+green(img.pixels[p])+blue(img.pixels[p])+brightness(img.pixels[p]))/4;
            
            int x1 = 0 + i - x + 1;
            int y1 = 0 + j - y + 1;

            float col = brightness(img.pixels[p]);
            //col = b;
            float v = SobelH[x1][y1] * col;
            float h = SobelV[x1][y1] * col;
            //v = LapLacian[x1][y1] * col;
            //h = LapLacianD[x1][y1] * col;
            vx += v;
            vy += h;
          count ++;
        }
      }
    }

    vx/= count;
    vy/= count;

    val = sqrt(vx*vx + vy*vy);
    float [] sob = {val, vx, vy, count2,atan2(vy,vx)};
    return sob;
  };

  float []getSobel(int x, int y, PImage img) {
    float val = 0;
    float vy = 0;
    float vx = 0;
    img.loadPixels();
    int count = 0;
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {

        int p = i + j * img.width;
        if (p>0&&p<img.pixels.length) {
          int x1 = 0 + i - x + 1;
          int y1 = 0 + j - y + 1;

          float col = brightness(img.pixels[p]);
          col = (red(img.pixels[p])+blue(img.pixels[p])+green(img.pixels[p])+brightness(img.pixels[p]))/4;
          float v = SobelH[x1][y1] * col;
          float h = SobelV[x1][y1] * col;

          //println(col);
          vx += v;
          vy += h;

          count ++;
        }
      }
    }

    vx/= count;
    vy/= count;

    val = sqrt(vx*vx + vy*vy);
    float [] sob = {val, vx, vy, count};
    return sob;
  };
  
  void sobelMax(){
    sobelMax = new PImage(img.width, img.height, RGB);
    sobelMax.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {

        int p = i + j * img.width;
        
        boolean max = getNeighboursMax(i,j);
        if(!max)sobelMax.pixels[p] = color(255);
        else sobelMax.pixels[p] = sobel.pixels[p];
      }}
  };
  
  boolean getNeighboursMax(int x, int y) {
    
    float []max = new float[3];
    max[0] = 0;
    boolean k = false;
    int p = x + y * img.width;
    float myGradient = brightness(sobelGradient.pixels[p]);
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {
        
        int p1 = i+j*sobel.width;
        
        if(p1>0&&p1<sobel.pixels.length&&p1!=p){
        float cGradient = brightness(sobelGradient.pixels[p1]);
          float c = brightness(sobel.pixels[p1]);
          if(max[0]<c){
            max[0] = c;
            max[1] = i;
            max[2] = j;
          }
      }}
    }
    int p2 = (int)max[1] + (int)max[2] * sobelGradient.width;
    //if(p2
    //println((int)max[0],(int)max[1],x,y);
    float cGradient = brightness(sobelGradient.pixels[p]);
    //if(max[0]>=brightness(blur.pixels[x+y*sobel.width])||(cGradient==-1/myGradient||cGradient==PI-(-1/myGradient)))k=true;
    boolean k2 = false;
    float r=0,g=0,b=0,b1=0,r1=0,g1=0,b2=0,b3=0;
      r = red(img.pixels[p]);
      g = green(img.pixels[p]);
      b = blue(img.pixels[p]);
      b1 = brightness(img.pixels[p]);
      r1 = red(img.pixels[p2]);
      g1 = green(img.pixels[p2]);
      b2 = blue(img.pixels[p2]);
      b3 = brightness(img.pixels[p2]);
      float t = 0;
    if(abs(r-r1)<t||abs(g-g1)<t||abs(b-b2)<t||abs(b1-b3)<t)k2 = true;
    
    if(max[0]>=brightness(img.pixels[x+y*sobel.width])||(cGradient==-1/myGradient||cGradient==PI-(-1/myGradient))||k2)k=true;
    
    return k;
  };
  
  void getNeighboursMax(int x, int y,int a) {
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {
        
        
      }
    }
  };
  
  void sobelMin(){
    sobelMin = new PImage(img.width, img.height, RGB);
    sobelMin.loadPixels();
    for (int i=0; i<img.width; i++) {
      for (int j=0; j<img.height; j++) {

        int p = i + j * img.width;
        
        boolean min = getNeighboursMin(i,j);
        if(!min)sobelMin.pixels[p] = color(255);
        else sobelMin.pixels[p] = sobel.pixels[p];
      }}
  };
  
  boolean getNeighboursMin(int x, int y) {
    
    float []min = new float[3];
    min[0] = 100000;
    boolean k = false;
    int p = x + y * img.width;
    float myGradient = brightness(sobelGradient.pixels[p]);
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {
        
        int p1 = i+j*sobel.width;
        
        if(p1>0&&p1<sobel.pixels.length&&p1!=p){
        float cGradient = brightness(sobelGradient.pixels[p1]);
        
        //if(cGradient==-1/myGradient||cGradient==PI-(-1/myGradient)){
        //if(cGradient==myGradient){
          float c = brightness(sobel.pixels[p1]);
          if(min[0]>c){
            min[0] = c;
            min[1] = i;
            min[2] = j;
          }
        //}
      }}
    }
    //println(min[0],brightness(blur.pixels[x+y*sobel.width]));
    int p2 = (int)min[1] + (int)min[2] * sobelGradient.width;
    //if(p2
    //println((int)min[0],(int)min[1],x,y);
    float cGradient = brightness(sobelGradient.pixels[p]);
    //if(min[0]>=brightness(blur.pixels[x+y*sobel.width])||(cGradient==-1/myGradient||cGradient==PI-(-1/myGradient)))k=true;
    boolean k2 = false;
    float r = red(blur.pixels[p]);
    float g = green(blur.pixels[p]);
    float b = blue(blur.pixels[p]);
    float b1 = brightness(blur.pixels[p]);
    float r1 = red(blur.pixels[p2]);
    float g1 = green(blur.pixels[p2]);
    float b2 = blue(blur.pixels[p2]);
    float b3 = brightness(blur.pixels[p2]);
    float t = 0;
    if(abs(r-r1)<t||abs(g-g1)<t||abs(b-b2)<t||abs(b1-b3)<t)k2 = true;
    
    //if(min[0]<=brightness(blur.pixels[x+y*sobel.width])||(cGradient==-1/myGradient||cGradient==PI-(-1/myGradient))||k2)k=true;
    if(min[0]<=brightness(blur.pixels[x+y*sobel.width])&&(cGradient!=-1/myGradient&&cGradient!=PI-(-1/myGradient)))k=true;
    //if(min[0]<=brightness(blur.pixels[x+y*sobel.width])||(cGradient==myGradient))k=true;
    //if(min[0]<=brightness(blur.pixels[x+y*sobel.width]))k=true;
    return k;
  };
  
  void getNeighboursMin(int x, int y,int a) {
    for (int i=x-1; i<=x+1; i++) {
      for (int j=y-1; j<=y+1; j++) {
        
        
      }
    }
  };
};
