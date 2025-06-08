class Obstacle {
  int x, y, w, h;

  Obstacle (int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void show() {
    fill(128);
    image(obstree, x, y, w, h);
  }
}
