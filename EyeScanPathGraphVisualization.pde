final int SCREEN_WIDTH = 1280;
final int SCREEN_HEIGHT = 1024;
final int WINDOW_WIDTH = 2500;

String [] eyeLines;
float [][] eyeData;
String [] mouseLines;
float [][] mouseData;
String [] orderLines;
float [][] orderData;

int buttonPosition = 0;
int itemPosition = 0;
final int ITEM_HEIGHT = 26;
final int ITEM_WIDTH = 26 * 4;
final int SPACE_ITEM_NUM = 6;
final int UNIT = 40; // 100ミリ秒あたり

final int BUTTON_NUM = 5;
final int ITEM_NUM = 8; // 変更する箇所

final int START_X = 20 + ITEM_WIDTH;
final int START_Y = ITEM_HEIGHT * (ITEM_NUM + SPACE_ITEM_NUM);


void settings() {
  size(WINDOW_WIDTH, ITEM_HEIGHT * (ITEM_NUM + SPACE_ITEM_NUM) + 100);
}

void setup() {
  textAlign(CENTER, CENTER);
  
  orderLines = loadStrings("./input/order.csv");
  orderData = new float [orderLines.length][7];
  for (int i = 0; i < orderLines.length; i++) {
    String [] items = split(orderLines[i], ',');
    orderData[i][0] = float(items[0]);
    orderData[i][1] = float(items[1]);
    orderData[i][2] = float(items[2]);
    orderData[i][3] = float(items[3]);
    orderData[i][4] = float(items[4]);
    orderData[i][5] = float(items[5]);
    orderData[i][6] = float(items[6]);
  }
}

void draw() {
  background(255);
  
  stroke(0);
  
  float searchTime = 0;
  for (int i = 0; i < orderData.length; i++) {
    if ((int)orderData[i][0] == ITEM_NUM && (int)orderData[i][1] == buttonPosition && (int)orderData[i][2] == itemPosition) {
      searchTime = orderData[i][4] - orderData[i][3];
      break;
    }
  }
  
  eyeLines = loadStrings("./input/" + str(buttonPosition) + "_" + str(itemPosition) + "_eye.csv");
  eyeData = new float [eyeLines.length][3];
  for (int i = 0; i < eyeLines.length; i++) {
    String [] items = split(eyeLines[i], ',');
    eyeData[i][0] = float(items[0]);
    eyeData[i][1] = float(items[1]);
    eyeData[i][2] = float(items[2]);
  }
  float eyeStartTimestamp = eyeData[0][2];
  for (int i = 0; i < eyeData.length; i++) {
    eyeData[i][2] = eyeData[i][2] - eyeStartTimestamp;
  }

  mouseLines = loadStrings("./input/" + str(buttonPosition) + "_" + str(itemPosition) + "_mouse.csv");
  mouseData = new float [mouseLines.length][3];
  for (int i = 0; i < mouseLines.length; i++) {
    String [] items = split(mouseLines[i], ',');
    mouseData[i][0] = float(items[0]);
    mouseData[i][1] = float(items[1]);
    mouseData[i][2] = float(items[2]);
  }
  float mouseStartTimestamp = mouseData[0][2];
  for (int i = 0; i < mouseData.length; i++) {
    mouseData[i][2] = mouseData[i][2] - mouseStartTimestamp;
  }
  
  // メニュー描画
  fill(255);
  rect(10, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2), ITEM_WIDTH, ITEM_HEIGHT * ITEM_NUM);
  for (int i = 0; i < ITEM_NUM; i++) {
    if (itemPosition == i) {
      fill(255, 0, 0);
      rect(10, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + i * ITEM_HEIGHT, ITEM_WIDTH, ITEM_HEIGHT);
      fill(255);
    } else {
      rect(10, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + i * ITEM_HEIGHT, ITEM_WIDTH, ITEM_HEIGHT);
    }
    stroke(210, 210, 210, 200);
    line(START_X, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + i * ITEM_HEIGHT, width, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + i * ITEM_HEIGHT);
    line(START_X, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + (i + 1) * ITEM_HEIGHT, width, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2) + (i + 1) * ITEM_HEIGHT);
    stroke(0);
  }
  
  line(START_X, 0, START_X, START_Y);
  line(START_X, START_Y, WINDOW_WIDTH, START_Y);
  for (int i = 0; i < 60; i++) {
    line(START_X + UNIT * i, START_Y, START_X + UNIT * i, START_Y + 4);
    fill(0);
    textSize(8);
    textAlign(CENTER, CENTER);
    text(i * 100, START_X + UNIT * i, START_Y + 10);
  }
  
  int top = SCREEN_HEIGHT / 2 - (ITEM_NUM / 4) * buttonPosition * ITEM_HEIGHT - ITEM_HEIGHT * SPACE_ITEM_NUM / 2;
  
  // 視線グラフ描画
  for (int i = 0; i < eyeData.length - 1; i++) {
    stroke(255, 0, 0);
    line(START_X + eyeData[i][2] / 2.5, eyeData[i][1] - top, START_X + eyeData[i + 1][2] / 2.5, eyeData[i + 1][1] - top);
  }
  
  // グラフ描画
  for (int i = 0; i < mouseData.length - 1; i++) {
    stroke(0, 0, 255);
    line(START_X + mouseData[i][2] / 2.5, mouseData[i][1] - top, START_X + mouseData[i + 1][2] / 2.5, mouseData[i + 1][1] - top);
  }
  
  // 探索終了時間に線を引く
  stroke(0);
  line(START_X + searchTime / 2.5, 0, START_X + searchTime / 2.5, START_Y);
  println(searchTime);
  
  textSize(15);
  textAlign(LEFT);
  fill(255, 0, 0);
  text("red: eye positions", 10, START_Y + 50);
  fill(0, 0, 255);
  text("blue: mouse positions", 10, START_Y + 75);
  fill(255);
  
  save("./output/" + str(buttonPosition) + "_" + str(itemPosition) + ".bmp");
  
  
  
  // 全てのファイルに対して処理を行う
  itemPosition++;
  if (itemPosition >= ITEM_NUM) {
    itemPosition = 0;
    buttonPosition++; 
  }
  if (buttonPosition >= BUTTON_NUM) {
    noLoop();
  }
}