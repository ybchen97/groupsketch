import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.content.Context;
import android.app.Activity;

int currentHighscore;

int score;

int surpriseFactor;


int[][][] screen;
int[][][] solution;
int[][][] submission;

int bWidth;
int bHeight;

color[] colors;
int currentColor;

int numberOfPlayers;

int initTime;
int finalTime;

int currentPlayer;

boolean previousTouch;

boolean gameInProgress;
boolean showInstructions;
boolean gameSettings;

boolean bufferScreen1; //Before showing design to Player 1
boolean designScreen;
boolean bufferScreen2; //Between showing design and Player 2
boolean drawScreen;
boolean bufferScreen3; //Between Player 2 and Player 3
boolean scoreScreen;

Button beginGame, bf_beginGame;
Button letsGo, surpriseMe, toolbarX;
Button instructions, bf_instructions;
Button returnToMenu;

int handlerX, handlerWidth;
int handlerY, handlerHeight;

CheckboxButton oneColor, twoColor, threeColor, fourColor, fiveColor;
CheckboxButton[] buttonArray;

PImage observer, redArtist, greenArtist, blueArtist, yellowArtist;
PImage[] spriteArray;
PImage instructionsImage;
PImage logoImage;
PImage highscoreImage;

void settings() {
  fullScreen();
}

void setup() {

  textAlign(CENTER, CENTER);

  surpriseFactor = 1;

  currentHighscore = 0;
  currentHighscore = loadInt("highscore");

  score = 0;
  numberOfPlayers = 2;
  initTime = 0;
  finalTime = 0;
  currentPlayer = 0;
  previousTouch = false;
  gameInProgress = false;
  showInstructions = false;
  gameSettings = false;

  bufferScreen1 = false;
  designScreen = false;
  bufferScreen2 = false;
  drawScreen = false;  
  bufferScreen3 = false;
  scoreScreen = false;

  bWidth = int(width / 40);
  bHeight = int(height / 40);

  println("Number of Squares: " + bWidth * bHeight);

  screen = new int[bHeight][bWidth][5];
  solution = new int[bHeight][bWidth][5];
  submission = new int[bHeight][bWidth][5];

  cleanScreen(screen);
  cleanScreen(solution);
  cleanScreen(submission);

  colors = new color[5];

  colors[0] = #ffffff;
  colors[1] = #2b8a1c;
  colors[2] = #efef59;
  colors[3] = #0054a6;
  colors[4] = #db0e30;

  currentHighscore = 0;
  currentHighscore = loadInt("highscore");

  // Buttons
  instructions = new Button(2 * width / 10, 23 * height / 40, 6 * width / 10, height / 20, "Instructions", loadImage("instructions.png"));
  bf_instructions = new Button(2 * width / 10, 31 * height / 40, 6 * width / 10, height / 20, "Main Menu", loadImage("main_menu.png"));

  beginGame = new Button(2 * width / 10, 27 * height / 40, 6 * width / 10, height / 20, "Begin Game", loadImage("start.png"));
  bf_beginGame = new Button(2 * width / 10, 33 * height / 40, 6 * width / 10, height / 20, "Main Menu", loadImage("main_menu.png"));

  highscoreImage = loadImage("highscore.png");

  // color selection handler
  handlerX = 3 * width / 18;
  handlerWidth = 12 * width / 18;
  handlerY = 13 * height / 40;
  handlerHeight = 3 * height / 36;

  // checkboxbuttons for color selection
  oneColor = new CheckboxButton(3 * width / 18, 
    13 * height / 40, 
    handlerWidth / 4, 
    handlerHeight, 
    "1", 
    loadImage("one_color_unpressed.png"), 
    loadImage("one_color_pressed.png"));

  // as default setting
  oneColor.pressed();

  twoColor = new CheckboxButton(6 * width / 18, 
    13 * height / 40, 
    handlerWidth / 4, 
    handlerHeight, 
    "2", 
    loadImage("two_color_unpressed.png"), 
    loadImage("two_color_pressed.png"));

  threeColor = new CheckboxButton(9 * width / 18, 
    13 * height / 40, 
    handlerWidth / 4, 
    handlerHeight, 
    "3", 
    loadImage("three_color_unpressed.png"), 
    loadImage("three_color_pressed.png"));

  fourColor = new CheckboxButton(12 * width / 18, 
    13 * height / 40, 
    handlerWidth / 4, 
    handlerHeight, 
    "4", 
    loadImage("four_color_unpressed.png"), 
    loadImage("four_color_pressed.png"));

  buttonArray = new CheckboxButton[]{oneColor, 
    twoColor, 
    threeColor, 
    fourColor};

  // surpriseMe Button to include RNG elements and start game when pressed
  surpriseMe = new Button(2 * width / 10, 22 * height / 40, 6 * width / 10, height / 20, "Surprise Me ;)", loadImage("surprise_me.png"));
  letsGo = new Button(2 * width / 10, 30 * height / 40, 6 * width / 10, height / 20, "LET'S GO!", loadImage("lets_go.png"));
  toolbarX = new Button(width / 20, 1.5 * height / 40, width/ 20, height / 40, "X", loadImage("toolbar_x.png"));
  returnToMenu = new Button (2 * width / 10, 33 * height / 40, 6 * width / 10, height / 20, "Main Menu", loadImage("main_menu.png"));

  // sprites
  observer = loadImage("observer.png");
  redArtist = loadImage("red_artist.png");
  greenArtist = loadImage("green_artist.png");
  blueArtist = loadImage("blue_artist.png");
  yellowArtist = loadImage("yellow_artist.png");
  spriteArray = new PImage[]{greenArtist, yellowArtist, blueArtist, redArtist};

  // Instructions & Logo
  instructionsImage = loadImage("instructions_image.png");
  logoImage = loadImage("logo.jpg");
}

