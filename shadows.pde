//Modified by Aliica Chan

//*********************************************************
// ** Game Level Project **
// Your assignment is to change all of the visual and
// audible elements of this game. Read through the comments
// and refer to the T-Square Assignment for more details
//*********************************************************

//Import Minim library for sound
//To install the Minim library, go to Sketch > Import Library > Add Library, and install Minim (you can search for it)
import ddf.minim.*; 


//*********************************************************
// ** Audio Player Objects **
// Make sure you have one declared for every sound. You do
// not need to add any to complete the assignment.
//*********************************************************
Minim minim; //Declare Minim object
AudioPlayer bgmPlayer; //Declare different AudioPlayers, a subclass in Minim that allows audio file control (playback, loop, pause etc.)
AudioPlayer coinPlayer;
AudioPlayer teleportPlayer;
AudioPlayer screamPlayer;
AudioPlayer L1Player;
AudioPlayer L2Player;
AudioPlayer L3Player;

//Here are some global variables which we will use to control the player's behavior
//Most of them should be self-explanatory from their names
float gravity = 0.2;
float horizontalAcc = 0.2;
float maxPlayerSpeed = 7; //The maximum horizontal speed
float maxPlayerJumpAcc = 2; //The upward acceleration when a player jumps
float playerWidth = 60;
float playerHeight = 70;
int maxJumpCount = 2; //amount of in-the-air jumps possible (e.g. double jumping, triple jumping)

int mode = -1; //mode determines the game level. -1 refers to the start/end screen where the score is displayed
int score = 0; //game score. Right now, it is 25 points for collecting a coin, and 100 points for reaching the level's portal.

//ArrayLists are similar to arrays, but they offer more control. 
//For instance, objects can be added and removed from ArrayLists dynamically
//More information: https://processing.org/reference/ArrayList.html
ArrayList<Level> levels = new ArrayList<Level>(); //This ArrayList contains all the levels which we will define in setup()

int timeStamp = 0; //variable to store a timestamp. When a sketch begins, you can find the amount of milliseconds that has elapsed by using the millis() function
int changeLevelTimeInterval = 1500; //this variable determines the time between loading levels
boolean changeLevel = false; //boolean variable to check if there is a level transition


//*********************************************************
// ** Character Sprite Animation **
// Create an animation by making a sequence of .png files.
// The files are saved in the sketch /data folder.
//*********************************************************

//Rather than animate the player character in Processing, we load a sequence of images instead
//To pass these images to the Player class object, we store the links to the images in an array of strings
//These images are stored in a "data" folder in the sketch directory
///// NOTE: The data folder is the root for most external file references; when loading external files the sketch will start at the data directory
String[] spriteFilesL = {
  "L1.png", 
  "L2.png", 
  "L3.png", 
  "L4.png", 
  "L5.png", 
  "L6.png",
  "L7.png",
  "L8.png",
  "L9.png"
};

String[] spriteFilesR = {
  "R1.png", 
  "R2.png", 
  "R3.png", 
  "R4.png", 
  "R5.png", 
  "R6.png",
  "R7.png",
  "R8.png",
  "R9.png"
};



//This is way to declare and define an array simultaneously

//We create a "player" object from the "Player" class
//Scroll down to see how the "Player" class is constructed
Player player;


//////////////////////////////////////
////////////    SET UP    ////////////
//////////////////////////////////////

