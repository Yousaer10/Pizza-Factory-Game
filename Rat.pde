class Rat {
  float x; // X-coordinate of the rat's position
  float y; // Y-coordinate of the rat's position
  float speed; // Speed at which the rat moves
  int imgCounter; // Counter to manage rat animation frames
  PImage[] ratImages = new PImage[8]; // Array to store rat animation frames

  // Constructor to initialise the rat with its starting position and speed
  Rat(float startX, float startY, float initialSpeed) {
    // Load rat animation frames from images and resize them
    for (int i = 0; i < ratImages.length; i++) {
      ratImages[i] = loadImage("Assets/Rat/frame_" + (i + 1) + ".png");
      ratImages[i].resize(150, 0);
    }

    // Set initial position and speed
    this.x = startX;
    this.y = startY;
    this.speed = initialSpeed;
  }

  // Move method updates the rat's position based on its speed
  void move() {
    x += speed;

    // Check if the rat has moved off the screen, reset its position
    if (x > width) {
      x = -ratImages[0].width; // Reset the position using the width of the first rat image
    }
  }

  // Display method renders the rat animation at its current position
  void display() {
    // Display the animated gif at the rat's position
    image(ratImages[imgCounter / 10 % ratImages.length], x, y);
    imgCounter++;
  }
}
