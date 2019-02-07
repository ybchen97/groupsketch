class Button {
  /*
  --How to use this class--
  
  Inside setup():
  Button beginGame = new Button(x_coord, 
                                y_coord, 
                                width, 
                                height, 
                                "Begin Game", 
                                32);
  
  
  Inside draw():
  beginGame.display();
  
  if (beginGame.press()) {
    run code
  }
  */
  
  
  
  // class attributes
  float _x;
  float _y;
  float _width;
  float _height;
  String _name;
  float _fontSize = (64 / 3.0) * displayDensity;
  
  PImage _image;
  boolean _img = false;
  
  
  // class methods
  
  // constructor
  Button(float tempX, float tempY, float tempWidth, float tempHeight, String textInput) {
    this._x = tempX;
    this._y = tempY;
    this._width = tempWidth;
    this._height = tempHeight;
    this._name = textInput;
  }
  
  Button(float tempX, float tempY, float tempWidth, float tempHeight, String textInput, PImage img) {
    this._x = tempX;
    this._y = tempY;
    this._width = tempWidth;
    this._height = tempHeight;
    this._name = textInput;
    this._image = img;
    this._img = true;
  }
  
  // displays the button
  void display() {

    if (this._img) {
      image(this._image, this._x, this._y, this._width, this._height);
    } else {
      stroke(0);
      noFill();
      rect(this._x, this._y, this._width, this._height, height / 12);
      
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(_fontSize);
      text(this._name, this._x + this._width / 2, this._y + this._height / 2);
    }
    
  }
  
  // button press
  boolean press() {
    for (int i = 0; i < touches.length; i++) {
      if ((touches[i].x > this._x) && (touches[i].x < this._x + _width) && (touches[i].y > this._y) && (touches[i].y < this._y + _height)) {
        return true;
      } else {
        continue;
      }
    } return false;
  }
}

/*
// Function to check if touch is in the specified region aka button press
boolean isIn(int x, int y, int wid, int hei) {
  for (int i = 0; i < touches.length; i++) {
    if ((touches[i].x > x) && (touches[i].x < x + wid) && (touches[i].y > y) && (touches[i].y < y + hei)) {
      return true;
    } else {
      continue;
    }
  }
  return false;
}

*/