void setup() {
  size(800, 600);

//*********************************************************
// ** Audio Setup **
// Make sure you have a line here for every sound object
// you specified above. The files should be saved in the 
// sketch /data folder.
//*********************************************************

  //We define the minim object as well as the AudioPlayers for sound effects and BGM
  minim = new Minim(this);
  bgmPlayer = minim.loadFile("opening.wav");
  coinPlayer = minim.loadFile("coin.wav");
  teleportPlayer = minim.loadFile("teleport.wav");
  screamPlayer = minim.loadFile("scream.wav");
  L1Player = minim.loadFile("level1.wav");
  L2Player = minim.loadFile("level2.wav");
  L3Player = minim.loadFile("level3.wav");
  bgmPlayer.loop(); //Tell the BGM to play and continuously loop

  //We define the player object here
  //The order of arguments that is passed to create a player is:
  // 1) width of player sprite
  // 2) height of player sprite
  // 3) maximum player speed
  // 4) maximum jump acceleration
  // 5) maximum in-the-air jumps
  // 6) array of sprite animation file links
  player = new Player(playerWidth, playerHeight, maxPlayerSpeed, maxPlayerJumpAcc, maxJumpCount, spriteFilesL, spriteFilesR);

//*********************************************************
// ** Level Definition **
// Create your three levels in this section, by adding and
// positioning as many Platforms, Walls, Coins, and Objectives
// as you need. Use these to make the story of your game.
//*********************************************************

  //We define the game levels with the following lines of code
  //This example has 3 levels in total
  //A level consists of:
  // PLATFORMS: horizontal lines which the character stand on
  // WALLS: vertical lines which the character cannot pass through
  // COINS: objects which will increase the score when the character touches them.
  // OBJECTIVES: portals which are placed in the game level which will take the game to another level/end the game

  // LEVEL ONE
  levels.add(new Level(width/2, height-50)); //Add a new level object to the levels ArrayList
  levels.get(0).addPlatform(new PVector(75, height - 125), 150); //left lower
  levels.get(0).addPlatform(new PVector(width - (150+75), height-125), 150); //right lower
  levels.get(0).addPlatform(new PVector(200, height-250), 400); //large middle
  levels.get(0).addPlatform(new PVector(125, 175), 100); //upper left with color blob
  levels.get(0).addPlatform(new PVector(350, 250), 200);
  levels.get(0).addPlatform(new PVector(0, height-5), width);
  levels.get(0).addWall(new PVector(225, height - 125), 125);
  levels.get(0).addWall(new PVector(550, height-250),100);
  levels.get(0).addCoin(new PVector(175, 100), 0); //Add a coin to the level with the addCoin function
  levels.get(0).addCoin(new PVector(width - 172, height - 200), 0);
  //Add an objective to the level with addObjective function (NOTE: multiple objectives can be added) 
  //Arguments for addObjective: 1) PVector defining objective location, 2) mode to switch to when objective is met
  levels.get(0).addObjective(500, 200, 1); 

  //LEVEL TWO
  levels.add(new Level(700, 350));
  levels.get(1).addPlatform(new PVector(500, 400), 300); //bottom right
  levels.get(1).addPlatform(new PVector(350, 300), 100); //2nd from right
  levels.get(1).addWall(new PVector(350,300),50);
  levels.get(1).addPlatform(new PVector(200, height-200), 100); //3rd from right
  levels.get(1).addPlatform(new PVector(50, 300), 100); //4th from right
  levels.get(1).addCoin(new PVector(100, 250), 0);
  levels.get(1).addPlatform(new PVector(500,200), 100); //top right
  levels.get(1).addWall(new PVector(20, 0), 100);
  levels.get(1).addCoin(new PVector(550, 150), 0);
  levels.get(1).addObjective(width - 50, 100, 2);

  //LEVEL THREE
  levels.add(new Level(700, height-360-playerHeight/2));
  levels.get(2).addPlatform(new PVector(650, 350), 200); //rightmost
  levels.get(2).addPlatform(new PVector(200, 300), 175); //leftmost in ledge hole
  levels.get(2).addPlatform(new PVector(400, 400), 175); //next to right ledge
  levels.get(2).addPlatform(new PVector(200,500), 150); //platform under coin
  levels.get(2).addPlatform(new PVector(120, 175), 100); //upper left
  levels.get(2).addPlatform(new PVector(200, 75), 500);
  levels.get(2).addWall(new PVector(120,175), 100);
  levels.get(2).addCoin(new PVector(275, 450), 20); //coin
  levels.get(2).addObjective(700, 50, -4);
}


///////////////////////////////////////
////////////   DRAW LOOP   ////////////
///////////////////////////////////////

