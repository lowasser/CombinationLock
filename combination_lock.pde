
float currentAngle = 0;

int width = 350;
int height = 450;
int middleW = width/2;
int middleH = height / 2;
int lockRadius = 150;
int buttonRadius = 30;
int lockTicks = 40;
int[] entered = new int[3];
int[] combination = new int[]{22, 37, 9};
int nEntered = 0;
int resetTime = 0;
boolean isUnlocked = false;
boolean isLocked = false;

void setup(){
  size(350, 450);
}

void mouseDragged(){
  PVector cur = new PVector(mouseX - middleW, mouseY - middleH);
  PVector prev = new PVector(pmouseX - middleW, pmouseY - middleH);
  float angle = PVector.angleBetween(cur, prev);
  if(cur.cross(prev).z < 0){
    angle = -angle;
  }
  currentAngle -= angle;
  redraw();
}

void mousePressed(){
  if(insideLockButton() && nEntered < 3){
    entered[nEntered++] = currentTick();
    redraw();
  }else if(insideResetButton()){
    nEntered = 0;
    redraw();
  }else if(insideDoneButton() && nEntered == 3){
    println("Done");
    finish();
    redraw();
  }
}

void finish(){
  entered = sort(entered);
  combination = sort(combination);
  boolean good = true;
  for(int i = 0; i < 3 && good; i++){
    println(entered[i] + " " + combination[i]);
    good = good && entered[i] == combination[i] - 1;
  }
  if(good){
    isLocked = false;
    isUnlocked = true;
    resetTime = millis();
  }else{
    isLocked = true;
    isUnlocked = false;
    resetTime = millis();
  }
  redraw();
  nEntered = 0;
}

boolean insideLockButton(){
  PVector v = new PVector(mouseX - middleW, mouseY - middleH);
  return v.mag() <= buttonRadius;
}

boolean insideResetButton(){
  return mouseX >= 0 && mouseX <= resetButtonWidth()
    && mouseY >= height - resetButtonHeight() && mouseY <= height;
}

boolean insideDoneButton(){
  int doneButtonWidth = resetButtonWidth();
  int doneButtonHeight = resetButtonHeight();
  return mouseX >= width - doneButtonWidth && mouseX <= width
    && mouseY >= height - doneButtonHeight && mouseY <= height;
}

void draw(){
  if(millis() - resetTime >= 1000){
    isLocked = false;
    isUnlocked = false;
  }else if(isLocked){
    showLocked();
    return;
  }else if(isUnlocked){
    showUnlocked();
    return;
  }
  drawBack();
  translate(middleW, middleH);
  drawLock();
  drawDoneButton();
  drawEntered();
}

void drawEntered(){
  resetMatrix();
  translate(middleW, middleH);
  pushStyle();
  fill(#FFFFFF);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  String theStr = "";
  for(int i=0; i < nEntered; i++){
    if(i != 0) theStr += " ";
    theStr += (entered[i] + 1);
  }
  text(theStr, 0, lockRadius * 1.2);
  popStyle();
}

void showUnlocked(){
  resetMatrix();
  pushStyle();
  fill(#00FF00);
  rectMode(CORNER);
  rect(0, 0, width, height);
  popStyle();
}

void showLocked(){
  resetMatrix();
  pushStyle();
  fill(#FF0000);
  rectMode(CORNER);
  rect(0, 0, width, height);
  popStyle();
}

int currentTick(){
  float angle = currentAngle;
  while(angle < 0){
    angle += TWO_PI;
  }
  while(angle >= TWO_PI){
    angle -= TWO_PI;
  }
  int ans = (int) (angle * lockTicks / TWO_PI + 0.5);
  ans %= lockTicks;
  return lockTicks - 1 - ans;
}

void drawLockBase(){
  pushStyle();
  ellipseMode(CENTER);
  fill(#555555);
  stroke(#DDDDDD);
  strokeWeight(3);
  ellipse(0, 0, lockRadius * 2, lockRadius * 2);
  popStyle();
}

void drawLockTicks(){
  pushMatrix();
  pushStyle();
  strokeWeight(1);
  stroke(#FFFFFF);
  rotate(currentAngle);
  for(int i=1;i<=lockTicks;i++){
    line(0.9 * lockRadius, 0, lockRadius - 1.5, 0);
    rotate(TWO_PI / lockTicks);
  }
  popMatrix();
  popStyle();
}

void drawLockPosition(){
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(#FFFFFF);
  text(str(currentTick() + 1), 0, - lockRadius * 0.7);
  popStyle();
}

void drawEnterButton(){
  pushStyle();
  textAlign(CENTER, CENTER);
  ellipseMode(CENTER);
  fill(#00AA00);
  strokeWeight(3);
  stroke(#111111);
  ellipse(0, 0, buttonRadius * 2, buttonRadius * 2);
  fill(#000000);
  text("Enter", 0, 0);
  popStyle();
}

void drawBack(){
  pushStyle();
  resetMatrix();
  rectMode(CORNER);
  fill(#000000);
  rect(0, 0, width, height);
  popStyle();
}

void drawLock(){
  drawLockBase();
  drawLockTicks();
  drawLockPosition();
  drawEnterButton();
  drawResetButton();
}

void drawDoneButton(){
  resetMatrix();
  int doneButtonWidth = resetButtonWidth();
  int doneButtonHeight = resetButtonHeight();
  translate(width - doneButtonWidth, height - doneButtonHeight);
  pushStyle();
  fill(#00CC00);
  strokeWeight(3);
  stroke(#555555);
  rectMode(CORNER);
  rect(0, 0, doneButtonWidth, doneButtonHeight);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(#FFFFFF);
  text("Done", doneButtonWidth / 2, doneButtonHeight / 2);
  popStyle();
}

int resetButtonWidth(){
  return width - middleW - 3 * lockRadius / 4;
}
int resetButtonHeight(){
  return height - middleH - 3 * lockRadius / 4;
}

void drawResetButton(){
  resetMatrix();
  translate(0,height);
  pushStyle();
  fill(#CC0000);
  strokeWeight(3);
  stroke(#555555);
  rectMode(CORNER);
  rect(0, -resetButtonHeight(), resetButtonWidth(), resetButtonHeight());
  fill(#FFFFFF);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Reset", resetButtonWidth() / 2, - resetButtonHeight() / 2);
  popStyle();
}
