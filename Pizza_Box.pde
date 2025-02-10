// PizzaBox class inherits Rotatable class attributes
class PizzaBox extends Rotatable {
  
  PImage pizzaBoxImage;
  // Boolean flag to track whether a bonus has been awarded
  boolean bonusAwarded = false;
  
  // Constructor for PizzaBox class
  PizzaBox(float x, float y) {
    // Call the constructor of the superclass (Rotatable) with initial position and size
    super(x, y, 305);

    // Load the pizza box image from the specified path
    pizzaBoxImage = loadImage("Assets/pizzaBox.png");

    // Resize the pizza box image to match the size of the pizza base
    pizzaBoxImage.resize(0, 305);

    // Set a random initial angle (0, 90, 180, or 270 degrees)
    angle = radians(int(random(4)) * 90);
  }

  // Display method to render the rotated pizza box
  void display() {
    renderRotated(pizzaBoxImage);
    checkCollisionWithPizzaBase();
  }

  // Check for collision between the pizza box and the pizza base
  void checkCollisionWithPizzaBase() {
    // Calculate the boundaries of the rotated pizza box
    float boxLeft = x - pizzaBoxImage.width / 2;
    float boxRight = x + pizzaBoxImage.width / 2;
    float boxTop = y - pizzaBoxImage.height / 2;
    float boxBottom = y + pizzaBoxImage.height / 2;

    // Calculate the boundaries of the pizza base
    float baseLeft = pizza.x;
    float baseRight = pizza.x + pizza.pizzaBase.width;
    float baseTop = pizza.y;
    float baseBottom = pizza.y + pizza.pizzaBase.height;

    // Check for collision
    if (boxRight > baseLeft && boxLeft < baseRight && boxBottom > baseTop && boxTop < baseBottom) {
      // Collision detected

      // Calculate the centre of the pizza base
      float centerX = (baseLeft + baseRight) / 2;
      float centerY = (baseTop + baseBottom) / 2;

      // Set the position of the pizza box to the centre of the pizza base
      x = centerX;
      y = centerY;

      // Check for bonus score
      checkBonus();
    }
  }

  // Check for a bonus score based on the angle of the pizza box
  void checkBonus() {
    // Check if the pizza box angle is 0 and bonus has not been awarded
    if (angle == 0 && bonusAwarded == false) {
      // Call the bonusScore method from the ScoreBoard class
      scoreBoard.bonusScore();

      // Set the flag to true to indicate that the bonus score has been awarded
      bonusAwarded = true;
    }
  }

  // Reset the position of the pizza box
  void resetPosition() {
    // Reset the bonus awarded flag
    bonusAwarded = false;

    // Set the initial position of the pizza box to the centre of the display
    x = displayWidth / 2;
    y = 480;

    // Set a random initial angle (0, 90, 180, or 270 degrees)
    angle = radians(int(random(4)) * 90);
  }
}
