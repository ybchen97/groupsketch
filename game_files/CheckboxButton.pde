class CheckboxButton {
  /*
  --How to use this class--
   
   Inside setup():
   CheckboxButton beginGame = CheckboxButton Button(x_coord, 
   y_coord, 
   width, 
   height, 
   "Begin Game", 
   32);
   
   
   */



  // class attributes
  float _x;
  float _y;
  float _width;
  float _height;
  String _name;
  
  PImage _imageUnpressed, _imagePressed;

  float _fontSize = (64 / 3.0) * displayDensity;
  boolean _isPressed = false;


  // class methods

  // constructor
  CheckboxButton(float tempX, 
                 float tempY, 
                 float tempWidth, 
                 float tempHeight, 
                 String textInput, 
                 PImage imgUnpressed, 
                 PImage imgPressed) {
    this._x = tempX;
    this._y = tempY;
    this._width = tempWidth;
    this._height = tempHeight;
    this._name = textInput;
    this._imageUnpressed = imgUnpressed;
    this._imagePressed = imgPressed;
  }

  // displays the CheckboxButton
  void display() {
    if (!_isPressed) {
      image(this._imageUnpressed, this._x, this._y, this._width, this._height);
    } else {
      image(this._imagePressed, this._x, this._y, this._width, this._height);
    }

    if (this.press() && !previousTouch) {
      if (!_isPressed) {
        _isPressed = true;
      } else {
        _isPressed = false;
      }
    }
  }

  // CheckboxButton press
  boolean press() {
    for (int i = 0; i < touches.length; i++) {
      if ((touches[i].x > this._x) && (touches[i].x < this._x + _width) && (touches[i].y > this._y) && (touches[i].y < this._y + _height)) {
        return true;
      } else {
        continue;
      }
    } 
    return false;
  }
  
  // returns state of checkboxButton
  boolean isPressed() {
    return _isPressed;
  }
  
  void unPress() {
    _isPressed = false;
  }
  
  void pressed() {
    _isPressed = true;
  }
}
