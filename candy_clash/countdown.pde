import javax.swing.JOptionPane;

void countdown(int time) {
  int elapsedTime = millis() - startTime;   // 已用時間 // 計算從遊戲開始到當前時間的經過時間      
  int remainingTime = max(0, time - elapsedTime) / 1000;   // 剩餘時間  // 確保不出現負數

  fill(0);
  textSize(48);

  if (gameRunning) {
    textAlign(LEFT, TOP); 
    fill(227, 201, 255);
    text("Time: " + remainingTime, width/2 - 100, 50);    
    if (elapsedTime >= time) {   
      gameRunning = false;
      
      // 判斷勝負
      String resultMessage;
      int winner_score;
      boolean player1_wins = player1_score > player2_score;
      boolean draw = player1_score == player2_score;
      
      if (player1_wins) {
        resultMessage = "玩家 1 獲勝🎉"; 
        winner_score = player1_score;
      } else if (draw) {
        resultMessage = "平手！😲😲😲";  
        winner_score = player1_score;
      } else {
        resultMessage = "玩家 2 獲勝🎉";
        winner_score = player2_score;
      }
      
      // 顯示對話框
      String message = "<html><div align='center'>" +
                       "<h2 style='font-size:25px;'>" + resultMessage + "</h2>" +
                       "<h2 style='font-size:20px;'>分數🎮</h2>" +
                       "<h2 style='font-size:20px;color:red;'>" + winner_score + "</h2>" + 
                       "</div></html>";
      JOptionPane.showMessageDialog(null, message, "🏆 Game Over 🏆", JOptionPane.PLAIN_MESSAGE);
    }
  } 
  else {
    textAlign(LEFT, TOP); 
    fill(208);
    text("Game Over !!!", width/2 - 150, 50);
    textSize(32);
    
    // 顯示玩家 1 分數及結果
    if (player1_score > player2_score) {
      fill(255, 255, 0); // 黃色 (Winner!)
      text("Winner !", 390, 50);
    } else if (player1_score < player2_score) {
      fill(255, 0, 0); // 紅色 (Loser!)
      text("Loser !", 380, 50);
    } else {
      fill(255); // 白色 (平手)
      text(" Draw !", 380, 50);
    }
    fill(0); // 黑色
    
    // 顯示玩家 2 分數及結果
    if (player2_score > player1_score) {
      fill(255, 255, 0); // 黃色 (Winner!)
      text("Winner !", width - 500, 50);
    } else if (player2_score < player1_score) {
      fill(255, 0, 0); // 紅色 (Loser!)
      text("Loser !", width - 490, 50);
    } else {
      fill(255); // 白色 (平手)
      text("Draw !", width - 490, 50);
    }
  }
}
