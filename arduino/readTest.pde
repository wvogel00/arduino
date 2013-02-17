#define XPIN 0
#define YPIN 1
#define ZPIN 2

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  int x = analogRead(XPIN);
  int y = analogRead(YPIN);
  int z = analogRead(ZPIN);
  
  Serial.print("x:");
  Serial.print(x,DEC);
  Serial.print(", y:");
  Serial.print(y,DEC);
  Serial.print(", z:");
  Serial.print(z,DEC);
  Serial.println("");
  delay(100);
}
