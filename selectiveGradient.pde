/* Loads an image and diplays it scaled to fit the display.
   Shows a diplay wide and high crosshair. 
   On mouse drag creates a gradient to drag direction from line or row
   mouse was on when mouse was pressed.
   Key presses will change how gradient behaves. Last key press sets the bahaviour 
   b or B will set gradient to fade to black
   w or W will set gradient to fade to white
   g or G will set gradient to fade to colours of endline
   
   s or S will save the current image. A increasing number is added to file name, so each save creates a new file.
   Number is set to zero at start of program so with later runs you can erase older saves
*/

PImage pim;  //image to be manipulated
String fileBody = "koppis"; 
float scaleRatio;
boolean dragged = false;  //if mouse is dragged or not
int startX = 0; //mouse x-coordinate at start of the drag
int startY = 0; //mouse y-coordinate at start of the drag
int saveCount = 0; //times image has been save. It's also used to create unique filename for each save.
int fade = 3; //Stores selected mode of fading the gradient

public static final int HORIZONTAL = 1;
public static final int VERTICAL = 2;
public static final int BLACK = 1;
public static final int WHITE = 2;
public static final int GRADIENT = 3;
 
void setup() {
  pim = loadImage(fileBody + ".jpg");  //load jpg-image
  float xScale = pim.width/float(width);  //calculate image width ratio to canvas
  float yScale = pim.height/float(height);  //calculate image height ratio to canvas
  scaleRatio = (xScale > yScale? xScale: yScale);  //select larger ratio
  scaleRatio = (scaleRatio > 1? 1/scaleRatio: scaleRatio);  //if ratio is bigger than 1 reverse it
}

void settings() {
  size(800,600);
}

void draw() {
  background(0);
  scale(scaleRatio);  //change scale to fit the image to the canvas
  image(pim, 0 , 0);
  stroke(255);
  scale(1/scaleRatio);  //reset original scale for line drawing
  line(0, mouseY, width, mouseY);
  line(mouseX,0, mouseX, height);
}


/* Based on testing if mouse is just clicked and not moved while button is pressed called events are
    mousePressed()
    mouseReleased()
    mouseClicked()
    
   If mouse is dragged - moved while button is pressed called events are
    mousePressed()
    mouseDragged()
      .
      .
      .
    mouseDragged()
    MouseReleased()
*/

// dragged set to false to prevent false or erroneous gradient creation
void mouseClicked() {
  dragged = false;
}

// dragged set to true to initiate gradient creation at mouseRelease() event
void mouseDragged() {
  dragged = true;
}

// Store start coordinates of the mouse
void mousePressed() {
  startX = mouseX; 
  startY = mouseY;
}

//calculate mouse direction (up, down, left or right)
//call alterImage() to change the loaded image
void mouseReleased() {
  int endX = mouseX;
  int endY = mouseY;
  //to prevent unexpected event and behaviour
  int xDifference = endX - startX;
  int yDifference = endY - startY;
  //create gradients towards the largest change
  int direction = (abs(xDifference) >= abs(yDifference)? HORIZONTAL: VERTICAL);
  if(direction == HORIZONTAL) {
    alterImage(direction, floor(startX/scaleRatio), floor(endX/scaleRatio), fade);
  } else if(direction == VERTICAL) {
    alterImage(direction, floor(startY/scaleRatio), floor(endY/scaleRatio), fade);
  } else return;
}

//Increase saveCount and save image if 's' or 'S' key is pressed.
void keyPressed() {
  if(key == 's' || key == 'S') {
    saveCount++;
    pim.save(fileBody + saveCount + ".jpg");
  } else if(key == 'b' || key == 'B') {
    fade = BLACK;
  } else if(key == 'g' || key == 'g') {
    fade = GRADIENT;
  } else if(key == 'w' || key == 'w') {
    fade = WHITE;
  }
}

/*Change loaded image by drawing a gradient to given
    direction - HORIZONTAL or VERTICAL
    startline - starting line and values of the gradient
    endline - endline for the gradient 
*/
void alterImage(int direction, int startline, int endline, int mode) {
  //Keep startline and endline values in acceptable ranges.
  //otherwise it's out-of-bounds exception
  startline = startline < 1 ? 1: startline;
  endline = endline < 0 ? 0: endline;
  if(direction == VERTICAL) {
    startline = startline > pim.height-1 ? pim.height-1: startline;
    endline = endline > pim.height-1 ? pim.height-1: endline;
  } else {
    startline = startline > pim.width-1 ? pim.width-1: startline;
    endline = endline > pim.width-1 ? pim.width-1: endline;
  }
  
  //start working with pixels of the image
  pim.loadPixels();
  //
  color startPoint, endPoint;
  int dir = (startline <= endline? 1: -1);
  int diff = 0;
  if(direction == VERTICAL) {
    for(int x = 0; x < pim.width; x++) {
      startPoint = pim.pixels[startline*pim.width+x];
      if(mode == GRADIENT) {
        endPoint = pim.pixels[pim.width*endline+x];
      } else if(mode == BLACK) {
        endPoint = color(0,0,0);
      } else if(mode == WHITE) {
        endPoint = color(255,255,255);
      } else {
        endPoint = color(128,128,128);
      }
      diff = abs(endline-startline);
      if(diff==0) continue;
      //If dir is -1 then x decreases to endline otherwise it increses
      for(int y = startline; dir*y < dir*endline; y += dir ) {        
        color c = lerpColor(startPoint, endPoint, abs(y-startline)/(float)diff);
        pim.pixels[pim.width*y+x] = c;
      }
    }
  } else {
    for(int y = 0; y < pim.height; y++) {
      startPoint = pim.pixels[y*pim.width+startline];
      if(mode == GRADIENT) {
        endPoint = pim.pixels[y*pim.width+endline];
      } else if(mode == BLACK) {
        endPoint = color(0,0,0);
      } else if(mode == WHITE) {
        endPoint = color(255,255,255);
      } else {
        endPoint = color(128,128,128);
      }
      diff = abs(endline-startline);
      if(diff==0) continue;
      //If dir is -1 then x decreases to endline otherwise it increses
      for(int x = startline; dir*x < dir*endline; x += dir ) {        
        color c = lerpColor(startPoint, endPoint, abs(x-startline)/(float)diff);
        pim.pixels[y*pim.width+x] = c;
      }
    }    
  }
  pim.updatePixels();
  dragged = false;
}