void draw() {
  background(255); //Clear the background to white each loop

//*********************************************************
// ** Change Level Background and add start screen **
// Provide a unique background for every level by adding
// images or shapes in each case. Refer to level 3 for
// an example. You will also need to add a case to create
// a start screen, and change the default case to tbe the end screen. 
//*********************************************************

  //Switch to a case depending on the value of "mode"
  //More information about switch case here: https://processing.org/reference/switch.html
  //Why do cases 0, 1 and 2 look identical?
  //That is because they are! 
  //However, separating them into different cases gives you the flexibility of changing how a particular looks, for example, level three has a yellow background.
  switch(mode) {
  case 0: //LEVEL ONE
    PImage cave = loadImage("Cave.png");
    background(cave);
    if (checkObjective(mode)) { //First we check if the player has reached the objective
      break; //If the objective has been reached, break out of the current draw loop
    }
    levels.get(mode).display(); //Render the level elements (platforms, coins etc.)
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls); //update the player's physics and position if objective has not been met
    }
    player.display(); //Render the player
    checkCoins(mode); //Check if player touches coins
    break;
    
  case 1: //LEVEL TWO
    PImage jungle = loadImage("Jungle.png");
    background(jungle);
    if (checkObjective(mode)) {
      break;
    }
    levels.get(mode).display();
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls);
    }
    player.display();
    checkCoins(mode);
    break;
    
  case 2: //LEVEL THREE
    PImage desert = loadImage("Desert.png");
    background(desert);
    if (checkObjective(mode)) {
      break;
    }
    levels.get(mode).display();
    if (!changeLevel) {
      player.update(levels.get(mode).platforms, levels.get(mode).walls);
    }
    player.display();
    checkCoins(mode);
    break;
    
   case -3: //END SCREEN LOSE
    PImage lose = loadImage("lose.png");
    background(lose);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Aw, Blo didn't escape. Your score is "+score+".", width/2, height-90);
    text("Press spacebar to play again.", width/2, height-60);
    break;
    
  case -4: //END SCREEN WIN
    PImage win = loadImage("win.png");
    background(win);
    textSize(20);
    fill(0);
    textAlign(CENTER, CENTER);
    text("Congrats! You helped Blo escape! Your score is "+score+".", width/2, height-90);
    text("Press spacebar to play again.", width/2, height-60);
    break;
    
  default: //The default case catches all cases not defined above (the case -1 for instance)
    PImage img2 = loadImage("start.png");
    background(img2);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Help Blo escape the shadow land by collecting light orbs!", width/2, height-500);
    text("Press spacebar to begin", width/2, height-60);
    break;
  }
  
  //Draw the score on the top left corner if the game is in progress
  if (mode >= 0) {
    fill(255);
    textAlign(LEFT, TOP);
    text(""+score, 25, 25);
  }
}



///////////////////////////////////////////
////////////   PLAYER OBJECT   ////////////
///////////////////////////////////////////

//This is how you create a custom object class
//For more information, visit: https://processing.org/tutorials/objects/
class Player {
  
  //These are the player's variables
  PVector pos = new PVector(0, 0);
  PVector vel;
  PVector acc;
  float w;
  float h;
  float maxSpeed;
  float jumpYAcc;
  PImage[] spriteL;
  PImage[] spriteR;
  int jumping = 0;
  int jumpCount;
  boolean grounded = false;
  boolean moveSideways = false;
  
  
  //This function instatiates the player (creates the player), along with defining all the required variables
  //Its what happens when you call "new Player(....)" during setup
  Player(float wW, float hH, float mS, float jYA, int jC, String[] sprL, String[] sprR) {
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    w = wW;
    h = hH;
    maxSpeed = mS;
    jumpYAcc = jYA;
    jumpCount = jC;
    spriteL = new PImage[sprL.length];
    for (int i=0; i<sprL.length; i++) {
      spriteL[i] = loadImage(sprL[i]);
    }
    spriteR = new PImage[sprR.length];
    for (int i=0; i<sprR.length; i++) {
      spriteR[i] = loadImage(sprR[i]);
    }
  }
  
  //These are object specific functions
  //"void" simply means it is not returning a value; i.e. a self encapsulated function
  //This function renders the player
  void display() {
    if (keyCode == LEFT) {
        int whichSprite  = floor(pos.x/10)%spriteL.length;
        imageMode(CENTER);
        image(spriteL[whichSprite], pos.x, pos.y, w, h);
    }
    
    if (keyCode == RIGHT) {
        int whichSprite  = floor(pos.x/10)%spriteR.length;
        imageMode(CENTER);
        image(spriteR[whichSprite], pos.x, pos.y, w, h);
    }
    
    if (key == ' ') {
      PImage jumpi = loadImage("L3.png");
      image(jumpi, pos.x, pos.y, w,h );
    }
    
    if((keyCode != LEFT) && (keyCode != RIGHT) && (key != ' ')) {
      PImage rest = loadImage("L1.png");
      image(rest, pos.x, pos.y, w, h);
    }
    
    
  }
  