void draw() {
  if (!gameInProgress) {
    // "Index" page
    displayIndex();

    // "Instructions" page
    if (showInstructions) {
      displayInstructions();
    } 

    // If "Begin game" is pressed
    else if (beginGame.press() && !previousTouch) {
      gameInProgress = true;
      gameSettings = true;
    }
  } 



  // Game logic. Player selection page. "playerSelection" is set to true from above
  else {
    if (gameSettings) {
      displayGameSettings();
    } 

    // playerSelection set to false, bufferScreen1 set to true
    else if (bufferScreen1) {
      displayBufferScreen1();
    } else if (designScreen) {
      displayDesignScreen();
    } else if (bufferScreen2) {
      displayBufferScreen2();
    } else if (drawScreen) {
      displayDrawScreen();
    } else if (scoreScreen) {
      displayScoreScreen();
    }
  }

  if (touchIsStarted) {
    previousTouch = true;
  } else {
    previousTouch = false;
  }
}

void displayIndex() {
  // println(initTime);
  background(255);

  // Logo and Highscore boxes
  noFill();
  //rect(3 * width / 10, height / 5, 4 * width / 10, height / 5);
  //rect(3 * width / 10, 19 * height / 40, 4 * width / 10, height / 20);
  imageMode(CORNER);
  fill(0);
  image(logoImage, 0.192 * width, 0.1 * height, 0.617 * width, 0.3 * height);
  textSize(64 / 3.0 * displayDensity);

  imageMode(CENTER);

  image(highscoreImage, width / 2, 4.5 * height / 10, 6 * width / 10, height / 20);
  textSize(72 / 3.0 * displayDensity);
  text(currentHighscore, width / 2, 5.2 * height / 10);
  imageMode(CORNER);

  // Buttons
  instructions.display();
  beginGame.display();


  // if "Instructions" button is pressed
  if (instructions.press() && !previousTouch) {
    showInstructions = true;
  }
}

void displayInstructions() { 
  background(255);

  fill(0);
  image(instructionsImage, 0, 0.03 * height, width, 0.7 * height);

  bf_instructions.display();

  // If "Back to Main Menu" button is pressed
  if (bf_instructions.press() && !previousTouch) {
    showInstructions = false;
  } 

  // If "Begin game" is pressed
  else if (beginGame.press() && !previousTouch) {
    gameInProgress = true;
    gameSettings = true;
  }
}

