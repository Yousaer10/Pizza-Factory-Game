// Members
Menu menu;
Pizza pizza;
ConveyorBelt conveyor;
Topping topping;
Scoreboard scoreBoard;
PizzaBox pizzaBox;
boolean isAdded = false;
ArrayList<Rat> ratList = new ArrayList<>();
boolean ratCollided = false;

// Setup method - initialises the program
void setup() {
  size(980, 980); // Set the canvas size
  menu = new Menu(); // Initialise Menu instance
  scoreBoard = new Scoreboard(); // Initialise Scoreboard instance
  conveyor = new ConveyorBelt(400, 0, 1.5); // Initialise ConveyorBelt instance
  pizza = new Pizza(displayWidth, 672, 1.5, scoreBoard, conveyor); // Initialise Pizza instance
  topping = new Topping(scoreBoard, pizza); // Initialise Topping instance
  pizzaBox = new PizzaBox(displayWidth/2, 480); // Initialise PizzaBox instance
  
  // Create one Rat instance and add it to the ratList
  for (int i = 0; i < 1; i++) {
    int randomY = (int) random(300, height-400);
    ratList.add(new Rat(0, randomY, 1.5));
  }
}

// Draw method - called continuously to render the program
void draw() {
  // Menu state 0: Display menu
  if (menu.currentState == 0) {
    background(255); // Clear the background
    menu.display(); // Render the menu
  } 
  // Menu state 1: Gameplay
  else if (menu.currentState == 1) {
    background(0); // Clear the background
    conveyor.render();
    imageMode(CORNER);
    pizza.display();
    pizza.move(); // Move the pizza first
    topping.display();
    scoreBoard.display();
    
    // Loop through each Rat in ratList
    for (Rat currentRat : ratList) {
      currentRat.display();
      currentRat.move();

      // Check if the mouse is over a Rat
      if (mouseX > currentRat.x && mouseX < currentRat.x + currentRat.ratImages[0].width &&
          mouseY > currentRat.y && mouseY < currentRat.y + currentRat.ratImages[0].height) {
        ratCollided = true;
      }
    }

    // Handle game over when a collision with a Rat occurs
    if (ratCollided) {
      pizza.gameOver();
    }

    topping.drag();

    // Handle topping drop
    if (topping.drop()) {
      int droppedIndex = topping.draggingIndex;
      int updatedObjective = topping.updateToppings();
      pizza.updateAppearance(updatedObjective, droppedIndex);
      topping.animateDrop(droppedIndex, pizza.x + pizza.pizzaBase.width / 2, pizza.y + pizza.pizzaBase.height / 2);
      isAdded = true;
    }

    // Move toppings after they are added
    if (isAdded) {
      topping.move();
    }

    // Display pizza box when game is won
    if (isGameWon()) {
      pizzaBox.display();
    }

    // Handle game over when pizza loses all toppings
    if (pizza.gameLost) {
      pizza.gameOver();
    }
  } 
  // Menu state 2: High Scores
  else if (menu.currentState == 2) {
    // Display highest scores
    if (!scoreBoard.isDisplayed) {
      scoreBoard.displayHighestScores();
      scoreBoard.isDisplayed = true;
    }
  } 
  // Menu state 3: Exit
  else if (menu.currentState == 3) {
    exit();
  }
}

// Check if the game is lost
boolean isGameLost() {
  return topping.addedToppings.size() < 3;
}

// Handle game lost
void gameLost() {
  pizza.gameOver();
  ratCollided = true;
}

// Check if the game is won
boolean isGameWon() {
  return topping.addedToppings.size() >= 3;
}

// Handle game won
void gameWon() {
  topping.addedToppings.clear();
  topping.changeObjective();
  topping.setPosition();
  pizzaBox.resetPosition();
}


void mouseClicked() {
  menu.mouseClicked(); // Call the mouseClicked method in the Menu class
  
  // Handle canvas resize based on menu state
  if (menu.currentState == 1) {
    background(0);
    windowResize(displayWidth, 972);
    menu.setCanvasPosition();
  } else if (menu.currentState == 2) {
    background(0);
    windowResize(980, 980);
    menu.setCanvasPosition();
  }
}

// Handle key presses (arrow keys for pizza box rotation)
void keyPressed() {
  if (keyCode == RIGHT) {
    pizzaBox.rotateClockwise();
  } else if (keyCode == LEFT) {
    pizzaBox.rotateCounterClockwise();
  }
}


void mousePressed() {
  if (mouseX > pizzaBox.x - pizzaBox.size / 2 && mouseX < pizzaBox.x + pizzaBox.size / 2 &&
      mouseY > pizzaBox.y - pizzaBox.size / 2 && mouseY < pizzaBox.y + pizzaBox.size / 2) {
    pizzaBox.startDragging(); // Start dragging the pizza box
  }
}

// Handle mouse drag (update pizza box position)
void mouseDragged() {
  if (pizzaBox.isDragging) {
    pizzaBox.updateDragging(mouseX, mouseY);
  }
}


void mouseReleased() {
  if (pizzaBox.isDragging) {
    pizzaBox.stopDragging(); // Stop dragging the pizza box
  }
}
