class Menu {

  PImage background; // Background image for the menu
  PImage[] menuButtons = new PImage[3]; // Array to store menu button images
  int screenWidth; // Width of the screen
  int screenHeight; // Height of the screen
  float canvasX; // X-coordinate for positioning the canvas
  float canvasY; // Y-coordinate for positioning the canvas
  final float buttonSpacing = 100; // Adjust the spacing between buttons
  float initialButtonX; // Initial X-coordinate for the buttons
  float initialButtonY; // Initial Y-coordinate for the buttons
  boolean[] isHovering = new boolean[3]; // Array to track hover state for each button
  int currentState = 0; // 0 for menu, 1 for game

  // Constructor initialises canvas position and loads assets
  Menu() {
    this.setCanvasPosition();
    this.loadAssets(); 
  }

  // Load background and menu button images
  void loadAssets() {
    size(980, 980);
    background = loadImage("Assets/Menu/MenuBackground.jpg");
    background.resize(width, height);
    loadMenuButtons();
  }

  // Load menu button images from files
  void loadMenuButtons() {
    String[] buttonFileNames = {"StartButton.png", "ScoreButton.png", "ExitButton.png"};

    for (int i = 0; i < menuButtons.length; i++) {
      menuButtons[i] = loadImage("Assets/Menu/" + buttonFileNames[i]);
      menuButtons[i].resize(156, 68);
    }
  }

  // Set the initial canvas position and button positions
  void setCanvasPosition() {
    screenWidth = displayWidth;
    screenHeight = displayHeight;

    // Calculate the position to centre the canvas
    canvasX = (screenWidth - width) / 2;
    canvasY = (screenHeight - height) / 11;
    surface.setLocation(int(canvasX), int(canvasY));

    // Set initial button positions
    initialButtonX = width / 2.7;
    initialButtonY = height / 2.75;
  }

  // Display the menu with background and buttons
  void display() {
    renderBackground();
    renderButtons();
  }

  // Check if the start button is pressed
  boolean checkMenuState() {
    // Check if the mouse is pressed
    if (mousePressed) {
      // Check if the mouse is over the first button
      if (isHovering[0]) {
        // Add your logic for the first button press
        return true;
      }
    }
    return false;
  }

  // Render the menu background
  void renderBackground() {
    float x = (width - background.width) / 2;
    float y = (height - background.height) / 2;
    image(background, x, y);
  }

  // Render and handle button interactions
  void renderButtons() {
    float buttonX = initialButtonX;
    float buttonY = initialButtonY;

    for (int i = 0; i < menuButtons.length; i++) {
      // Check if the cursor is over the button
      isHovering[i] = mouseX > buttonX && mouseX < buttonX + menuButtons[i].width &&
        mouseY > buttonY && mouseY < buttonY + menuButtons[i].height;

      // Adjust tint based on hover state
      tint(255, isHovering[i] ? 255 : 204);

      // Draw the button
      image(menuButtons[i], buttonX, buttonY);

      // Move Y position to the next button
      buttonY += buttonSpacing;
      buttonX += menuButtons[i].width / 2; // Move X position to the midway point of the current button

      // Reset tint for subsequent buttons
      tint(255, 255);
    }
  }

  // Handle mouse click events for menu buttons
  void mouseClicked() {
    for (int i = 0; i < menuButtons.length; i++) {
      // Check if the mouse is over the button
      boolean isButtonPressed = isHovering[i];

      // If the mouse is over the ExitButton, perform the exit event
      if (isButtonPressed && menuButtons[i] == menuButtons[2] || pizza.gameLost == true) {
        exitEvent();
      } else if (isButtonPressed && menuButtons[i] == menuButtons[1]) {
        scoreEvent();
      } else if (isButtonPressed && menuButtons[i] == menuButtons[0]) {
        startEvent();
      }
    }
  }

  // Set the current state to exit the program
  void exitEvent() {
    currentState = 3;
  }

  // Set the current state to display high scores
  void scoreEvent() {
    currentState = 2;
  }

  // Set the current state to start the game
  void startEvent() {
    currentState = 1; // Set the state to the game screen
  }
}
