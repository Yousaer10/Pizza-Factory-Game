class Topping {
  // Members
  PImage[] meatyPizza = new PImage[6];
  PImage[] veggiePizza = new PImage[6];
  PImage[] spicyPizza = new PImage[6];
  PImage[] mixPizza = new PImage[6];
  float[] x = new float[12]; // x position for each topping
  float[] y = new float[12]; // y position for each topping
  boolean isDragging = false; // Indicate whether any topping is being dragged
  int draggingIndex = -1; // Index of the topping being dragged
  ArrayList<Topping> Picked = new ArrayList<Topping>();
  String gameObjective [] = {"Meaty Pizza", "Veggie Pizza", "Spicy Pizza", "Mixed Pizza"};
  int randomObjective = int(random(gameObjective.length));
  Scoreboard scoreBoard; // Add a reference to the Scoreboard instance
  PImage[] selectedToppings;
  Pizza pizza;  // Add a reference to the Pizza instance
  ArrayList<String> toppingNames;
  ArrayList<String> toppingPaths = new ArrayList<String>();
  ArrayList<Integer> addedToppings = new ArrayList<Integer>();
  float dropAnimationSpeed; // Adjust the animation speed as needed
  float[] initialX = new float[12];
  float[] initialY = new float[12];
  boolean isAnimatingDrop = false; //Track drop animation state

  // Constructor initialises Topping with a Scoreboard and Pizza instance
  Topping(Scoreboard scoreBoard, Pizza pizza) {
    this.scoreBoard = scoreBoard;
    this.pizza = pizza;
    this.toppingNames = new ArrayList<String>();
    this.addedToppings = new ArrayList<Integer>(); // Initialise the ArrayList
    // Load toppings into arrays
    loadAssets();

    // Set initial positions for each topping
    for (int i = 0; i < x.length; i++) {
      x[i] = displayWidth - 300 - i * 275;
      y[i] = 80;
    }
  }

  // Load the images for different pizza categories
  void loadAssets() {
    // Define the toppings for each pizza category
    String[] meatyPizzaToppings = {"Salami.png", "Mushrooms.png", "Olives.png", "Onion.png", "redPepper.png", "Tomatoes.png"};
    String[] veggiePizzaToppings = {"Basil.png", "greenChillies.png", "Mushrooms.png", "Olives.png", "Onion.png", "Tomatoes.png"};
    String[] spicyPizzaToppings = {"choppedRedChillies.png", "greenChillies.png", "redChillies.png", "redPepper.png", "Salami.png", "Tomatoes.png"};
    String[] mixPizzaToppings = {"Basil.png", "choppedOlive.png", "greenChillies.png", "Olives.png", "Parsley.png", "Tomatoes.png"};

    // Load toppings into arrays
    meatyPizza = loadToppings(meatyPizzaToppings);
    veggiePizza = loadToppings(veggiePizzaToppings);
    spicyPizza = loadToppings(spicyPizzaToppings);
    mixPizza = loadToppings(mixPizzaToppings);
  }

  // Method to change the objective, triggered by a button click
  void changeObjective() {
    topping.randomObjective = int(random(topping.gameObjective.length));
    updateToppings();
  }

  // Set initial positions for each topping
  void setPosition() {
    for (int i = 0; i < x.length; i++) {
      x[i] = displayWidth - 300 - i * 275;
      y[i] = 80;
    }
  }

  // Update the toppings based on the random objective
  int updateToppings() {
    switch(gameObjective[randomObjective]) {
    case "Meaty Pizza":
      selectedToppings = meatyPizza;
      break;
    case "Veggie Pizza":
      selectedToppings = veggiePizza;
      break;
    case "Spicy Pizza":
      selectedToppings = spicyPizza;
      break;
    case "Mixed Pizza":
      selectedToppings = mixPizza;
      break;
    default:
      selectedToppings = meatyPizza; // Use default toppings array if no match
      break;
    }

    return randomObjective;
  }

  // Display the objective and selected toppings
  void display() {
    if (!pizza.gameLost) {
      fill(255);
      textSize(50);
      text("Objective:  " + gameObjective[randomObjective], 25, 50);
      updateToppings();
      // Display the selected toppings
      for (int i = 0; i < selectedToppings.length; i++) {
        image(selectedToppings[i], x[i], y[i]);
      }
    }
  }

  // Move the toppings based on their movement speed
  void move() {
    for (int i = 0; i < selectedToppings.length; i++) {
      // Check if the topping has gone off the screen and is not removed
      if (x[i] >= -selectedToppings[i].width && addedToppings.contains(i)) {
        x[i] -= dropAnimationSpeed;
        // Display the topping only if it is still on the conveyor belt
        displayTopping(i);
      }
    }
  }

  // Display a specific topping based on its index
  void displayTopping(int toppingIndex) {
    image(selectedToppings[toppingIndex], x[toppingIndex], y[toppingIndex]);
  }

  // Display all toppings after updating their positions
  void displayToppings() {
    // Display the selected toppings
    for (int i = 0; i < selectedToppings.length; i++) {
      image(selectedToppings[i], x[i], y[i]);
    }
  }

  // Drag and drop functionality for toppings
  void drag() {
    updateToppings();

    // Check if any topping is currently being dragged
    boolean toppingBeingDragged = isDragging && draggingIndex != -1;

    for (int i = 0; i < selectedToppings.length; i++) {
      // Check if the mouse is pressed on a topping and no topping is currently being dragged
      if (!toppingBeingDragged && mousePressed && mouseX > x[i] && mouseX < x[i] + selectedToppings[i].width &&
        mouseY > y[i] && mouseY < y[i] + selectedToppings[i].height && !addedToppings.contains(i)) {
        // Set the dragging state and store the initial position
        isDragging = true;
        draggingIndex = i;
        initialX[i] = x[i];
        initialY[i] = y[i];
      }

      // If the topping is being dragged and it has not been added, set its position to the mouse coordinates
      if (isDragging && i == draggingIndex && !addedToppings.contains(i)) {
        x[i] = mouseX - selectedToppings[i].width / 2;
        y[i] = mouseY - selectedToppings[i].height / 2;
      }
    }

    // Reset dragging state if the mouse is not pressed or the topping has been added
    if (!mousePressed || (addedToppings.contains(draggingIndex) && isDragging)) {
      isDragging = false;
      draggingIndex = -1;
    }
  }

  // Check if the mouse is over a specific topping
  boolean isMouseOverTopping(int toppingIndex) {
    // Calculate the boundaries of the topping image
    float toppingLeft = x[toppingIndex] - selectedToppings[toppingIndex].width / 2;
    float toppingRight = x[toppingIndex] + selectedToppings[toppingIndex].width / 2;
    float toppingTop = y[toppingIndex] - selectedToppings[toppingIndex].height / 2;
    float toppingBottom = y[toppingIndex] + selectedToppings[toppingIndex].height / 2;

    // Check if the mouse is within the boundaries of the topping image
    return mouseX > toppingLeft && mouseX < toppingRight && mouseY > toppingTop && mouseY < toppingBottom;
  }

  // Check conditions for dropping a topping onto the pizza
  boolean drop() {
    // Check if any topping is currently being dragged
    boolean toppingBeingDragged = isDragging && draggingIndex != -1;

    // Check if the topping is being dragged and has not been added
    if (toppingBeingDragged && !addedToppings.contains(draggingIndex)) {
      float overlapPercentage = calculateOverlapPercentage(x[draggingIndex], y[draggingIndex], selectedToppings[draggingIndex], pizza);

      // Check if the topping has at least 50% overlap with the pizza
      if (overlapPercentage >= 50) {
        // Detected collision with at least 50% overlap

        // Check if the topping is dragged onto the center of the pizza base
        float pizzaCenterX = pizza.x + pizza.pizzaBase.width / 2;
        float pizzaCenterY = pizza.y + pizza.pizzaBase.height / 2;

        // Calculate the distance between the topping center and pizza base center
        float distanceToCenter = dist(x[draggingIndex], y[draggingIndex], pizzaCenterX, pizzaCenterY);

        // Drop the topping onto the pizza base
        dropTopping(draggingIndex);

        // Update the score or perform other actions
        scoreBoard.calculateScore();

        return true; // Return true indicating a successful drop
      }
    }

    return false; // Return false if no drop condition is met
  }

  // Calculate the overlap percentage of a topping with the pizza
  float calculateOverlapPercentage(float toppingX, float toppingY, PImage toppingImage, Pizza pizza) {
    float toppingArea = toppingImage.width * toppingImage.height;
    float pizzaArea = pizza.pizzaBase.width * pizza.pizzaBase.height;

    float overlapArea = calculateOverlapArea(toppingX, toppingY, toppingImage, pizza);

    // Calculate overlap percentage
    float overlapPercentage = (overlapArea / pizzaArea) * 100;

    return overlapPercentage;
  }

  // Calculate the overlap area of a topping with the pizza
  float calculateOverlapArea(float toppingX, float toppingY, PImage toppingImage, Pizza pizza) {
    float toppingLeft = max(toppingX, pizza.x);
    float toppingRight = min(toppingX + toppingImage.width, pizza.x + pizza.pizzaBase.width);
    float toppingTop = max(toppingY, pizza.y);
    float toppingBottom = min(toppingY + toppingImage.height, pizza.y + pizza.pizzaBase.height);

    float overlapWidth = max(0, toppingRight - toppingLeft);
    float overlapHeight = max(0, toppingBottom - toppingTop);

    return overlapWidth * overlapHeight;
  }

  // Drop a topping onto the pizza and initiate drop animation
  void dropTopping(int toppingIndex) {
    // Set the position to the initial position stored during dragging
    x[toppingIndex] = initialX[toppingIndex];
    y[toppingIndex] = initialY[toppingIndex];

    // Update the display after dropping the topping
    displayToppings();

    // Initiate the drop animation
    animateDrop(toppingIndex, pizza.x, pizza.y);

    // Set the y position to 672 after dropping
    y[toppingIndex] = 672;
  }


  // Perform drop animation for a topping
  void animateDrop(int toppingIndex, float pizzaX, float pizzaY) {
    isAnimatingDrop = true; // Set the drop animation state to true
    dropAnimationSpeed = pizza.speed; // Set the animation speed

    while (x[toppingIndex] > pizzaX) {
      x[toppingIndex] -= pizza.speed;
      y[toppingIndex] += pizza.speed * (pizzaY - y[toppingIndex]) / (pizzaX - x[toppingIndex]);
      display(); // Update the display during the animation
    }

    x[toppingIndex] = pizza.x;
    y[toppingIndex] = 672;

    isAnimatingDrop = false; // Set the drop animation state to false after completing the animation
    if (!addedToppings.contains(toppingIndex)) {
      addedToppings.add(toppingIndex); // Mark the topping as added after the animation
    }
  }

  // Load toppings from file and store their paths
  PImage[] loadToppings(String[] toppingNames) {
    PImage[] toppings = new PImage[toppingNames.length];
    for (int i = 0; i < toppingNames.length; i++) {
      String imagePath = "Assets/Toppings/" + toppingNames[i];
      toppingPaths.add(imagePath); // Store the file path in toppingPaths ArrayList
      toppings[i] = loadImage(imagePath);
      toppings[i].resize(275, 0); // Resize as needed
    }
    return toppings;
  }
}
