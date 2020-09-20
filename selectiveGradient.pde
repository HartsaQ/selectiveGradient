/* Loads an image and diplays it scaled to fit the display.
   Shows a diplay wide and high crosshair. 
   On mouse drag creates a gradient to drag direction from line or row
   mouse was on when mouse was pressed. 
*/

PImage pim;  //image to be manipulated
String fn = "koppis"; 
float scaleRatio;
 
void setup() {
  pim = loadImage(fn + ".jpg");  //load jpg-image
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
