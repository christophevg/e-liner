// servo test
// auteur: Christophe VG <contact@christophe.vg>

Servo links;
Servo rechts;

#define BAUD       9600

#define LINKS_PIN  D0
#define RECHTS_PIN D1

#define KNOP       D6

#define MIN        45
#define MAX        135
#define OORSPRONG  (MIN + (MAX - MIN / 2))

#define WACHT      10

void setup() {
  // seriele console
  Serial.begin(BAUD);

  // knop
  pinMode( KNOP , INPUT_PULLUP);
  attachInterrupt(KNOP, druk, FALLING);

  // servos
  links.attach(LINKS_PIN);
  rechts.attach(RECHTS_PIN);
}

typedef enum {
  IDLE,              // de servos doen niets
  GA_NAAR_OORSPRONG, // de servos positioneren zich op hun oorspring
  IDLE_OORSPRONG,    // de servos doen niets op hun oorspring
  BEWEEG             // de servos bewegen heen en weer
} status_t;

// huidige status van de machine
volatile status_t status = IDLE;

// transities tussen statussen van de machine
// = lijst van de opeenvolgende statussen
const status_t transities[] = {
  GA_NAAR_OORSPRONG,
  IDLE_OORSPRONG,
  BEWEEG,
  IDLE
};

void ga_naar_volgende_status() {
  status = transities[status];
  Serial.print("volgende status: ");
  Serial.println(status);
}

void druk() {
  // make sure the button was actuall druked "long enough" aka debounce
  unsigned long start = millis();
  while( digitalRead( KNOP ) == LOW ); // wait until released
  if(millis() - start < 50) { return; } // at least 50ms

  Serial.print("knop werd ingedrukt... ");
  ga_naar_volgende_status();
}

void loop() {
  switch(status) {
    case GA_NAAR_OORSPRONG:
      ga_naar(OORSPRONG);
      ga_naar_volgende_status();
      break;
    case BEWEEG:
      ga_naar(MIN);
      ga_naar(MAX);
      break;
    default: // IDLE and IDLE_ZERO
      // do nothing
      break;
  }
}

int huidige_hoek = MIN;

void beweeg(int wijziging) {
  status_t start_status = status;
  if(wijziging > 0) {
    for(int hoek = 0; hoek < wijziging; hoek++) {
      if(status != start_status) { return; }
      links.write(huidige_hoek + hoek);
      rechts.write(huidige_hoek + hoek);
      delay(WACHT);
    }
  } else {
    for(int hoek = 0; hoek > wijziging; hoek--) {
      if(status != start_status) { return; }
      links.write(huidige_hoek + hoek);
      rechts.write(huidige_hoek + hoek);
      delay(WACHT);
    }    
  }
  huidige_hoek += wijziging;
}

void ga_naar(int hoek) {
  int wijziging = hoek - huidige_hoek;
  if(wijziging == 0) { return; }
  beweeg(wijziging);
}
