import processing.serial.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
Serial port;
PImage detect;
Rectangle[] faces; // List of detected faces

void setup() {
  port = new Serial(this, "COM3", 9600);
  
  size(960, 720);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  // String[] cameras = Capture.list();
  // for (int i = 0; i < cameras.length; ++i) System.out.println(cameras[i]);
  
  animal = loadImage("animal.png");
  detect = loadImage("detected.png");
  
  video.start();
}

void draw() {
  opencv.loadImage(video);
  image(video, 0, 0);
  
  drawmonster();

  faces = opencv.detect(1.05, 6, org.opencv.objdetect.Objdetect.CASCADE_DO_CANNY_PRUNING, 30, 23333);
  
  for (int i = 0; i < faces.length; i++) { //For every faces
  image(detect,faces[i].x, faces[i].y, faces[i].width+10, faces[i].height+10);  // Draw the face  //<>//
  }
  move();// Movement of Monster‘s eye

  // Send to Arduino Left/Right/relax/nervous/Middle
  int index = -1; 
  if (faces.length == 0) port.write("r"); // No face
  else if (faces.length == 1) index = 0; // One face 
  else {
    int maxs = 0, max2s = 0, mi = -1;
    for (int i = 0; i < faces.length; ++i) { // Compare the area of every face
      int s = faces[i].width * faces[i].height;
      if (s > maxs) {
        max2s = maxs;
        maxs = s;
        mi = i;
      } else if (s > max2s) max2s = s;
    }
    if (maxs >= max2s * 2) index = mi; //If area of the biggest face >= 2nd
    else {
      final int NONE = 0, L = 1, R = 2;
      int flag = NONE;
      for (int i = 0; i < faces.length; ++i) { // Location of face
        int x = faces[i].x + faces[i].width / 2;
        if (x < width * .4) flag |= L;
        else if (x > width * .6) flag |= R;
      }
      if (flag == L) port.write("L");
      else if (flag == R) port.write("R");
      else port.write("n"); 
    }
  }
  if (index >= 0) { // -1 means having been processed, no need to do it again
    int x = faces[index].x + faces[index].width / 2;
    if (x < width * .4) port.write("L");
    else if (x > width * .6) port.write("R");
    else port.write("M" + (x < width / 2 ? "L" : "R")); 
    // If the face is in the middle, would not turn around if it has turned already
  }
}

void captureEvent(Capture c) {
  c.read();
}