void displayGameSettings() {
  background(255);

  // "Game Settings"
  textAlign(CENTER, CENTER);
  textSize((120 / 3.0) * displayDensity);
  text("Game Settings", width / 2, 5 * height / 40);  

  // "Choose number of Colors" text display
  textSize((80 / 3.0) * displayDensity);
  text("Choose number of Colors", width / 2, 10 * height / 40);

  oneColor.display();
  twoColor.display();
  threeColor.display();
  fourColor.display();
  surpriseMe.display();
  letsGo.display();

  // checkbox handling and setting numberOfPlayers variable
  // function to handle color selection
  if (handlerIsPressed() && !previousTouch) {
    println("inside handler");
    // find which button the current touch belongs to
    int currentOption = 0;
    for (int i = 0; i < buttonArray.length; i++) {
      if (buttonArray[i].press()) {
        println("inside press");
        currentOption = i;
        numberOfPlayers = i + 2;
        break;
      }
    }

    // set all other buttons to unpressed
    for (int i = 0; i < buttonArray.length; i++) {
      if (i == currentOption) {
        continue;
      } else {
        buttonArray[i].unPress();
      }
    }
  }

  if (surpriseMe.press() && !previousTouch) {
    surpriseFactor = 3;
    numberOfPlayers = 5;
    gameSettings = false;
    bufferScreen1 = true;
    initTime = millis();
  }

  if (letsGo.press() && !previousTouch) {
    gameSettings = false;
    bufferScreen1 = true;
    initTime = millis();
  }

  bf_beginGame.display();

  if (bf_beginGame.press() && !previousTouch) {
    setup();
  }
}

void displayBufferScreen1() {
  finalTime = initTime + 5000; //Screen will be shown for 5 seconds

  if (millis() < finalTime) {
    noStroke();
    background(255);


    fill(#E3D7FF);

    ellipse(width / 2, height / 3, width / 2 + cos(float(millis()) / 200) * width / 5, width / 2 + cos(float(millis()) / 200) * width / 5);

    fill(#7A89C2);

    ellipse(width / 2, height / 3, width / 5 + sin(float(millis()) / 200) * width / 12, width / 5 + sin(float(millis()) / 200) * width / 12);

    fill(0);
    textSize(96 / 3.0 * displayDensity);

    text("Loading...", width / 2, 12 * height / 20);

    textSize(64 / 3.0 * displayDensity);

    fill(#87ceeb);
    rect(width / 6, 3.25 * height / 5, 2 * width / 3, height / 12, height / 12);
    fill(0);
    text("Pass phone to observers!", width / 2, 16.6 * height / 24);

    float sprite_x = 300 * cos((float(millis() - initTime)) / 1000) + width / 2;
    float sprite_y = 300 * sin((float(millis() - initTime)) / 1000) + height / 3;

    imageMode(CENTER);
    image(observer, sprite_x, sprite_y, width / 5, height / 10);

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + TAU / 5) + height / 3;

    image(redArtist, sprite_x, sprite_y, width / 5, height / 10);    

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 2 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 2 * TAU / 5) + height / 3;

    image(greenArtist, sprite_x, sprite_y, width / 5, height / 10);  

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 3 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 3 * TAU / 5) + height / 3;

    image(yellowArtist, sprite_x, sprite_y, width / 5, height / 10);  

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 4 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 4 * TAU / 5) + height / 3;

    image(blueArtist, sprite_x, sprite_y, width / 5, height / 10);

    currentPlayer = 1;

    toolbarX.display();
    if (toolbarX.press() && !previousTouch) {
      setup();
    }
  } else {
    bufferScreen1 = false;
    designScreen = true;
    initTime = millis();
    generateDesign(solution);
  }
}