  //This function updates the player's physics
  //It consists of smaller functions
  void update(ArrayList<Platform> p, ArrayList<Wall> w) {
    calVel();
    calPos(p, w);
  }
  
  //This function updates the player's velocity
  //The player in this sketch runs on a simplified physics engine:
  //User controls the acceleration of a player
  ////Which is integrated (fancy addition basically) to give a velocity
  //////Which is integrated to give position
  //To go all the way, we probably should have started with force and mass (remember... Newton's second law)
  //But, this will suffice
  void calVel() {
  
    //If player is in the air, gravity affects the player, pulling the player down
    //This is a cheating solution to not implement Newton's third law (platform will exert the same force on the body as gravity)
    //Again.. as long as it works.. it works.
    if (jumping > 0 || !grounded) {
      acc.y = acc.y + gravity;
    }
    
    //We add the accelaration to existing velocity
    //This is vector addition, as we are dealing with a 2D game (x and y directions)
    vel = vel.add(acc.x, acc.y);
    
    //If the player is not moving, slow it down each time to 90% of the previous velocity
    //(a cheating solution to not calculate friction)
    if (!moveSideways) {
      vel.x = vel.x * 0.9;
    }
    
    //Cap x velocity at the max speed
    if (vel.x >= maxSpeed) {
      vel.x = maxSpeed;
    } else if (vel.x <= -maxSpeed) {
      vel.x = -maxSpeed;
    }
  }
  
  
  //This function calculates the position of the player
  //as well as interactions with platforms and walls
  void calPos(ArrayList<Platform> plt, ArrayList<Wall> wall) {
    
    //If player is going to hit a wall, stop the player
    //This first checks if the player's body is not below or above the wall
    //Then it checks if collision is imminent
    //If collision is going to happen, stop the player depending if player is approaching wall from the left or from the right
    for (Wall wa : wall) {
      if (pos.y - h/2 < wa.base.y &&  pos.y + h/2 > wa.base.y - wa.h) {
        if (pos.x + w/4 <= wa.base.x && pos.x + w/4 + vel.x > wa.base.x) {
          pos.x = wa.base.x - w/4;
          vel.x = 0;
        } else if (pos.x - w/4 >= wa.base.x && pos.x - w/4 + vel.x < wa.base.x) {
          pos.x = wa.base.x + w/4;
          vel.x = 0;
        }
      }
    }
    
    //Update the player's position by add it to velocity
    //(again, this is vector addition)
    pos = pos.add(vel.x, vel.y);
    
    //Stop player from leaving the left and right edges of the screen
    if (pos.x >= width-w/2) {
      pos.x = width-w/2;
      acc.x = 0;
      vel.x = 0;
    } else if (pos.x <= w/2) {
      pos.x = w/2;
      acc.x = 0;
      vel.x = 0;
    }
    
    //Check which platform player should rest on after landing
    //Essentially, if player is going to collided into platform based on current velocity
    //then, stop the player
    boolean onPlatform = false;
    for (Platform p : plt) {
      if (pos.x > p.pos.x && pos.x < p.pos.x + p.w) {
        if (vel.y >= 0 && abs(pos.y+h/2-p.pos.y) < 2+vel.y) {
          pos.y = p.pos.y - h/2;
          jumping = 0;
          acc.y = 0;
          vel.y = 0;
          onPlatform = true;
        }
      }
    }
    
    //Ensure that player does not land into a wall
    if (!onPlatform) {
      grounded = false;
      for (Wall wa : wall) {
        if (pos.y - h/2 + vel.y < wa.base.y &&  pos.y + h/2 + vel.y > wa.base.y - wa.h) {
          if (wa.base.x > pos.x - w/4 && wa.base.x < pos.x + w/4) {
            if (vel.x > 0) {
              pos.x = pos.x + w/4;
            } else {
              pos.x = pos.x - w/4;
            }
          }
        }
      }
    }
    
    //If player falls through the bottom of the canvas
    //Game ends (and play screamPlayer)
    if (pos.y > height) {
      mode = -3;
      screamPlayer.rewind();
      screamPlayer.play();
    }
  }
  
  
  //Function to run when spacebar (jump) is pressed
  void jump() {
    if (jumping < jumpCount) {
      acc.y = -jumpYAcc;
      vel.y = 0;
      jumping = jumping + 1;
    }
  }
  
