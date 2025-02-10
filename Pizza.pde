class Pizza implements DifficultyListener { //<>//

  float x; // X-coordinate of the pizza
  int y; // Y-coordinate of the pizza
  PImage pizzaBase; // Image for the pizza base
  PImage gameOver; // Image for the game over screen
  boolean initialAppearanceChecked = false; // Track whether the initial appearance check has been performed
  boolean isDifficultyIncreased = false; // Track if difficulty has increased
  boolean gameLost; // Track if the game is lost
  Topping topping; // Topping object for managing toppings on the pizza
  Scoreboard scoreBoard; // Scoreboard object for managing scores
  DifficultyListener difficultyListener; // DifficultyListener for handling difficulty changes
  float speed; // Store the speed of the pizza movement

  // Constructor for Pizza class
  Pizza(int x, int y, float speed, Scoreboard scoreBoard, DifficultyListener difficultyListener) {
    this.x = x;
    this.y = y;
    this.speed = speed;  // Initialise the speed variable
    this.loadAssets();
    this.topping = new Topping(scoreBoard, this);
    this.scoreBoard = scoreBoard;
    this.difficultyListener = difficultyListener;
  }

  // Load pizza and game over screen images
  void loadAssets() {
    pizzaBase = loadImage("Assets/PizzaBase.png");
    pizzaBase.resize(300, 0);
    gameOver = loadImage("Assets/Game Over/game_over.gif");
    gameOver.resize(displayWidth, 972);
  }

  // Display method for rendering the pizza
  void display() {
    // Check if the initial appearance has been checked
    if (initialAppearanceChecked == false) {
      image(pizzaBase, x, y);
    } else if (isGameLost()) {
      gameLost();
      initialAppearanceChecked = true;
    } else if (isGameWon()) {
      gameWon();
      initialAppearanceChecked = false;
    }
  }

  // DifficultyListener method to handle difficulty increase
  @Override
  public void onDifficultyIncreased() {
    increaseDifficulty();
  }

  // Method to increase the game difficulty
  void increaseDifficulty() {
    isDifficultyIncreased = true; // Set the shared variable to true
    speed += 0.5;
  }

  // Move method for updating pizza position
  void move() {
    this.x -= speed;

    if (this.x < -300) {
      if (isGameWon()) {
        onDifficultyIncreased();
        gameWon();
        initialAppearanceChecked = false;
        this.x = displayWidth;
      } else if (initialAppearanceChecked == false) {
        if (isGameLost()) {
          gameLost();
        }

        initialAppearanceChecked = true;
        isDifficultyIncreased = false;
      }
    }
  }

  // Game over method for handling the end of the game
  void gameOver() {
    float xCentre = width / 2.0; // Calculate the x-coordinate at the centre of the screen
    float yCentre = height / 2.0; // Calculate the y-coordinate at the centre of the screen

    imageMode(CENTER); // Set image mode to CENTER
    image(gameOver, xCentre, yCentre); // Display the "gameOver" image at the centre of the screen
    
    // Ensure that scoreBoard is not null before calling its methods
    if (scoreBoard != null && scoreBoard.isScoreSaved == false) {
      scoreBoard.saveHighScore(scoreBoard.score);
      scoreBoard.isScoreSaved = true;
    } else {
      println("Error: scoreBoard is null");
    }
    gameLost = true;
  }

  // Update appearance method for updating pizza toppings
  void updateAppearance(int randomObjective, int droppedIndex) {
    // Set the random objective in the Pizza class
    this.topping.randomObjective = randomObjective;

    topping.updateToppings();

    for (int i = 0; i < topping.selectedToppings.length; i++) {
      if (i == droppedIndex) {
        // Display the centred image only for the dropped topping
        float xPizzaCentre = this.x + this.pizzaBase.width / 2.0;
        float yPizzaCentre = this.y + this.pizzaBase.height / 2.0;

        // Calculate the position of the dropped topping relative to the pizza centre
        float xOffset = xPizzaCentre - topping.selectedToppings[i].width / 2.0;
        float yOffset = yPizzaCentre - topping.selectedToppings[i].height / 2.0;

        // Update the position of the dropped topping based on the pizza's movement
        float newX = this.x + xOffset;
        float newY = this.y + yOffset;

        image(topping.selectedToppings[i], newX, newY);
      }
    }
  }
}
