int W = 1200,H = 600;
//change multiplier to increase line thickness
float cutoff = 5,mult = 20,offset = 100;

PImage pimg;
Img img;

void settings(){
  size(W,H);
}
void setup(){
  
  img = new Img("house.jpg");
  //img.blur(5);
  //img.mean(4);
  //img.threshold(250);
  //img.variance(4);
  img.sobel();
  
};
float x =0,y =0;
void draw(){
  background(50);
  
  //if(pmouseX!=mouseX||pmouseY!=mouseY){
    if(img.img.width>width)
    x = map(mouseX,0,img.img.width,0,width);;
    if(img.img.height>height)
    y = map(mouseY,0,height,0,img.img.height);
    ;
  //}
  //image(img.threshold,-x,-y);
  //image(img.variance,-x,-y);
  image(img.sobel,-x,-y);
  //image(img.sobelMax,-x,-y);
  //image(img.sobelMin,-x,-y);
  //image(img.mean,-x,-y);
  //image(img.blur,-x,-y);
  //image(pimg,0,0);
  fill(0);
  if(mousePressed)fill(255);
  text(frameRate,10,10);
  
  text(x,10,20);
};