  //Function to reset the player variables when a new level is loaded
  void reset() {
    player.acc = new PVector(0, 0);
    player.vel = new PVector(0, 0);
    player.jumping = 0;
    player.grounded = false;
  }
}



/////////////////////////////////////////////
////////////   PLATFORM OBJECT   ////////////
/////////////////////////////////////////////

class Platform {

  PVector pos;
  float w;

  Platform(PVector p, float wW) {
    pos = new PVector(p.x, p.y);
    w = wW;
  }

//*********************************************************
// ** Modify Platform Appearance **
// Change the content inside display() to modify the appearance
// of your platforms. You can do basic math on pos.x and pos.y
// to help you with this. Try adding images or more complex shapes.
//*********************************************************


  void display() {
   //PImage img = loadImage("jungle.png");
    //image(img, 0,0);
    noFill();
    stroke(0);
    strokeWeight(5);
    line(pos.x, pos.y, pos.x+w, pos.y);
  }
}


/////////////////////////////////////////
////////////   WALL OBJECT   ////////////
/////////////////////////////////////////

class Wall {

  PVector base;
  float h;

  Wall(PVector b, float hH) {
    base = new PVector(b.x, b.y);
    h = hH;
  }
  
//*********************************************************
// ** Modify Wall Appearance **
// Change the content inside display() to modify the appearance
// of your walls. You can do basic math on base.x and base.y
// to help you with this. Try adding images or more complex shapes.
//*********************************************************

  void display() {
    noFill();
    stroke(0);
    strokeWeight(5);
    line(base.x, base.y, base.x, base.y-h);
  }
}


/////////////////////////////////////////
////////////   COIN OBJECT   ////////////
/////////////////////////////////////////

class Coin {

  PVector pos;
  float size;
  boolean display = true;

  Coin(PVector p, float s) {
    pos = new PVector(p.x, p.y);
    size = s;
  }

//*********************************************************
// ** Modify Coin Appearance **
// Change the content inside display() to modify the appearance
// of your coins. The line starting with 'float' is an example
// of how you can create a basic looping animation. 
//*********************************************************

  PImage Gem1 = loadImage("Gem1.png");
  PImage Gem2 = loadImage("Gem2.png");
  PImage Gem3 = loadImage("Gem3.png");
  int count = 100;
  void display() {
    if (display) {
        if ((millis() / 1000) % 3 == 0) {
          image(Gem1, pos.x, pos.y);  
        } else if ((millis() / 1000) % 3 == 2) {
          image(Gem2, pos.x, pos.y);
        } else {
          image(Gem3, pos.x, pos.y);
        }
      }

      //float w = size*sin(parseFloat(millis()%1500)/1500*TWO_PI);
      //stroke(100);
      //strokeWeight(2);
      //noFill();
      //ellipse(pos.x, pos.y, w, size);
    }
}


//////////////////////////////////////////
////////////   LEVEL OBJECT   ////////////
//////////////////////////////////////////

class Level {
  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Wall> walls = new ArrayList<Wall>();
  ArrayList<Coin> coins = new ArrayList<Coin>();
  ArrayList<PVector> objectiveLocations = new ArrayList<PVector>();
  ArrayList<Integer> objectiveMode = new ArrayList<Integer>();

  PVector playerPos;

  Level(float x, float y) {
    playerPos = new PVector(x, y);
  }

  void addPlatform(PVector p, float wW) {
    platforms.add(new Platform(p, wW));
  }

  void addWall(PVector b, float hH) {
    walls.add(new Wall(b, hH));
  }

  void addCoin(PVector p, float s) {
    coins.add(new Coin(p, s));
  }

  void resetCoins() {
    for (Coin c : coins) {
      c.display = true;
    }
  }

  void addObjective(float x, float y, int m) {
    objectiveLocations.add(new PVector(x, y));
    objectiveMode.add(m);
  }

//*********************************************************
// ** Change Objective Appearance **
// Change the content inside ''for (PVector p : objectiveLocations) {
// to change the appearance and animation of your objectives.
//*********************************************************  
  