void displayDesignScreen() {
  finalTime = initTime + 5000; //Design will be shown for 5 seconds
  stroke(1);

  if (millis() < finalTime) {
    background(255);
    fill(0);
    // text("GENERATED DESIGN WILL BE SHOWN NOW", width / 2, height / 2);
    drawToScreen(solution);

    // toolbar rectangle
    fill(255);
    rect(0, 0, width, int(float(bHeight) / 10) * 40 + 40);

    // toolbarX button
    toolbarX.display();

    // observer sprite
    imageMode(CORNER);
    image(observer, 18 * width / 20  - width * (millis() - initTime) / 5000, 0, width / 6, height / 12);

    // progress bar
    fill(lerpColor(#00ff00, #ff0000, (float(millis()) - float(initTime)) / 5000));
    rect(0, int(float(bHeight) / 10) * 40, width - width * (millis() - initTime) / 5000, 40);

    if (toolbarX.press() && !previousTouch) {
      setup();
    }
  } else {
    designScreen = false;
    bufferScreen2 = true;
    initTime = millis();
  }
}

void displayBufferScreen2() {
  finalTime = initTime + 5000; //Screen will be shown for 5 seconds

  if (millis() < finalTime) {
    noStroke();
    background(255);


    fill(#E3D7FF);

    ellipse(width / 2, height / 3, width / 2 + cos(float(millis()) / 200) * width / 5, width / 2 + cos(float(millis()) / 200) * width / 5);

    fill(#7A89C2);

    ellipse(width / 2, height / 3, width / 5 + sin(float(millis()) / 200) * width / 12, width / 5 + sin(float(millis()) / 200) * width / 12);

    fill(0);
    textSize(96 / 3.0 * displayDensity);

    text("Loading...", width / 2, 12 * height / 20);

    textSize(64 / 3.0 * displayDensity);

    fill(#87ceeb);
    rect(width / 6, 3.25 * height / 5, 2 * width / 3, height / 12, height / 12);
    fill(0);
    text("Pass phone to drawers!", width / 2, 16.6 * height / 24);

    float sprite_x = 300 * cos((float(millis() - initTime)) / 1000) + width / 2;
    float sprite_y = 300 * sin((float(millis() - initTime)) / 1000) + height / 3;

    imageMode(CENTER);
    image(observer, sprite_x, sprite_y, width / 5, height / 10);

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + TAU / 5) + height / 3;

    image(redArtist, sprite_x, sprite_y, width / 5, height / 10);    

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 2 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 2 * TAU / 5) + height / 3;

    image(greenArtist, sprite_x, sprite_y, width / 5, height / 10);  

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 3 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 3 * TAU / 5) + height / 3;

    image(yellowArtist, sprite_x, sprite_y, width / 5, height / 10);  

    sprite_x = 300 * cos((float(millis() - initTime)) / 1000 + 4 * TAU / 5) + width / 2;
    sprite_y = 300 * sin((float(millis() - initTime)) / 1000 + 4 * TAU / 5) + height / 3;

    image(blueArtist, sprite_x, sprite_y, width / 5, height / 10);
    //strokeWeight(10);

    toolbarX.display();
    if (toolbarX.press() && !previousTouch) {
      setup();
    }
  } else {
    bufferScreen2 = false;
    drawScreen = true;
    initTime = millis();
    currentPlayer = 2;
    background(255);
    finalTime = initTime + 15000;
    stroke(1);
    drawToScreen(submission);
    imageMode(CORNER);
  }
}

void displayDrawScreen() {
  if (currentPlayer <= numberOfPlayers) {
    if (millis() < finalTime) {
      fill(0);
      //text("Player " + currentPlayer, width / 2, height / 2); //To be removed
      // Drawing mechanism activated

      drawingMechanism(submission);
      fill(255);
      rect(0, 0, width, int(float(bHeight) / 10) * 40 + 40);
      fill(lerpColor(#00ff00, #ff0000, (float(millis()) - float(initTime)) / 15000));
      //fill(colors[currentPlayer - 1]);
      rect(0, int(float(bHeight) / 10) * 40, width - width * (millis() - initTime) / 15000, 40);
      //} else if ((millis() < finalTime) && (currentPlayer < numberOfPlayers)) {
      // Drawing mechanism deactivated
      //background(255); //To be removed
      //fill(0);
      //text("Pass phone to player " + (currentPlayer + 1), width / 2, height / 2);

      // 
      toolbarX.display();
      // sprite manager
      image(spriteArray[currentPlayer - 2], 18 * width / 20  - width * (millis() - initTime) / 15000, 0, width / 6, height / 12);

      if (toolbarX.press() && !previousTouch) {
        setup();
      }
    } else {
      initTime = millis();
      currentPlayer++;
      finalTime = initTime + 15000;
    }
  } else {
    //Score and compare
    drawScreen = false;
    scoreScreen = true;
    score(solution, submission);
    if ((int(float(score) / float((bWidth * bHeight)) * 1000)) * (numberOfPlayers - 1) * surpriseFactor > currentHighscore) {
      saveInt((int(float(score) / float((bWidth * bHeight)) * 1000)) * (numberOfPlayers - 1) * surpriseFactor, "highscore");
    }
    currentHighscore = loadInt("highscore");
  }
}

// displayScoreScreen()
void displayScoreScreen() {
  background(255);

  image(logoImage, 0.192 * width, 0.2 * height, 0.617 * width, 0.3 * height);

  noStroke();
  fill(0);
  //text("Score: " + float(int(float(score) / float((bWidth * bHeight)) * 1000)) / 10 + "%", width / 2, height / 2);

  textSize(96 / 3.0 * displayDensity);
  text("Score: " + int(float(score) / float((bWidth * bHeight)) * 1000) * (numberOfPlayers - 1) * surpriseFactor, width / 2, 6 * height / 10);

  textSize(48 / 3.0 * displayDensity);
  //text("High score: " + currentHighscore, width / 2, height / 3);


  fill(#8b8989);
  text("I would use my S/U\non this if I were you", width / 2, 81.5 * height / 120);

  returnToMenu.display();
  if (returnToMenu.press() && !previousTouch) {
    setup();
  }
}


void cleanScreen(int[][][] toBeCleaned) {
  for (int i = 0; i < bHeight; i++) {
    for (int j = 0; j < bWidth; j++) {
      currentColor = int(random(0, 6));
      for (int k = 0; k < 5; k++) {
        if (k == 0) {
          toBeCleaned[i][j][k] = 1;
        } else {
          toBeCleaned[i][j][k] = 0;
        }
      }
    }
  }
}

void generateDesign(int[][][] toBeDesigned) {
  println(numberOfPlayers);
  for (int i = 0; i < bHeight; i++) {
    if (i > float(bHeight) / 10) {
      for (int j = 0; j < bWidth; j++) {
        if (surpriseFactor != 3) {
          currentColor = int(map(noise(i / 10, j / 10), 0.15, 0.9, 0, numberOfPlayers));
        } else {
          currentColor = int(random(5));
        }
        println("Current Color: " + currentColor);
        for (int k = 0; k < 5; k++) {
          if (currentColor == k) {
            for (int l = 0; l < 5; l++) {
              toBeDesigned[i][j][l] = 0;
              if (l == k) {
                toBeDesigned[i][j][l] = 1;
              }
            }
          }
        }
      }
    }
  }
}

void drawToScreen(int [][][] toBeDrawn) {
  for (int i = 0; i < bHeight; i++) {
    for (int j = 0; j < bWidth; j++) {
      for (int k = 0; k < 5; k++) {
        if (toBeDrawn[i][j][k] == 1) {
          fill(colors[k]);
        }
      }
      rect(j * 40, i * 40, 40, 40);
    }
  }
}

void drawingMechanism(int[][][] screen) {

  int minimumY = int(float(bHeight) / 10) * 40 + 80;
  for (int finger = 0; finger < touches.length; finger++) {
    if ((touches[finger].x < width - 40) && (touches[finger].y < height - 40) && (touches[finger].x > 40) && (touches[finger].y > minimumY)) {
      int grid_x = int(touches[finger].x / 40) * 40;
      int grid_y = int(touches[finger].y / 40) * 40;

      for (int y = -1; y < 2; y++) {
        for (int x = -1; x < 2; x++) {

          fill(colors[currentPlayer - 1]);
          rect(grid_x + x * 40, grid_y + y * 40, 40, 40);
          //fill(colors[currentColor]);
          //rect(grid_x + x, grid_y + y, 40, 40);

          int[] gridColor = new int[5];
          gridColor[currentPlayer - 1] = 1;
          screen[int(touches[finger].y / 40) + y][int(touches[finger].x / 40) + x] = gridColor;
        }
      }
    }
  }
}



void score(int[][][] solution, int[][][] submission) {
  for (int i = 0; i < bHeight; i++) {
    for (int j = 0; j < bWidth; j++) {
      boolean increScore = true;
      for (int k = 0; k < 5; k++) {
        if (solution[i][j][k] != submission[i][j][k]) {
          increScore = false;
        }
      }
      if (increScore) {
        score++;
      }
    }
  }
}

boolean handlerIsPressed() {
  if (touchIsStarted) {
    if (((touches[0].x > handlerX) && (touches[0].x < handlerX + handlerWidth)) && 
      ((touches[0].y > handlerY) && (touches[0].y < handlerY + handlerHeight))) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}


// Highscore stuff
void saveInt(int _score_, String name) {
  SharedPreferences sharedPreferences;
  SharedPreferences.Editor editor;
  Activity act;
  act = this.getActivity();
  sharedPreferences = PreferenceManager.getDefaultSharedPreferences(act.getApplicationContext());
  editor = sharedPreferences.edit();
  editor.putInt(name, _score_);
  editor.commit();
}

int loadInt(String name) {
  SharedPreferences sharedPreferences;
  Activity act;
  act = this.getActivity();
  sharedPreferences = PreferenceManager.getDefaultSharedPreferences(act.getApplicationContext());
  int getScore = sharedPreferences.getInt(name, 0);
  return getScore;
}
