////////////////////////////////////////////////////////
//                                                    //
// Asteroids                                          //
// DM2 "UED 131 - Programmation impérative" 2021-2022 //
// NOM         : MARIE-JOSEPH                         //
// Prénom      : Emmy                                 //
// N° étudiant : 20213708                             //
//                                                    //
// Collaboration avec : AYED Fatima et DEFARCY Marine //
//                      pour certaines parties        //
//                                                    //
////////////////////////////////////////////////////////

//===================================================
// les variables globales
//===================================================

//////////////////////
// Pour le vaisseau //
//////////////////////

// *** Position du vaisseau *** //
float shipX = 400;                                        
float shipY = 400;

// *** Angle de rotation *** //
float shipAngle = 3*PI/2;

// *** Vitesse et accélération *** //
float vxship, vyship, axship, ayship;

//////////////////////
// Pour le missile  //
//////////////////////

// *** Position du missile *** //
float xM = -100;               
float yM = -100;  

// *** Vitesse du missile *** //
float vxM = 0;                 
float vyM = 0;                 
int vM;                        

//////////////////////
// Pour l'astéroïde //
//////////////////////

// *** Position de l'astéroïde *** //
float xA, yA;

// *** Vitesse et accéleration de l'astéroïde *** //
float vxA, vyA;
int vA;
float a; 

// *** Taille de l'astéroïde *** //
int t;                         
                        
////////////////////////////
// Pour la gestion du jeu //
////////////////////////////

// *** Compteur des points *** //
int score = 0;

// *** Fichiers des sons *** //
import processing.sound.*;
SoundFile bangSmall;
SoundFile bangLarge;
SoundFile fire;
SoundFile thrust;

////////////////////////////////////
// Pour la gestion de l'affichage //
////////////////////////////////////

// *** Police d'écriture *** //
PFont Police;


//===================================================
// l'initialisation
//===================================================
void setup() {
  size(800, 800);
  background(0);
  initGame();
  bangSmall = new SoundFile(this, "bangSmall.mp3");
  fire = new SoundFile(this, "fire.mp3");
  bangLarge = new SoundFile(this, "bangLarge.mp3");
  thrust = new SoundFile(this, "thrust.mp3");
}

// -------------------- //
// Initialise le jeu    //
// -------------------- //
void initGame() {
  displayInitScreen();
  initShip();
  initAsteroids();
}

//===================================================
// la boucle de rendu
//===================================================
void draw() {
  if (init == false) {
    displayShip();
    moveAsteroids();
    displayAsteroids();
    moveBullets();
    displayBullets();
    if (collision(xM, yM, 0, xA, yA, t) == true) {
      xA = random(0, 800);
      yA = random(0, 800);
      xM = -100;
      yM = -100;
      vM = 0;
      //bangSmall.play();
    }
    displayScore();
    if (gameOver() == true) {
      displayGameOverScreen();                                         
    }
    moveShip();
  }
}

// ------------------------ //
//  Initialise le vaisseau  //
// ------------------------ //
void initShip() {
}

// --------------------- //
//  Deplace le vaisseau  //
// --------------------- //
void moveShip() {
  if (moteur == true) {
    axship = 0.25;
    ayship = 0.25;
    vxship = cos(shipAngle);
    vyship = sin(shipAngle);
    vxship += axship;
    vyship += ayship;
    shipX += vxship;
    shipY += vyship;
    if (shipX>800) {
      shipX = 0;
    }
    if (shipX<0) {
      shipX = 800;
    }
    if (shipY>800) {
      shipY = 0;
    }
    if (shipY<0) {
      shipY = 800;
    }
  }
}

// -------------------------- //
//  Crée un nouvel asteroïde  //
// -------------------------- //
void initAsteroids() {
  xA = random(0, 800);
  if (xA == 0 || xA == 800) {
    yA = random(0, 800);
  } else {
    yA = 0;
  }
  vA = 3;
  t = 60;
  a = random(0, 360);
  vxA = vA*cos(radians(a));
  vyA = vA*sin(a);
}
    
// ------------------------------ //
//  Crée la forme de l'asteroïde  //
// ------------------------------ //
// i : l'indice de l'asteroïde dans le tableau
//
void createAsteroid(int i) {
}

// --------------------- //
//  Deplace l'asteroïde  //
// --------------------- //
void moveAsteroids() {
  xA += vxA;
  yA += vyA;
  if (xA>800) {
    xA = 0;
  }
  if (xA<0) {
    xA = 800;
  }
  if (yA>800) {
    yA = 0;
  }
  if (yA<0) {
    yA = 800;
  }
}

// ------------------------ //
//  Détecte les collisions  //
// ------------------------ //
// o1X, o1Y : les coordonnées (x,y) de l'objet1
// o1D      : le diamètre de l'objet1 
// o2X, o2Y : les coordonnées (x,y) de l'objet2
// o2D      : le diamètre de l'objet2 
//

