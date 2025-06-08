class Candy {
  int x, y;
  int size_x = 150;
  int size_y = 50;
  float scale = 0.5;
  
  Candy(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void show() {
    image(candy, x, y, int(size_x*scale), int(size_y*scale));
  }
}