  //Display all the level objects: platforms, walls, coins, objectives
  float a = 0.0;
  float s = 0.0;
  void display() {
    a = a + 0.03;
    s = abs(sin(a));
    
    for (Platform p : platforms) {
      p.display();
    }
    for (Wall w : walls) {
      w.display();
    }
    for (Coin c : coins) {
      c.display();
    }
    for (PVector p : objectiveLocations) {
      
      noFill();
      stroke(0);
      strokeWeight(5);
      pushMatrix();
      translate(p.x, p.y);
      //scale(parseFloat(millis()%2000)/2000*TWO_PI);
      scale(s);
      ellipseMode(CENTER);
      ellipse(30, 30, 30, 30);
      popMatrix();
    }
  }
}


//Function to load a new level
//One argument, the level index in the array list
void loadLevel(int i) {
  if (i >= 0) {
    player.reset();
    levels.get(i).resetCoins();
    player.pos = new PVector(levels.get(i).playerPos.x, levels.get(i).playerPos.y);
  } else {
    
  }
    mode = i;
    
  if (i == 0) {
  L3Player.mute();
  bgmPlayer.mute();
  L2Player.mute();
  
  L1Player.rewind();
  L1Player.unmute();
  L1Player.loop();
  } 
  
  else if (i == 1) {
  L3Player.mute();
  bgmPlayer.mute();
  L1Player.mute();  
    
  L2Player.rewind();
  L2Player.unmute();
  L2Player.loop();
  } 
  
  else if (i == 2) {
  L3Player.mute();
  bgmPlayer.mute();
  L2Player.mute(); 
  
  L3Player.rewind();
  L3Player.unmute();
  L3Player.loop();
  } 
  
  else {
  L1Player.mute();
  L2Player.mute();
  L3Player.mute(); 
  
  bgmPlayer.rewind();
  bgmPlayer.unmute();
  bgmPlayer.loop();
  }
}

//Function to check if player has touched a coin
void checkCoins(int i) {
  if (!changeLevel && mode >= 0) {
    for (Coin c : levels.get(i).coins) {
      float d = PVector.dist(c.pos, player.pos);
      if (d < playerWidth/2 && c.display) {
        coinPlayer.rewind();
        coinPlayer.play();
        score = score + 25;
        c.display = false;
      }
    }
  }
}

//*********************************************************
// ** Change Level Teleportation Effect **
// Change the content inside the 'else if' with the ellipse
// to alter the teleportation effect. Choose one that 
// matches your story.
//********************************************************* 

//Function to check if player has touched an objective
boolean checkObjective(int i) {
  boolean bool = false;
  int count = 0;
  if (!changeLevel) {
    for (PVector p : levels.get(i).objectiveLocations) {
      float d = PVector.dist(p, player.pos);
      if (d < playerWidth/2) {
        teleportPlayer.rewind();
        teleportPlayer.play();
        timeStamp = millis();
        changeLevel = true;
        score = score + 100;
        break;
      }
      count++;
    }
  } else if (changeLevel && timeStamp + changeLevelTimeInterval > millis()) {
    for (int j=0; j<millis()-timeStamp; j=j+20) {
      fill(random(100), random(100), random(100));
      stroke(255);
      ellipse(player.pos.x + random(-playerWidth, playerWidth), player.pos.y + random(-playerHeight, playerHeight), random(20), random(20));
    }
  } else {
    loadLevel(levels.get(i).objectiveMode.get(count));
    changeLevel = false;
    bool = true;
  }
  return bool;
}

//Keyboard functions
//For more information, visit: https://processing.org/tutorials/interactivity/
//TIP: if you are impatient, go straight to the section that talks about "Events"
void keyPressed() {
  if (key == ' ') {
    screamPlayer.pause();
    if (mode >= 0) {
      player.jump();
    } else {
      score = 0;
      loadLevel(0);
    }
  }
  if (keyCode == RIGHT) {
    player.acc.x = player.acc.x + horizontalAcc;
    player.moveSideways = true;
  } else if (keyCode == LEFT) {
    player.acc.x = player.acc.x - horizontalAcc;
    player.moveSideways = true;
  }
}

void keyReleased() {
  if (keyCode == RIGHT || keyCode == LEFT) {
    player.acc.x = 0;
    player.moveSideways = false;
  }
}