boolean recording = false;
import com.hamoid.*;
VideoExport vid;
int startFrame = 275;
int numFrames = 380;

PImage img;
int divs = 100;
float bScale = 15;
char character = 'x';

boolean textWrap = true;

BufferedReader reader;
String line;

void setup()
{
  size(800,600);
  colorMode(HSB, 1);
  background(0);
  fill(1);
  stroke(1);
  textSize(divs/10);
  frameRate(30);
  
  img = loadImage("capone3.jpg");
  img.resize(800,600);
  img.loadPixels();
  
  // initialize reader and read file
  reader = createReader("capone.txt");
  try 
  {
    line = reader.readLine();
  } 
  catch (IOException e) 
  {
    e.printStackTrace();
    line = null;
  }
  
  // initialize video
  if(recording)
    vid = new VideoExport(this, "C:/Users/Box/Desktop/capone4.mp4");
    //vid = new VideoExport(this, "/Users/erichesson/Desktop/lion5.mp4");
}






void draw()
{
  int adjFrame = startFrame + frameCount;
  
  float speed = 0.50;
  int divsOff = 50;
  int divsDev = 48;
  
  bScale = 23;
  //divs = 68;
  divs = int(divsOff + sin(adjFrame/30.0 * speed) * divsDev);
  
  if(divs < 1)
    divs = 1;
  
  fill(0,0.8);
  rect(0,0,width,height);
  fill(1);
  
  float yDiv = height/(float)divs;
  float xDiv = width/(float)divs;
  
  println(divs, ' ', xDiv, ' ', yDiv);
  
  translate(0, yDiv/2);
  
  for(int j = 0; j < divs; j++)
  {
    pushMatrix();
    for(int i = 0; i < divs; i++)
    {
      translate(xDiv, 0);
      
      int p = int(int(j * yDiv) * width + i * xDiv);
      
      float b = red(img.pixels[p]);
                 
      //float b = (2.0 - saturation(img.pixels[j * yDiv * width + i * xDiv]) * 
      //           brightness(img.pixels[j * yDiv * width + i * xDiv]));
                 
      //float b = pow(brightness(img.pixels[p]),1);
                
      if(b <= 0 || bScale <= 0)
        textSize(0.1);
      else
        textSize(b * bScale);
        
      fill(color(img.pixels[p]), 0.6);
      
      if(textWrap)
        text(line.charAt((j * divs + i) % line.length()),0,0);
      else
        text(line.charAt((i) % line.length()),0,0);
    }
    popMatrix();
    translate(0,yDiv);
  }
  
  print(frameCount, '\n');
  
  if(recording)
  {
    
    if(frameCount == 6)
      vid.startMovie();
    
    vid.saveFrame();
    
    if(frameCount == numFrames)
    {
      vid.endMovie();
      exit();
    }
  }
}