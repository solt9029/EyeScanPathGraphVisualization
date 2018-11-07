final int SCREEN_WIDTH = 1280;
final int SCREEN_HEIGHT = 1024;
final int WINDOW_WIDTH = 2500;

String [] eyeLines;
float [][] eyeData;
String [] mouseLines;
float [][] mouseData;
String [] orderLines;
float [][] orderData;

final int ITEM_HEIGHT = 26;
final int ITEM_WIDTH = 26 * 4;
final int SPACE_ITEM_NUM = 4;
final int UNIT = 20; // 100ミリ秒あたり
final int BUTTON_NUM = 5;
final int START_X = 20 + ITEM_WIDTH;
final int [] ITEM_NUMS = {8, 12, 16};

void settings() {
  size(WINDOW_WIDTH, ITEM_HEIGHT * (16 + SPACE_ITEM_NUM) + 100);
}

int buttonPosition = 0;
int itemPosition = 0;
int trialDirIndex = 0;
int itemNumIndex = 0;
File inputDir;
File [] trialDirs;

void setup() {
  textAlign(CENTER, CENTER);
  inputDir = new File("C:\\Users\\Shiode\\Desktop\\Experiment\\EyeScanPathGraphVisualization\\input");
  trialDirs = inputDir.listFiles();
}

void draw() {
  // .gitignoreとかも混ざっているので、ディレクトリでなければはじくよ
  if (!trialDirs[trialDirIndex].isDirectory()) {
    if (trialDirIndex < trialDirs.length - 1) {
      trialDirIndex++;
    }
    return;
  }

  background(255);
  stroke(0);

  // 視線ファイル読み込み
  eyeLines = loadStrings(trialDirs[trialDirIndex].toString() + "\\" + str(ITEM_NUMS[itemNumIndex]) + "\\" + str(buttonPosition) + "_" + str(itemPosition) + "_eye.csv");
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

  mouseLines = loadStrings(trialDirs[trialDirIndex].toString() + "\\" + str(ITEM_NUMS[itemNumIndex]) + "\\" + str(buttonPosition) + "_" + str(itemPosition) + "_mouse.csv");
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
  rect(10, ITEM_HEIGHT * (SPACE_ITEM_NUM / 2), ITEM_WIDTH, ITEM_HEIGHT * ITEM_NUMS[itemNumIndex]);
  for (int i = 0; i < ITEM_NUMS[itemNumIndex]; i++) {
    if (itemPosition == i) {
      fill(0, 0, 255);
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

  // グラフ土台を描画
  int startY = ITEM_HEIGHT * (ITEM_NUMS[itemNumIndex] + SPACE_ITEM_NUM);
  line(START_X, 0, START_X, startY);
  line(START_X, startY, WINDOW_WIDTH, startY);
  for (int i = 0; i < 100; i++) {
    line(START_X + UNIT * i, startY, START_X + UNIT * i, startY + 4);
    if (i % 2 == 1) {
      continue;
    }
    fill(0);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(i * 100, START_X + UNIT * i, startY + 15);
  }

  int top = SCREEN_HEIGHT / 2 - (ITEM_NUMS[itemNumIndex] / 4) * buttonPosition * ITEM_HEIGHT - ITEM_HEIGHT * SPACE_ITEM_NUM / 2;

  // 視線グラフ描画
  for (int i = 0; i < eyeData.length - 1; i++) {
    stroke(255, 0, 255);
    line(START_X + eyeData[i][2] / (100 / UNIT), eyeData[i][1] - top, START_X + eyeData[i + 1][2] / (100 / UNIT), eyeData[i + 1][1] - top);
  }

  // マウスグラフ描画
  for (int i = 0; i < mouseData.length - 1; i++) {
    stroke(0, 255, 0);
    line(START_X + mouseData[i][2] / (100 / UNIT), mouseData[i][1] - top, START_X + mouseData[i + 1][2] / (100 / UNIT), mouseData[i + 1][1] - top);
  }

  // 説明記述
  //textSize(15);
  //textAlign(LEFT);
  //fill(255, 0, 255);
  //text("red: eye positions", 10, startY + 50);
  //fill(0, 255, 255);
  //text("blue: mouse positions", 10, startY + 75);
  //fill(255);

  // 保存
  save("./output/" + trialDirs[trialDirIndex].getName() + "/" + str(ITEM_NUMS[itemNumIndex]) + "/" + str(buttonPosition) + "_" + str(itemPosition) + ".bmp");

  // 全てのファイルに対して処理を行う
  itemPosition++;
  if (itemPosition >= ITEM_NUMS[itemNumIndex]) {
    itemPosition = 0;
    buttonPosition++;
  }
  if (buttonPosition >= BUTTON_NUM) {
    itemPosition = 0;
    buttonPosition = 0;
    itemNumIndex++;
  }
  if (itemNumIndex >= ITEM_NUMS.length) {
    itemPosition = 0;
    buttonPosition = 0;
    itemNumIndex = 0;
    trialDirIndex++;
  }
  if (trialDirIndex >= trialDirs.length) {
    noLoop();
  }
}