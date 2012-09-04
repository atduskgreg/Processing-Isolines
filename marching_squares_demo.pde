PImage depth;
FindIsolines finder;
int threshold = 200;

boolean showDepthImage = true;

void setup() {
  size(640, 480);
  depth = loadImage("depth_image.png");

  finder = new FindIsolines(depth.width, depth.height);
}

int[] makeGrayscale(int[] imagePixels) {
  int[] result = new int[depth.width*depth.height];
  
  for (int i = 0; i < depth.width*depth.height; i++) {  
    color c = imagePixels[i];
    result[i] = int(red(c));
  }

  return result;
}

void drawContour(int contour){
double cx = 0, cy = 0;
    for (int i = 0; i < finder.getContourLength(contour); i++) {
      cx += finder.getContourX(contour, i);
      cy += finder.getContourY(contour, i);
    }
    cx = cx / finder.getContourLength(contour);
    cy = cy / finder.getContourLength(contour);
    
    double s = 1.0;
    for (int i = 0; i < finder.getContourLength(contour); i++) {
      int xi = (int)((finder.getContourX(contour, i) - cx) * s + cx);
      int yi = (int)((finder.getContourY(contour, i) - cy) * s + cy);
      int xj = (int)((finder.getContourX(contour, i - 1) - cx) * s + cx);
      int yj = (int)((finder.getContourY(contour, i - 1) - cy) * s + cy);
      int tx = (xi + xj) / 2;
      int ty = (yi + yj) / 2;
      int nx = (int)(10 * (finder.getContourY(contour, i) - finder.getContourY(contour, i - 1)));
      int ny = (int)(10 * (finder.getContourX(contour, i - 1) - finder.getContourX(contour, i)));
      
      line(xi, yi, xj, yj);
    }
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
    drawContour(k);
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

