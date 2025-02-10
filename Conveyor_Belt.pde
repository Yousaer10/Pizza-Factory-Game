class ConveyorBelt implements DifficultyListener {
  int boxSize; // Size of the conveyor box
  float squareX; // X-coordinate of the conveyor box
  float speed; // Speed of the conveyor belt


  // Constructor for ConveyorBelt class
  ConveyorBelt(int boxSize, float squareX, float speed) {
    this.boxSize = boxSize;
    this.squareX = squareX;
    this.speed = speed;
  }

  // Render method to display the conveyor belt
  void render() {
    float startX = frameCount * -speed; // Calculate the starting position for animation based on speed
    fill(120, 100, 80); // Set the fill colour for the conveyor box

    // Draw conveyor boxes horizontally
    while (startX < width) {
      rect(startX, height - 300, boxSize, boxSize); // Draw a conveyor box
      startX += boxSize; // Move to the next position
    }

    // Check if difficulty should be increased
    if (pizza.isDifficultyIncreased == true) {
      onDifficultyIncreased(); // Call the onDifficultyIncreased method
    }
  }

  // Override method from DifficultyListener interface
  @Override
  public void onDifficultyIncreased() {
    speed += 0.5; // Increase the speed of the conveyor belt
    pizza.isDifficultyIncreased = false; // Reset the difficulty increase flag
  }
}
