// Superclass
class Rotatable {
  float x, y; // Position coordinates
  int size; // Size of the rotatable object
  float angle; // Current rotation angle
  float offsetX, offsetY; // Offset values for dragging
  boolean isDragging = false; //Indicates whether the object is being dragged

  // Constructor to initialise the Rotatable object with position and size
  Rotatable(float x, float y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  // Render the object with rotation using the provided image
  void renderRotated(PImage img) {
    imageMode(CENTER);
    pushMatrix();
    translate(this.x, this.y);
    rotate(angle);
    image(img, 0, 0, size, size);
    popMatrix();
  }

  // Rotate the object clockwise by 90 degrees
  void rotateClockwise() {
    angle += PI / 2;
    angle = angle % (2 * PI); // Keep the angle within the range [0, 2π)
  }

  // Rotate the object counter-clockwise by 90 degrees
  void rotateCounterClockwise() {
    angle -= PI / 2;
    angle = (angle + 2 * PI) % (2 * PI); // Keep the angle within the range [0, 2π)
  }

  // Start dragging the object and calculate the offset
  void startDragging() {
    offsetX = mouseX - x;
    offsetY = mouseY - y;
    isDragging = true;
  }

  // Update the position of the object during dragging
  void updateDragging(float mouseX, float mouseY) {
    x = mouseX - offsetX;
    y = mouseY - offsetY;
  }

  // Stop dragging the object
  void stopDragging() {
    isDragging = false;
  }
}
