// For the small Monster's animation, have nothing to do with arduino

PImage animal;
int eyeball = 45;
float x=160;
float y=90;

void drawmonster(){
    strokeWeight(0);
    fill(255);
    ellipse(160,90,90,90);//white eye background
    fill(0);
    ellipse(x,y, eyeball, eyeball); //eyeball
    image(animal,38,3,240,240);
    relax();
}

void relax(){
  if(x>=175){x=162;} if(x<=145){x=159;}
  if(y>=105){y=91;} if(y<=75){y=89;}
  
  x=x+random(-0.5,0.5);
  y=y+random(-0.5,0.5);
}

void move(){ // Movement of Monster‘s eye related with the newest face
  for (int i = 0; i < faces.length; i++){
  if((faces[i].x+1/2*faces[i].width)<x){x=x+0.5;} else {x=x-0.5;}
  if((faces[i].y+1/2*faces[i].height)<y){y=y+0.1;}else {y=y-0.1;}
  }
}