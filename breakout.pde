import processing.sound.*;
SoundFile file;
//location of ball
int x, y;
// velocity of ball
int dx, dy;
//location of paddle
int xb = 500/2-50; 
int yb = 500-70;
//other variables
int screen;
int score;
int balls_left;
int game;

int[][] bricks = new int[10][8];

void setup() {
  score=0;
  balls_left=4;
  game=1;
  size(500, 500);
  screen=1;
  file = new SoundFile(this, "woop.wav"); 
  //sets all bricks to 1
  for (int i=0; i<10; i++) {
    for (int j=0; j<8; j++) {
      bricks[i][j]=1;
    }
  }
  resetBall();
}

// center ball, set random velocity
void resetBall() {
  x = width/2;
  y = 3*height/4;
  xb = 500/2-50; 
  yb = 500-70;
  float ranSig = random(0, 2);
  dx = (ranSig>1.5 ? 2 : -2);
  dy = -3;
}

void resetDir() {
  if (x>494 || x<6) {
    dx=-dx;
  } else if (y<6) {
    dy=-dy;
  }
}

void draw() {
  if (screen==0 && game==1) {
    //Bricks constants
    int i, j;
    int xc, yc;
    fill(0);
    rect(0, 0, width, height);

    fill(255);
    text("Dollars =", 6, 484);
    text(score, 75, 484);

    //balls left
    text("Balls left =", 150, 484);
    if (balls_left>0) {
      for (int m=1; m<=balls_left; m++) {
        ellipse(240+m*15, 479, 10, 10);
      }
    }
    //ball direction and speed
    ellipse(x, y, 10, 10);
    x = x + dx;
    y = y + dy;
    stroke(255);
    strokeWeight(0.5);
    fill(255, 3, 62);
    //paddle
    rect(xb, yb, 100, 10);   
    //Building the bricks
    for (i=0; i<10; i++) {
      for (j=0; j<8; j++) {
        xc=i*50;
        yc=100+j*20;

        if (bricks[i][j]==1) {
          fill(96, 185, 79);
          rect(xc, yc, 50, 20);
          fill(0);
          text("10 $", xc+10, yc+15);
        }
        //bounce top and bottom of the brick
        if ((x<xc+50 && x>xc) && (y-6<yc+20 && y+6>yc) && bricks[i][j]==1) {
          dy=-dy;
          fill(0);
          rect(xc+12.5, yc+5, 25, 10);
          bricks[i][j]=0;
          file.play();
          score=score+10;
        } 
        //bounce left and right of the brick
        else if (((x+5>xc-5 && x+5<xc) || (x-5>xc+50 && x-5<xc+55)) && (y-4<yc+20 && y+4>yc) && bricks[i][j]==1) {
          dx=-dx;
          bricks[i][j]=0;
          file.play();
          score=score+10;
        }
      }
    }  
    if (score>=800) {
      game=0;
      fill(255);
      text("YOU WON, Press G to Restart the Game", 90, 355);
      noLoop();
    }
    if (y>510) {
      if (balls_left==0) {
        fill(255);
        game=0;
        text("You Lose!! Press G to Restart the Game", 95, 355);
        noLoop();
      } else {
        balls_left = balls_left-1;
        fill(255);
        text("Press B for a New Ball", 175, 355);
        noLoop();
      }
    }
    //Bounce from the paddle
    if ((x>495) || (x<5) || (y<5)) {
      resetDir();
    } else if ((x>xb && x<xb+100)&&(y>=yb-2 && y<yb)) {
      dy=-dy;
    } else if (((x>xb-10 && x<xb+1) || (x>xb+99 && x<xb+110)) && (y>=yb-2 && y<yb+12)) {
      dx=-dx;
      dy=-dy;
    }
  } else if (game==0) { 
    fill(0);
    stroke(255);
    strokeWeight(4);
    rect(0, 0, 500, 500);
    noStroke();
    fill(255, 8, 8);
    rect(200, 450, 100, 10);
    fill(255);
    textSize(20);
    text("Press G to restart the game", 134, 208);
  } 
  //Starting screen
  else {
    fill(0);
    stroke(255);
    strokeWeight(4);
    rect(0, 0, 500, 500);
    noStroke();
    fill(255, 8, 8);
    rect(39, 240, 50, 20);
    rect(158, 120, 50, 20);
    rect(375, 120, 50, 20);
    rect(240, 260, 50, 20);
    rect(403, 220, 50, 20);
    //paddle
    rect(200, 450, 100, 10);
    fill(255);
    textSize(20);
    text("WELCOME TO BREAKOUT", 134, 208);
    text("Press Enter to Start", 164, 369);
    textSize(15);
    text("Move Paddle with Left Right Keys", 146, 307);
    text("Press P to pause", 207, 331);

    fill(255);
    ellipse(244, 445, 10, 10);
  }
}
void keyPressed() {
  if (key == 'r') {
    resetBall();
  } else if (keyCode == RIGHT) {
    xb = (xb<400 ? xb+20 : xb);
  } else if (keyCode == LEFT) {
    xb = (xb>0 ? xb-20 : xb);
  } else if (key == 'd') {
    resetDir();
  } else if (key=='p') {
    if (looping) {
      fill(0);
      text("Pause, press P to unpause", 170, 400);
      noLoop();
    } else loop();
  } else if (keyCode == ENTER) {
    screen=0;
  } else if (key == 'b' && balls_left>=0 && y>500 && game==1) {
    resetBall();
    loop();
  } else if (key=='g') {
    loop();
    setup();
  }
}