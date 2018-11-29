#include <Servo.h>

Servo myservo;

char status;
unsigned long movt;
int angle;

void setAngle(int newangle) { // Set Range 30~150
  if (newangle < 30) angle = 30;
  else if (newangle > 150) angle = 150;
  else angle = newangle;
  myservo.write(angle);
}

void setup() {
  myservo.attach(9);
  Serial.begin(9600);
  status = 'r';// Relax
  setAngle(90);
}

void loop() {
  if (Serial.available()) {
    char c = Serial.read();// from Processing
    if (c != status) {
      status = c;
      if (status == 'L') setAngle(30); // Turn Left
      else if (status == 'R') setAngle(150); // Trun Right
      else if (status == 'r') {movt = millis() + random(1000, 5000);}// Relax
      else if (status == 'n') movt = millis() + random(500, 1000); // Nervous
      else if (status == 'M') {
        c = Serial.read();
        if (c == 'L') { if (angle != 150) setAngle(30); }
        if (c == 'R') { if (angle != 30) setAngle(150); }
      }
    }
  }

  if (millis() >= movt) {
    if (status == 'r') { // Relax: Every 2~5s, Go random position, Rotate within 60 degrees one time
      int t = random(40, 140);
      if (t - angle > 60) setAngle(t + 60);
      else if (angle - t > 60) setAngle(t - 60);
      else setAngle(t);
      movt = millis() + random(2000, 5000);
    } else if (status == 'n') { // Nervous: Every 0.5~1s, Rotate within 30 degrees one time
      setAngle(angle + random(-30, 30));
      movt = millis() + random(250, 500);
    }
  }
}
