#define XPIN 0
#define YPIN 1
#define ZPIN 2
#define LOOPN 30

int prevX,prevY,prevZ;
int dx,dy,dz;

void setup()
{
  Serial.begin(9600);
  delay(1000);
  
  prevX = analogRead(XPIN);
  prevY = analogRead(YPIN);
  prevZ = analogRead(ZPIN);
  dx = abs(analogRead(XPIN)-prevX);
  dy = abs(analogRead(YPIN)-prevY);
  dz = abs(analogRead(ZPIN)-prevZ);  
}

int IsShaken()
{
  int counter = 0;
  int i = 0;
  
  while(i++ < 10 )
  {
    int x = analogRead(XPIN);
    int y = analogRead(YPIN);
    int z = analogRead(ZPIN);
  
    if(abs(x-prevX) > dx*10 && dx != 0)
      counter++;
    else if(abs(y-prevY) > dy*10 && dy != 0)
      counter++;
    else if(abs(z-prevZ) > dz*10 && dz != 0)
      counter++;
      
    delay(10);
    
    dx = abs(x-prevX);
    dy = abs(y-prevY);
    dz = abs(z-prevZ);
    prevX = x;
    prevY = y;
    prevZ = z;
    delay(10);
  }
  
  return (counter >= 2) ? 1 : 0 ;
}

void loop()
{
  if(IsShaken() == 1)
  {
     Serial.println("HIT!!");
  }
  delay(50);
}
