class Scoreboard {
  int score; // Current score
  int highScore; // Highest achieved score
  boolean isScoreSaved = false; //Indicate if the score is saved
  boolean isDisplayed = false; // Indicate if the scoreboard is displayed

  // Constructor initialises the score and loads assets
  Scoreboard() {
    this.score = 0;
    this.loadAssets();
  }

  // Display the score if the game is not lost
  void display() {
    if (!pizza.gameLost) {
      fill(255);
      textSize(50);
      text("Score:  " + score, 25, 125);
    }
  }

  // Increase the score by 10
  void calculateScore() {
    score = score + 10;
  }

  // Increase the score by 30 as a bonus
  void bonusScore() {
    score = score + 30;
  }

  // Save the current score as the high score
  void saveHighScore(int score) {
    // Save high score to a file
    this.highScore = score;

    // Read existing scores from the file
    String[] lines = loadStrings("Assets/Scoreboard/scoreboard.txt");
    int[] numbers = convertArrayStrToInt(lines);

    // Insert the new score
    numbers = insertNumberToArray(numbers, score);

    // Convert the updated array back to strings
    lines = convertArrayIntToStr(numbers);

    // Save the updated scores back to the file
    saveStrings("Assets/Scoreboard/scoreboard.txt", lines);
  }

  // Display the top 10 highest scores
  void displayHighestScores() {
    // Read existing scores from the file
    String[] lines = loadStrings("Assets/Scoreboard/scoreboard.txt");
    int[] numbers = convertArrayStrToInt(lines);

    // Ensure that the array is sorted in descending order (highest to lowest)
    int[] reversedNumbers = new int[numbers.length];
    for (int i = 0; i < numbers.length; i++) {
      reversedNumbers[i] = numbers[numbers.length - i - 1];
    }
    numbers = reversedNumbers;

    // Reverse the array to get it in descending order
    for (int i = 0; i < numbers.length / 2; i++) {
      int temp = numbers[i];
      numbers[i] = numbers[numbers.length - i - 1];
      numbers[numbers.length - i - 1] = temp;
    }
    // Set text alignment to CENTER
    textAlign(CENTER, CENTER);
    
    // Print the top 10 highest scores
    int count = Math.min(10, numbers.length); // Ensure we don't go beyond the array size
    fill(255);
    textSize(60);
    text("Top 10 High Scores", width / 2, 150);
    for (int i = 0; i < count; i++) {
      fill(255);
      textSize(50);
      // Adjust the position based on the canvas width and height
      float x = width / 2;
      float y = 240 + i * 60; // Adjust the spacing as needed
      text("Top #" + (i + 1) + " : " + numbers[i], x, y);
    }
  }

  // Load assets, attempt to load existing scores from the file
  void loadAssets() {
    String[] lines = loadStrings("Assets/Scoreboard/scoreboard.txt");

    // If the file doesn't exist or is empty, initialise it with a default value
    if (lines.length == 0) {
      int[] numbers = {11};
      lines = convertArrayIntToStr(numbers);
      saveStrings("Assets/Scoreboard/scoreboard.txt", lines);
    }
  }

  // Convert integer array to string array
  String[] convertArrayIntToStr(int[] arrayInt) {
    String[] output = new String[arrayInt.length];
    for (int i = 0; i < arrayInt.length; i++)
      output[i] = Integer.toString(arrayInt[i]);
    return output;
  }

  // Insert a number into an array, maintaining descending order
  int[] insertNumberToArray(int[] intArray, int number) {
    int[] newIntArray = new int[intArray.length + 1];
    int i = 0;
    while (i < intArray.length && number < intArray[i]) {
      newIntArray[i] = intArray[i];
      i++;
    }
    newIntArray[i] = number;
    for (int j = i; j < intArray.length; j++)
      newIntArray[j + 1] = intArray[j];
    return newIntArray;
  }

  // Convert string array to integer array
  int[] convertArrayStrToInt(String[] stringArray) {
    int[] intArray = new int[stringArray.length];
    for (int i = 0; i < stringArray.length; i++)
      intArray[i] = Integer.parseInt(stringArray[i]);
    return intArray;
  }
}
