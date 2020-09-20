/* Loads an image and diplays it scaled to fit the display.
   Shows a diplay wide and high crosshair. 
   On mouse drag creates a gradient to drag direction from line or row
   mouse was on when mouse was pressed. 
*/

PImage pim;  //image to be manipulated
String fileBody = "koppis"; 
float scaleRatio;
boolean dragged = false;  //if mouse is dragged or not
int startX = 0; //mouse x-coordinate at start of the drag
int startY = 0; //mouse y-coordinate at start of the drag
int startTime = 0; //time at start of the drag
int saveCount = 0; //times image has been save. It's also used to create unique filename for each save.
int fade = 0;

public static final int HORIZONTAL = 1;
public static final int VERTICAL = 2;
public static final int BLACK = 1;
public static final int WHITE = 2;

 
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

// Store initial time and coordinates of the mouse
void mousePressed() {
  startX = mouseX; 
  startY = mouseY;
  startTime = millis();
  fade = (mouseButton == LEFT? BLACK: (mouseButton == RIGHT? WHITE: 0));
}

//calculate mouse accelleration and direction (up, down, left or right)
//call alterImage() to change the loaded image
void mouseReleased() {
  int endX = mouseX;
  int endY = mouseY;
  int endTime = millis();
  int timeDifference = endTime - startTime;
  //to prevent unexpected event and behaviour
  if(timeDifference <= 0) return;
  int xDifference = endX - startX;
  int yDifference = endY - startY;
  //create gradients towards the largest change
  int direction = (abs(xDifference) >= abs(yDifference)? HORIZONTAL: VERTICAL);
  float strength = 0.0;
  if(direction == HORIZONTAL) {
    strength = xDifference/float(timeDifference);
    alterImage(strength, direction, startX, fade);
  } else if(direction == VERTICAL) {
    strength = yDifference/float(timeDifference);
    alterImage(strength, direction, startY, fade);
  } else return;
}

//Increase saveCount and save image if 's' or 'S' key is pressed.
void keyPressed() {
  if(key == 's' || key == 'S') {
    saveCount++;
    pim.save(fileBody + saveCount + ".jpg");
  }
}

/*Change loaded image by drawing a gradient to given
    direction - HORIZONTAL or VERTICAL
    strength - length of the gradient
    baseline - starting line and values of the gradient
    fade - to BLACK or WHITE
*/
void alterImage(float strength, int direction, int baseline, int fade) {
  println("alterImage: " + strength + " " + direction + " " + baseline + " " + fade);
}
