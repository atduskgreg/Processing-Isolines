import isolines.*;

PImage depth;
Isolines finder;
int threshold = 200;

boolean showDepthImage = true;

void setup() {
  size(640, 480);
  depth = loadImage("depth_image.png");

  finder = new Isolines(this, depth.width, depth.height);
}

int[] makeGrayscale(int[] imagePixels) {
  int[] result = new int[depth.width*depth.height];
  
  for (int i = 0; i < depth.width*depth.height; i++) {  
    color c = imagePixels[i];
    result[i] = int(red(c));
  }

  return result;
}


void draw() {
  background(0);
  if(showDepthImage){
    image(depth, 0, 0);
  }
  depth.loadPixels();
  finder.find(makeGrayscale(depth.pixels));
  stroke(255,0,0);
  for(int k = 0; k < finder.getNumContours(); k++){
    finder.drawContour(k);
  }

  fill(0, 255, 0);
  text("threshold: " + threshold, width-150, 20);
  text("numContours: " + finder.getNumContours(), width-150, 40);
  text("press 'h'\nto toggle image", width-150, 60);

}

void mousePressed() {
  color c = get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
}

void keyPressed() {
  if (key == '-') {
    threshold--;
    if (threshold < 0) {
      threshold = 0;
    }
    finder.setThreshold(threshold);
  }
  if (key == '=') {
    threshold++;
    finder.setThreshold(threshold);
  }
  
  if(key == 'h'){
    showDepthImage = !showDepthImage;
  }
}

