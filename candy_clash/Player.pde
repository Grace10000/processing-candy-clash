class Player {
  int x, y, w, h;
  int left, right, top, bottom;
  int leftkey, rightkey, upkey, downkey;
  boolean move_down, move_up, move_left, move_right;
  
  int i = 0;
  int direction = 1;
  
  Player(int start_x, int start_y, int start_w, int start_h, int key_left, int key_right, int key_up, int key_down){
    x = start_x;
    y = start_y;
    w = start_w;
    h = start_h;
    
    leftkey = key_left;
    rightkey = key_right;
    upkey = key_up;
    downkey = key_down;
    
    bound();
  }
  
  void bound(){  
    left = x - w / 2;
    right = x + w / 2;
    top = y - h / 2;
    bottom = y + h / 2;
  }
  
  void give(PImage role){
    image(role, x, y, w, h, 32*i, 48*(direction-1), 32*(i+1), 48*direction);
    if (move_down || move_up || move_left || move_right) {
      i++;
      if (i > 3) i = 0;
    }
    
    point(x+w/2,y+h/2);
  }
  
  void move() {
    if (!gameRunning) return;  // 遊戲結束後，人物無法移動
    
    if (move_down && !checkCollisionInDirection(1)) {
        y += speed;
        if (y > height-96) y = height-96;  // 確保 y 不大於 150
    }
    if (move_up && !checkCollisionInDirection(4)) {
        y -= speed;
        if (y < 150) y = 150;  // 確保 y 不小於 頂部
    }
    if (move_left && !checkCollisionInDirection(2)) {
        x -= speed;
        if (x < -30) x = width + 50; // 若從左邊消失則回到右邊
    }
    if (move_right && !checkCollisionInDirection(3)) {
        x += speed;
        if (x + w > width+30) x = -50; // 若從右邊消失則回到左邊
    }
    bound();  
  }
  
  void setDirection(int key_dir) {
    move_down = move_up = move_left = move_right = false;  // 使不能同時往兩個方向移動
    
    direction = key_dir;
    if (key_dir == downkey) {
      move_down = true;
      direction = 1;
    } 
    if (key_dir == leftkey) {
      move_left = true;
      direction = 2;
    } 
    if (key_dir == rightkey) {
      move_right = true;
      direction = 3;
    } 
    if (key_dir == upkey) {
      move_up = true;
      direction = 4;
    } 
  }
  
  void stop() {
    move_down = move_up = move_left = move_right = false;
  }
  
  boolean checkCollision(Obstacle r) {  
    int shrink = 20; // 縮小判定範圍
    return (x < r.x + r.w - shrink && x + w > r.x + shrink &&
            y < r.y + r.h - shrink && y + h > r.y + shrink);
  }

  boolean checkCollisionInDirection(int dir) {
    int shrink = 20;
    for (Obstacle r : obstacles) {
        if (abs(r.x - x) > 200 || abs(r.y - y) > 200) continue;  // 若角色離障礙物過遠，跳過檢查該障礙物
        if (dir == 1 && (y + h + speed > r.y + shrink && y < r.y + r.h - shrink) &&
            (x + w > r.x + shrink && x < r.x + r.w - shrink)) return true;
        if (dir == 4 && (y - speed < r.y + r.h - shrink && y > r.y + shrink) &&
            (x + w > r.x + shrink && x < r.x + r.w - shrink)) return true;
        if (dir == 2 && (x - speed < r.x + r.w - shrink && x > r.x + shrink) &&
            (y + h > r.y + shrink && y < r.y + r.h - shrink)) return true;
        if (dir == 3 && (x + w + speed > r.x + shrink && x < r.x + r.w - shrink) &&
            (y + h > r.y + shrink && y < r.y + r.h - shrink)) return true;
    }
    return false;
  }

  boolean checkCollision(Candy c) {    
    if (c == null) return false;
    int candyShrinkX = c.size_x - 30;  // 縮小糖果偵測寬度
    int candyShrinkY = c.size_y - 30;  // 縮小糖果偵測高度
    
    return (x < c.x + candyShrinkX && x + w > c.x + 15 &&
            y < c.y + candyShrinkY && y + h > c.y + 15);
  }
}
