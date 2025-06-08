import java.util.ArrayList;
import java.util.Iterator;
// bgm
import ddf.minim.*;
Minim minim;
AudioPlayer bgm;
// init
PFont chinese_font;  // 建立中文字型
PGraphics bgCanvas;  // 將背景暫存為畫布
PImage background, boy, girl, candy, obsthree, obstree;
boolean gameRunning = true;
int startTime;
// 開始倒數
int countdownTime = 6;     // 開始倒數 ? 秒
int countdownStart;        // 記錄倒數開始的時間
int player1_score = 0;     // 分數
int player2_score = 0;     // 分數
int s = 37;                // 遊戲時間幾秒?
int candy_number = 100;    // 幾顆糖果?
int obs_number = 20;       // 幾個障礙物?
int speed = 15;            // 角色走路速度?

Player p1, p2;
ArrayList<Candy> candies = new ArrayList<>();
Obstacle[] obstacles;
int random = int(random(2));
int[][] obsLocation;

void setup(){
  size(1800, 900);
  frameRate(15);
  chinese_font = createFont("MicrosoftJhengHeiBold-32.vlw", 32);
  textFont(chinese_font);
  // 計時器
  startTime = millis();  // 記錄遊戲開始時間
  // 開始倒數
  countdownStart = millis();
  // bgm
  if (bgm == null) {
    minim = new Minim(this);
    bgm = minim.loadFile("bgm.mp3");  // 載入背景音樂
    bgm.loop();
  }
    
  // 初始化影像
  background = loadImage("forest.png");
  bgCanvas = createGraphics(width, height);
  bgCanvas.beginDraw();
  bgCanvas.image(background, 0, 0, width, height);  // 畫一次
  bgCanvas.endDraw();
  
  boy = loadImage("boy.png");
  girl = loadImage("girl.png");
  candy = loadImage("candy.png");
  obstree = loadImage("smalltree.png");  // 138*149  1:1

  // 設定角色大小及位置
  float scale = 2;  // 為原始大小的幾倍?
  p1 = new Player(100, 180, int(32*scale), int(48*scale), 'a', 'd', 'w', 's');
  p2 = new Player(width - 200, 180, int(32*scale), int(48*scale), LEFT, RIGHT, UP, DOWN);
  
  // 創建糖果的邊界
  int bound_x_left = 50;     // 離左邊
  int bound_x_right = 100;   // 離右邊
  int bound_y_top = 150;     // 離上面
  int bound_y_bottom = 50;   // 離下面
  
  // 隨機生成糖果位置
  for (int i = 0; i < candy_number; i++) {
    int x = bound_x_left + int(random(width - bound_x_left - bound_x_right));
    int y = bound_y_top + int(random(height - bound_y_top - bound_y_bottom));
    candies.add(new Candy(x, y));
  }

  // 創建並生成障礙物
  obstacles = new Obstacle[obs_number];
  int obs_width = 100;
  int obs_height = 100;
  // 指定障礙物位置(2張地圖)
  if(random == 0){
    obsLocation = new int[][] {
        {74, 821}, {99, 596}, {152, 177}, {183, 755}, {277, 761},
        {296, 437}, {389, 573}, {539, 278}, {550, 426}, {672, 587},
        {883, 376}, {884, 206}, {995, 521}, {1039, 757}, {1223, 547},
        {1203, 179}, {1361, 182}, {1379, 385}, {1426, 518}, {1626, 555}
    };
  } else {
    obsLocation = new int[][] {
        {100, 800}, {150, 600}, {180, 200}, {250, 750}, {300, 500},
        {400, 700}, {500, 250}, {550, 430}, {650, 600}, {750, 350},
        {900, 400}, {950, 250}, {1050, 550}, {1100, 750}, {1250, 500},
        {1300, 200}, {1400, 250}, {1450, 450}, {1550, 550}, {1650, 600}
    };
  }
  // 套用障礙物位置
  for(int i = 0;i < obs_number;i++){
      obstacles[i] = new Obstacle(obsLocation[i][0], obsLocation[i][1], obs_width, obs_height);
  }
  
}

void draw(){
  image(bgCanvas, 0, 0);
  fill(255, 70);
  rect(0,0,width, 140);
  stroke(208);
  strokeWeight(10);
  line(0, 140, width, 140);
  noStroke();
  
  p1.give(boy);
  p2.give(girl);
  
  // 顯示所有糖果 並 檢查碰撞
  Iterator<Candy> iter = candies.iterator();
    while (iter.hasNext()) {
        Candy c = iter.next();
        c.show();
        if (p1.checkCollision(c)) {
            iter.remove();  // 吃到糖果直接移除
            player1_score += 10;
        } else if (p2.checkCollision(c)) {
            iter.remove();  
            player2_score += 10;
        }
    }
  
  // 顯示所有障礙物
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i].show();
  }

  // 顯示2位玩家分數
  fill(255);
  textSize(30);
  textAlign(LEFT, TOP);  // 設置文字基準點
  text("Player 1   Score:  ", 100, 50);
  fill(0, 255, 255);
  text(player1_score, 330, 50);  // 顯示 Player 1 的分數
  
  textAlign(RIGHT, TOP);
  fill(255);
  text("Player 2   Score:  ", width - 130, 50);
  fill(0, 255, 255);
  text(player2_score, width - 100, 50);  // 顯示 Player 2 的分數

  // 開始倒數
  int elapsedTime = millis() - countdownStart;
  int remainingTime = countdownTime - elapsedTime / 1000;
  if (remainingTime > 0) {
    fill(255, 0, 0);
    textSize(100);
    textAlign(CENTER, CENTER);
    if (remainingTime == 6 || remainingTime == 5) {
      // 顯示標題
      fill(255, 215, 0);  // 金黃色
      text("糖果爭奪戰", width/2, height/2);
    } else {
      // 顯示倒數數字
      text(remainingTime-1, width/2, height/2);  // 顯示 3,2,1,0
    }
    return;  // 倒數中，暫停遊戲邏輯
  }
  
  // 開始倒數
  countdown(1000*s);  // 60000為1分鐘  // 1000為1秒
  
  p1.move();  
  p2.move();
  
  // 查看FPS用
  //fill(255);
  //textSize(25);
  //text("FPS: " + int(frameRate), 10, 10);
}

int temp;
void keyPressed() {
  if(key == 's' || key == 'w' || key == 'a' || key == 'd') {p1.setDirection(key); temp = key;}
  else if(keyCode == LEFT || keyCode == RIGHT || keyCode == UP || keyCode == DOWN) {p2.setDirection(keyCode); temp = keyCode;}
}

void keyReleased() {
  if (key == 'a' || key == 'd' || key == 'w' || key == 's') {
    p1.stop();
  }else if (keyCode == LEFT || keyCode == RIGHT || keyCode == UP || keyCode == DOWN) {
    p2.stop();
  }
}
