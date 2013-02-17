#define XPIN 0
#define YPIN 1
#define ZPIN 2
#define LOOPN 30

int prevX,prevY,prevZ;
int dx,dy,dz;

void setup()
{
  delay(1000);
  prevX = analogRead(XPIN);
  prevY = analogRead(YPIN);
  prevZ = analogRead(ZPIN);
 
  Serial.begin(9600);
  
  dx = abs(analogRead(XPIN)-prevX);
  dy = abs(analogRead(YPIN)-prevY);
  dz = abs(analogRead(ZPIN)-prevZ);
}

int IsShaken()
{
  int x = analogRead(XPIN);
  int y = analogRead(YPIN);
  int z = analogRead(ZPIN);
  int result = 0;
  
  if(abs(x-prevX) > dx*20 && dx != 0)
    result = 1;
  else if(abs(y-prevY) > dy*20 && dy != 0)
    result = 1;
  else if(abs(z-prevZ) > dz*20 && dz != 0)
    result = 1;
    
  dx = abs(x-prevX);
  dy = abs(y-prevY);
  dz = abs(z-prevZ);
  prevX = x;
  prevY = y;
  prevZ = z;
  
  return result;
}
int counter = 0;
int loopCounter = 0;
void loop()
{
  int x = analogRead(XPIN);
  int y = analogRead(YPIN);
  int z = analogRead(ZPIN);
  
  if(IsShaken() == 1)
  {
     Serial.println("HIT!!");
    //counter++;
  }
  loopCounter++;
  if(loopCounter > LOOPN)
    loopCounter = 0;
    
  /*if(loopCounter < LOOPN && counter > 3){
     Serial.println("HIT!!");
     loopCounter = counter = 0;
  }*/
  delay(50);
}