boolean collision(float o1X, float o1Y, float o1D, float o2X, float o2Y, float o2D) {
  if (dist(o1X, o1Y, o2X, o2Y)-(o1D/2+o2D/2) <= 0) {
    score += 1;
    return true;
  } else {
    return false;
  }
}

boolean gameOver() {
  if (dist(shipX, shipY, xA, yA)-(10/2+t/2) <= 0) {
    return true;
  } else {
    return false;
  }
}

boolean init = true;

boolean moteur = false;

// ----------------- //
//  Tire un missile  //
// ----------------- //
void shoot() {
  xM = shipX;
  yM = shipY;
  vM = 5;
  vxM = vM*cos(shipAngle);
  vyM = vM*sin(shipAngle);
  //fire.play();
}

// ------------------------------------------- //
//  Calcule la trajectoire du ou des missiles  //
// ------------------------------------------- //
void moveBullets() {
  xM += vxM;
  yM += vyM;
}

// --------------------- //
//  Supprime un missile  //
// --------------------- //
// idx : l'indice du missile à supprimer
//
void deleteBullet(int idx) {
}

// --------------------- //
//  touche un astéroïde  //
// --------------------- //
// idx    : l'indice de l'atéroïde touché
// vx, vy : le vecteur vitesse du missile
//
void shootAsteroid(int idx, float vx, float vy) {
}

// ----------------------- //
//  supprime un astéroïde  //
// ----------------------- //
// idx    : l'indice de l'atéroïde touché
//
void deleteAsteroid(int idx) {
}

//===================================================
// Gère les affichages
//===================================================

// ------------------- //
// Ecran d'accueil     //
// ------------------- //
void displayInitScreen() {
  Police = createFont("Courrier", 100);
  textFont(Police);
  textAlign(CENTER, CENTER);
  fill(255);
  text("ASTEROIDS", width/2, height/2);
  Police = createFont("Courrier", 20);
  textFont(Police);
  text("Cliquer pour commencer", width/2, 500);
  if (init == false) {
    background(0);
  }
}

// -------------- //
//  Ecran de fin  //
// -------------- //
void displayGameOverScreen() {
  //bangLarge.play();
  background(0);
  Police = createFont("Courrier", 100);
  textFont(Police);
  textAlign(CENTER, CENTER);
  fill(255);
  text("GAME OVER", width/2, 350);
  Police = createFont("Courrier", 20);
  textFont(Police);
  text("Votre score : " + score, width/2,500);
  text("Appuyez sur ENTRER pour recommencer !",width/2,600);
  noLoop();                                                   // d'après la page de référence de Processing
}

// --------------------- //
//  Affiche le vaisseau  //
// --------------------- //
void displayShip() {
  background(0);
  translate(shipX, shipY);
  rotate(shipAngle);
  scale(3);
  fill(0);
  if (moteur == true) {
    stroke(255, 0, 0);
    beginShape();
    vertex(-15, 0);
    vertex(-5, 5);
    vertex(-5, -5);
    endShape(CLOSE);
  }
  stroke(255);
  beginShape();
  vertex(10, 0);
  vertex(-7, 7);
  vertex(-5, 0);
  vertex(-7, -7);
  endShape(CLOSE);
  resetMatrix();
}

// ------------------------ //
//  Affiche les asteroïdes  //
// ------------------------ //
void displayAsteroids() {
  stroke(255);
  ellipse(xA, yA, t, t);
}

// ---------------------- //
//  Affiche les missiles  //
// ---------------------- //
void displayBullets() {
  stroke(255);
  line(xM, yM, xM+vxM, yM+vyM);
}

// ------------------- //
//  Affiche le chrono  //
// ------------------- //
void displayChrono() {
}

// ------------------- //
//  Affiche le score   //
// ------------------- //
void displayScore() {
  Police = createFont("Courrier", 20);
  textFont(Police);
  textAlign(BOTTOM, LEFT);
  fill(255);
  text(score, width-80, height/10);
}

//===================================================
// Gère l'interaction clavier
//===================================================

// ------------------------------- //
//  Quand une touche est enfoncée  //
// ------------------------------- //
// flèche droite  = tourne sur droite
// flèche gauche  = tourne sur la gauche
// flèche haut    = accélère
// barre d'espace = tire
// entrée         = téléportation aléatoire
//
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      shipAngle += radians(5);
    } else if (keyCode == LEFT) {
      shipAngle -= radians(5);
    }
    if (keyCode == UP) {
      moteur = true;
      //thrust.play();
    }
  }
  if (key == 32) {                            // code ASCII de la barre d'espace est 32 d'après la page de référence de Processing
    shoot();
  }
  if (key == ENTER) {
    shipX = random(0, 800);
    shipY = random(0, 800);
    loop();
    score = 0;
    initGame();
  }
}

// ------------------------------- //
//  Quand une touche est relâchée  //
// ------------------------------- //
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      moteur = false;
    }
  }
}

//---------------------------------//
//   Quand la souris a été cliqué  //
//---------------------------------//
void mouseClicked() {
  init = false;
}
