/*
* Created by : James Theobald, Zainab Bolarinwa, Shashank Gupta
* Date : 02/16/2015
*/

//import ddf.minim.*;
import java.awt.AWTException;
import java.awt.Robot;

import java.awt.MouseInfo;
import java.awt.GridLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.MouseListener;
import java.awt.event.MouseEvent;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

 
import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;


//Recoil
Robot Recoil;

PImage Border;
PImage Day;
PImage Buildings;
PImage Clouds;
PImage Sun;
PImage LightPost;
PImage Night;
PImage NightLights;

PImage NightVision;


PImage AK47;
PImage Blood;
PImage Raven;
PImage Smoke;
PImage Zombie1;
PImage Zombie2;
PImage Zombie3;
PImage Zombie4;
PImage Title;
PImage Menu1;
PImage Menu1Text1;
PImage Menu2Text1;
PImage Menu3Text1;
PImage Play;
PImage Crosshair;
PImage Trash;
PImage Wall;
PImage Barrier;
PFont font;
XML xml;

//AudioPlayer fireWeapon;
//AudioPlayer buildObject;
//AudioPlayer noAmmo;
//AudioPlayer selectMenu;
//AudioPlayer soundTrack1;
//Minim minim;//audio context

public class Object{

  private int id;
  private int x;
  private int y;
  private int hitPoints;
  private int cost;
  private int boxSize = 40;
  
  private int AttackSpeed; 
  private int AttackPoints; 
  private int AttackTimer; 
  
  public int getX(){
    return x;
  }
  public int getY(){
    return y; 
  }
  public int getID(){
    return id;
  }
  public int getHitPoints(){
    return hitPoints;
  }
  public int getCost(){
    return cost;
  }
  
  public void setX(int x){
    this.x = x;
  }
  public void setY(int y){
    this.y = y; 
  }
  
  public void setLocation(int x, int y){
    this.x = x;
    this.y = y;   
  }
  
  public void setID(int id){
    this.id = id;
  }
  public void setHitPoints(int hitPoints){
    this.hitPoints = hitPoints;
  }
  
  public Object(int id, int hitPoints){
    this.id = id;
    this.hitPoints = hitPoints;
  } 
  public void setCost(int cost){
    this.cost = cost;
  }
  
  public Object(int id, int x, int y){
    this.id = id;
    this.x = x;
    this.y = y;
  }
  public boolean drawObj(){
    if(x < 0 || x > width || y < 0 || y > height) 
      return false;
      
    if(id == 1){         
      image(Trash, x, y);
    }else if(id == 2){
      image(Barrier, x, y);
    }else if(id == 3){ 
      image(Wall, x,y);
      
    }else if(id == 11){ 
      image(Zombie3, x,y);
    }else if(id == 12){
      //imageMode(CORNER);
      image(Zombie3, x,y);
    }
  
    return true;  
  }

  public void drawInfo(){
    textFont(font); 
    textAlign(CENTER);  
    fill(255,0,255);
    text("HP " + hitPoints, x, y-60); 
  }
  public void drawBox(){
    // Bottom -
    line(x - boxSize, y - boxSize, x + boxSize, y - boxSize);
    // Top -
    line(x - boxSize, y + boxSize, x + boxSize, y + boxSize);
    // Left |
    line(x - boxSize, y - boxSize, x - boxSize, y + boxSize);
    // Right |
    line(x + boxSize, y - boxSize, x + boxSize, y + boxSize); 
    
  }
  public boolean isMouseOver(){
    if(mouseX >  x - boxSize && mouseX <  x + boxSize &&
       mouseY >  y - boxSize && mouseY <  y + boxSize){
      return true;
    } 
    return false;
  }
  public boolean isObjectOver(Object obj){
    if(obj.getX() >  x - boxSize && obj.getX() <  x + boxSize &&
       obj.getY() >  y - boxSize && obj.getY() <  y + boxSize){
      return true;
    } 
    return false;
  }
};

class surviverz{

  private String name;
  private int level;
  private int Time; 
  private time Time2;
  
  surviverz []Surviverz = new surviverz[3];
  
  void load(){
    xml = loadXML("surviverz.xml");
    XML[] children = xml.getChildren("surviver");
        
    for (int i = 0; i < 3; i++) {
      Surviverz[i] = new surviverz();
      Surviverz[i].name = children[i].getString("name");
      Surviverz[i].level  = children[i].getInt("level");
      Surviverz[i].Time = children[i].getInt("time"); 
      Surviverz[i].Time2 = new time();
      Surviverz[i].Time2.setSum(Surviverz[i].Time);    
    }    
  }
};
surviverz Survivers = new surviverz();

class level{
  private int num;
  private String name;
  private int theme;
  
  private int numZombies; 
  private int spawZTime; 
  private int zombieHit; 
  private int zombieRunSpeed; 
  private int zombieMoney; 
  private int zombieAttackSpeed; 
  private int zombieAttackPoints; 
  
  private int numSuperZombies;
  private int spawSZTime;
  private int superZombieHit; 
  private int superZombieRunSpeed;  
  private int superZombieMoney;
  private int superZombieAttackSpeed; 
  private int superZombieAttackPoints; 
  
  private boolean setup = false;
  private boolean complete = false;   
  /*returns min time*/
  int getTotalTime(){
    int zombieTime = spawZTime * numZombies;
    int szombieTime = spawSZTime * numSuperZombies;
    if(zombieTime > szombieTime)
      return zombieTime;
    else
      return szombieTime;
  }
};

class time{
  public int oHour;
  public int oMinute;
  public int oSecond; 
  public int oTime;
  
  void setSum(int sum){
    oTime = sum; 
    
    this.oHour = sum / (60 * 60);
    sum-= (this.oHour * (60 * 60));
    this.oMinute = sum / (60);
    sum-= (this.oMinute * (60));
    this.oSecond = sum;
  }  
  
  void set(int oHour, int oMinute, int oSecond){
    this.oHour = oHour;
    this.oMinute = oMinute;
    this.oSecond = oSecond;
    oTime = oSecond + (oMinute * 60) + (oHour * 60 * 60);
  }
  
  time diff(int Hour, int Minute, int Second){
    time oNewTime = new time();
    
    int diff = (Second + (Minute * 60) + (Hour * 60 * 60)) - oTime;
    
    int newHour = diff / (60 * 60);
    diff-= (newHour * (60 * 60));
    int newMinute = diff / (60);
    diff-= (newMinute * (60));
    int newSecond = diff;
    
    oNewTime.set(newHour,newMinute,newSecond);
    
    return oNewTime;
  }
};

/*OBJECTS*/
final int TRASHCAN_COST = 10;
final int PILONNEN_COST = 20;
final int WALL_COST     = 40;
final int AMMO_COST     = 100;
final int NVG_COST      = 1500;
final int RF_COST       = 2000;

final int TRASHCAN_HITS = 2;
final int PILONNEN_HITS = 5;
final int WALL_HITS     = 10;

boolean NVG_PAID_FOR       = false;
boolean RF_PAID_FOR        = false;
int AMMO_AMMOUNT_PAID_FOR  = 20;
boolean NVG = false;
boolean RF = false;

/*Levels*/
level gameLevels[];

Object[] oBuild = new Object[100];
int buildingCounter = 0;

Object[] oZombie = new Object[100];
int zombieCounter = 0;

/*Creating object*/
Object newObject;

/*Local Player*/
int money = 1000;
int bulletCount = 100;
boolean startTimer = false;
int currentLevel = 0;
int lives = 5;
int weponDamage = 1;
time survivalTime;

int getObjectCount(Object obj[]){
  int count = 0;
  for(int x = 0; x < obj.length; x++){
    if(obj[x] != null)
      count++;
  }
  return count;
}

int deleteObjectAt(Object obj[], int removeIndex, int counter){
  obj[removeIndex] = null; //Cant delete the object?
  for(int x = removeIndex; x < obj.length; x++){
    if(obj[x + 1] != null){ 
      obj[x] = obj[x + 1];
      obj[x + 1] = null;
    }else{
     break;
   }
  }
  return --counter; //wtf no pass by reference... 
}
int getAbsolute(int value){
  if(value < 0)
    return (value * -1);
  return value;
}
boolean canPlaceObjec(Object obj[], Object newObject){
  final int objDist = 35;
  for(int x = 0; x < obj.length; x++){
    if(obj[x] != null){
      int diff = getAbsolute(newObject.getX() - obj[x].getX());     
      if( diff <= objDist){
        return false;
      }
    }
  }
  return true;
}

boolean buyObject(int type, int hits, int cost){  
  if(newObject == null){ //Check we are not already creating an object
    if(money - cost >= 0){  //Check if we have the money
      newObject = new Object(type, hits);  //create new object
      money -= cost;  //Sub the money
      println("Payed : " + cost);
      return true;
    }else{
      println("Not enough money : " + (money - cost));
      return false;
    }
  }else{
    println("Already Creating an object");   
    return false;   
  }
}
boolean buyItem(int cost){  
  if(money - cost >= 0){  //Check if we have the money
    money -= cost;  //Sub the money
    println("Payed : " + cost);
    return true;
  }else{
    println("Not enough money : " + (money - cost));
    return false;
  }
}

void loadLevels() {
  xml = loadXML("levels.xml");
  XML[] children = xml.getChildren("level");
  
  gameLevels = new level[children.length];
  
  for (int i = 0; i < children.length; i++) {
    gameLevels[i] = new level();
    gameLevels[i].num = children[i].getInt("num");
    gameLevels[i].name  = children[i].getString("name");
    gameLevels[i].theme = children[i].getInt("theme");
    
    gameLevels[i].numZombies = children[i].getInt("numZombies");
    gameLevels[i].spawZTime = children[i].getInt("spawZTime");
    gameLevels[i].zombieHit = children[i].getInt("zombieHit");
    gameLevels[i].zombieRunSpeed = children[i].getInt("zombieRunSpeed");
    gameLevels[i].zombieMoney = children[i].getInt("zombieMoney");    
    gameLevels[i].zombieAttackSpeed = children[i].getInt("zombieAttackSpeed"); 
    gameLevels[i].zombieAttackPoints = children[i].getInt("zombieAttackPoints"); 

  
    gameLevels[i].numSuperZombies = children[i].getInt("numSuperZombies");
    gameLevels[i].spawSZTime = children[i].getInt("spawSZTime");
    gameLevels[i].superZombieHit = children[i].getInt("superZombieHit");
    gameLevels[i].superZombieRunSpeed = children[i].getInt("superZombieRunSpeed"); 
    gameLevels[i].superZombieMoney = children[i].getInt("superZombieMoney"); 
    gameLevels[i].superZombieAttackSpeed = children[i].getInt("superZombieAttackSpeed"); 
    gameLevels[i].superZombieAttackPoints = children[i].getInt("superZombieAttackPoints");  
    
  }
}

void setup() {
  // Images must be in the "data" directory to load correctly
  Border = loadImage("Border.png");
  Day = loadImage("Day.jpg");
  Buildings = loadImage("Buildings.png"); 
  Clouds = loadImage("Clouds.png");  
  Sun = loadImage("Sun.png");   
  AK47 = loadImage("AK47.png");   
  Blood = loadImage("Blood.png");   
  Raven = loadImage("Raven.png");   
  Smoke = loadImage("Smoke.png");   
  Zombie1 = loadImage("Zombie1.png");   
  Zombie2 = loadImage("Zombie2.png"); 
  Zombie3 = loadImage("Zombie3.png"); 
  Zombie4 = loadImage("Zombie4.png");  
  Title = loadImage("Title.png");   
  Menu1 = loadImage("Menu1.png");    
  Menu1Text1  = loadImage("Menu1Text1.png");  //mainMenu
  Menu2Text1  = loadImage("Menu2Text1.png");  //creditzMenu
  Menu3Text1  = loadImage("Menu3Text1.png");  //surviverzMenu
  Play = loadImage("Play.png");  //playMenu
  Crosshair = loadImage("Crosshair.png");
  Trash = loadImage("Trash.png");
  Wall = loadImage("Wall.png");
  Barrier = loadImage("Barrier.png");
  
  Night = loadImage("Night.jpg");
  NightLights = loadImage("NightLights.png");
  NightVision = loadImage("NightVision.png");
  LightPost= loadImage("LightPost.png");
  
  //MP3
 // minim = new Minim(this);
  //fireWeapon = minim.loadFile("GUN_FIRE-GoodSoundForYou-820112263.mp3", 2048);
  //buildObject = minim.loadFile("Drilling From Drill-SoundBible.com-320730880.mp3", 2048); 
  //noAmmo = minim.loadFile("Dry Fire Gun-SoundBible.com-2053652037.wav", 2048);
  //selectMenu = minim.loadFile("Large Metal Clippers 1x-SoundBible.com-2064394756.mp3", 2048);
  //soundTrack1 = minim.loadFile("Cowboy_Theme-Pavak-1711860633.mp3", 2048);
  //Font
  font = createFont("Arial",16,true); 
  
  //Other
  size(1278, 745);
  frameRate(60);
  
  //Intro SoundTrack
  //soundTrack1.play();
  
  //LoadLevels
  loadLevels();
   
  //Recoild on mouse..
  try{
  Recoil = new Robot(); 
  }catch (AWTException e) {
    println("Robot class not supported by your system! Recoil will not be applied!");
  }
 
  
}

void playMenySound(){
 // selectMenu.play();
  //selectMenu.rewind();  
}
int timer = 0;
int FPS = 0;
int sec = 0;
/*Only Call 1 timer per frame*/
int GetFPS(){
  timer++;
  int dif = second() - sec;

  if(dif > 0){
    sec = second();
    FPS = timer/dif; 
    timer = 0;
  }
  return FPS;
}


int skyCounter = 0;
int titleCounter = 0;
int ZombieCounter = 0;
int ZombieA = 255;
int gunCounter = 0;

final int INTRO_TIME = 255/2;
/*
 mainMenu       1
 playMenu       2
 surviverzMenu  3
 creditzMenu    4
*/

int HUD_Create = 0;
int HUD_Sate = 1;
void draw() {
  
  textFont(font); 
  skyCounter++;
  titleCounter++;
  ZombieCounter++;
  gunCounter++;
  
  /*Zombie and Sky Reset code*/
  if(skyCounter > 4500) skyCounter = -4500;
  if(gunCounter > 5) gunCounter = 0;
  
  if(ZombieCounter > 2000){
     if(ZombieCounter > 2500){
        ZombieCounter = -1500;
     }else{
       ZombieA--;
     }
  }else{
    ZombieA = 255; 
  }
  
  background(255);
  
  if(HUD_Sate != 2){
    image(Day, 0, 0);
    image(Buildings, 0, 0);
    image(LightPost, 0, 0);
    image(Sun, 0, 0);  
    image(Clouds, (skyCounter / 4), 0); 
    image(Smoke, 0, 0); 
    
    image(Blood, 0, 0);
    tint(255, ZombieA);
    image(Zombie1, (ZombieCounter / 4), 590); 
    image(Zombie4, (ZombieCounter / 4) + (90 * 1), 590); 
    image(Zombie3, (ZombieCounter / 4) + (90 * 2), 590); 
    image(Zombie2, (ZombieCounter / 4) + (90 * 3), 590);    
    tint(255, 255);
    
    tint(255, titleCounter);
    image(Title, 0, 0); 
    image(Menu1, 0, 0);
    
  }else{
    //level themes...
    if(gameLevels[currentLevel].theme == 1){
      image(Day, 0, 0);
      image(Buildings, 0, 0);
      image(LightPost, 0, 0);      
      image(Sun, 0, 0);  
      image(Clouds, (skyCounter / 4), 0); 
      image(Smoke, 0, 0);    
      
    }else if(gameLevels[currentLevel].theme == 2){
      image(Night, 0, 0); 
      image(Buildings, 0, 0);
      image(LightPost, 0, 0);      
    }
  }
  tint(255, 255);
  image(AK47, gunCounter, 0); 
  image(Raven, 0, 0); 
  
  
  
  if(HUD_Sate == 1)
    image(Menu1Text1, 0, 0);
  //else if(HUD_Sate == 2)
  //  image(Play, 0, 0);  
  else if(HUD_Sate == 3)
    image(Menu3Text1, 0, 0);  
  else if(HUD_Sate == 4)
    image(Menu2Text1, 0, 0);
     
  tint(255, 255);
  
  
  //mainMenu
  if(titleCounter > INTRO_TIME && HUD_Sate == 1){
    //454 : 316 - 798 : 365
    if(mouseX > 452 & mouseX < 798 && mouseY > 313 && mouseY < 313 + 53){  
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,313,346,53); 
    //452 : 369 - 798 : 418
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 367 && mouseY < 367 + 53){
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,367,346,53);      
    //452 : 414 - 799 : 471
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 419 && mouseY < 419 + 53){
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,419,346,53);       
    //452 : 464 - 799 : 518
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 472 && mouseY < 472 + 53){
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,472,346,53);     
    }
  
  //surviverzMenu
  }else if(HUD_Sate == 3){
    Survivers.load();
    text(Survivers.Surviverz[0].name, 470, 420);  text(Survivers.Surviverz[0].level + "         " + Survivers.Surviverz[0].Time2.oHour + ":" + Survivers.Surviverz[0].Time2.oMinute + ":" + Survivers.Surviverz[0].Time2.oSecond , 645, 420);
    text(Survivers.Surviverz[1].name, 470, 450);  text(Survivers.Surviverz[1].level + "         " + Survivers.Surviverz[1].Time2.oHour + ":" + Survivers.Surviverz[1].Time2.oMinute + ":" + Survivers.Surviverz[1].Time2.oSecond , 645, 450);     
    text(Survivers.Surviverz[2].name, 470, 480);  text(Survivers.Surviverz[2].level + "         " + Survivers.Surviverz[2].Time2.oHour + ":" + Survivers.Surviverz[2].Time2.oMinute + ":" + Survivers.Surviverz[2].Time2.oSecond , 645, 480); 
    
    if(mouseX > 452 & mouseX < 798 && mouseY > 472 && mouseY < 472 + 53){
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,472,346,53); 
    }  
    
  //creditzMenu
  }else if(HUD_Sate == 4){
    text("James Theobald\nZainab Bolarinwa\nShashank Gupta\n", 570, 400); 
    if(mouseX > 452 & mouseX < 798 && mouseY > 472 && mouseY < 472 + 53){
      stroke(255, 0, 0);
      fill(0,0,0,0);
      rect(452,472,346,53);   
    }

    
  //playMenu
  /*Game Code*/
  }else if(HUD_Sate == 2){
    
    /*Setup - startTimer & intro Soundtrack*/
    if(startTimer == false){
      startTimer = true;
      survivalTime = new time();
      survivalTime.set(hour(), minute(), second());
      //if(soundTrack1.isPlaying()){
      //  soundTrack1.pause();    
      //}   
    }
    
    imageMode(CENTER);
    
    /*Get current Level*/   
    for(int x = 0; x < gameLevels.length; x++){
      if(gameLevels[x].complete == false){
        currentLevel = x;
        break;
      } 
    }
    
    /*Check if level is compeleted (All Zombies dead)*/
    if(zombieCounter == 0 && gameLevels[currentLevel].setup){
      println("Level [" + currentLevel + "] " + gameLevels[currentLevel].name + " is complete"); 
      gameLevels[currentLevel].complete = true;
    }

    /*Setup level*/
    if(gameLevels[currentLevel].setup == false){
      println("Setup level : " + gameLevels[currentLevel].name); 
      gameLevels[currentLevel].setup = true;
      zombieCounter = gameLevels[currentLevel].numZombies;
      for(int x = 0; x < gameLevels[currentLevel].numZombies; x++){
        /*Need to check is zombie 11 or super zombie 12*/
        oZombie[x] = new Object(11, gameLevels[currentLevel].zombieHit); 
        oZombie[x].AttackSpeed =  gameLevels[currentLevel].zombieAttackSpeed;
        oZombie[x].AttackPoints = gameLevels[currentLevel].zombieAttackPoints; 
        oZombie[x].AttackTimer = 0;
        //Set Zombies off screen, should be time based...
        oZombie[x].setLocation(-1 * x * gameLevels[currentLevel].spawZTime * 10, 675);         
      }
    }
  
    /*Draw Zombies*/
    for(int x = 0; x < zombieCounter; x++){ 
      boolean hitObject = false; 
      if(oZombie[x] == null) continue;
      textAlign(LEFT);  
      fill(255,0,255);
      //text("Zombie : " + oZombie[x], 750, 25 + (x * 16)); 
      if(oZombie[x].drawObj() == true){
        oZombie[x].drawInfo();
        
        /*Check if Zombies made it past the Raven*/
        if(oZombie[x].getX() > width - 1){
          println("Zombie made it past you!");
          zombieCounter = deleteObjectAt(oZombie, x, zombieCounter);
          lives--;
          continue;
        }
          
        //if(oZombie[x].isMouseOver()){
        //  oZombie[x].drawBox(); 
        //}
        
        /*Zombie Physics*/
        /*Add in Zombie Speed*/
        for(int i = 0; i < buildingCounter; i++){  
          if(oBuild[i] == null) continue; 
           
          if(oBuild[i].isObjectOver(oZombie[x])){
            hitObject = true;
            
            /*Zombie Attack*/
            int currentTime = (hour() * 60 * 60) + (minute() * 60) + second();
            if(oZombie[x].AttackTimer < currentTime){
              oZombie[x].AttackTimer = currentTime + oZombie[x].AttackSpeed; 
              
              println("Zombie attacked object " + i + " for " + oZombie[x].AttackPoints + " points");
              oBuild[i].setHitPoints(oBuild[i].getHitPoints() - oZombie[x].AttackPoints);
              if(oBuild[i].getHitPoints() <= 0){
                buildingCounter = deleteObjectAt(oBuild, i, buildingCounter);
                println("Zombie destroyed object " + i);
              }
              
            }
            continue;
          }
        }
      }
      if(hitObject == false)
        oZombie[x].setLocation(oZombie[x].getX() + 1, 645);  
    }
    
    /*Check if you are out of lives*/
    if(lives <= 0){
      
      int select = -1;
      //Update best time...
      if(Survivers.Surviverz[0].level < currentLevel){
        select = 0;
      }else if(Survivers.Surviverz[1].level < currentLevel){
        select = 1;    
      }else if(Survivers.Surviverz[2].level < currentLevel){
        select = 2;       
      }
      if(select >= 0){   
        time tempTime = survivalTime.diff(hour(), minute(), second());
        
        Survivers.Surviverz[0].level = currentLevel;
        Survivers.Surviverz[0].Time = tempTime.oTime;
        Survivers.Surviverz[0].name = System.getProperty("user.name");
      
        //Write to xml
        PrintWriter output = createWriter("surviverz.xml"); 
        output.println("<?xml version=\"1.0\"?>");
        output.println("<surviverz>");
        output.println("  <surviver name=\"" + Survivers.Surviverz[0].name + "\" level=\"" + Survivers.Surviverz[0].level + "\" time=\"" + Survivers.Surviverz[0].Time + "\"></surviver>");
        output.println("  <surviver name=\"" + Survivers.Surviverz[1].name + "\" level=\"" + Survivers.Surviverz[1].level + "\" time=\"" + Survivers.Surviverz[1].Time + "\"></surviver>");
        output.println("  <surviver name=\"" + Survivers.Surviverz[2].name + "\" level=\"" + Survivers.Surviverz[2].level + "\" time=\"" + Survivers.Surviverz[2].Time + "\"></surviver>");
        output.println("</surviverz>");
        output.flush(); // Writes the remaining data to the file
        output.close(); // Finishes the file
      }
      
      /*Delete all objects and zombies, and reset levels, lives.. time.. ammo.. money...*/ 
      //Set Main Menu
      HUD_Sate = 1;
      
      //Clean up zombies...
      for(int x = 0; x < zombieCounter; x++){ 
        deleteObjectAt(oZombie, x, zombieCounter); 
      }
      //Clean up objects...      
      for(int i = 0; i < buildingCounter; i++){ 
        deleteObjectAt(oBuild, i, buildingCounter);    
      }
      //Reset all stuffz...
      money = 1000;
      bulletCount = 100;
      startTimer = false;
      currentLevel = 0;
      lives = 5;
      weponDamage = 1;  
      
      loadLevels();
    }
   
   
    /*Draw placed Objects [Walls/Trash/...]*/
    for(int x = 0; x < buildingCounter; x++){  
      if(oBuild[x] == null) continue;
      textAlign(LEFT);  
      fill(255,0,255);
      //text("Object : " + oBuild[x], 300, 25 + (x * 16)); 
      oBuild[x].drawObj();
      oBuild[x].drawInfo();
      
      //if(oBuild[x].isMouseOver())
      //  oBuild[x].drawBox();     
    }
    
    imageMode(CORNER);
    
    //Night Theme overlay...
    if(HUD_Sate == 2){
      if(gameLevels[currentLevel].theme == 2){
        if(NVG == false)
          image(NightLights, 0, 0); 
        else
          image(NightVision, 0, 0);    
      }
    }
    

    
    //Menu
    image(Play, 0, 0);  
    
    textAlign(LEFT);  
    fill(255);
    
    //Display Survival Time  
    if(startTimer == true){
      time tempTime = survivalTime.diff(hour(), minute(), second());
      text((tempTime.oHour) + ":" + (tempTime.oMinute) + ":" + (tempTime.oSecond), 130, 310 + (35 * 0));
    }  
    
    //Display Ammo on UI
    text(bulletCount, 130, 310 + (35 * 1));
    
    //Display money
    text("$" + money, 130, 310 + (35 * 2));
    
    //Display Lives    
    text("" + lives,  130, 310 + (35 * 3)); 
    
    //Display Level Name and number Text   
    text(currentLevel + " | " + gameLevels[currentLevel].name, 130, 310 + (35 * 4));
    
    //Buy Supper Ammo Text
    if(RF_PAID_FOR == false){
      text("$" + RF_COST, 195, 163);
    }else{
      if(RF){
        text("ON", 195, 163);       
      }else{
        text("OFF", 195, 163);             
      }
    }
    //Buy NVG Text
    if(NVG_PAID_FOR == false){
      text("$" + NVG_COST, 195, 194);
    }else{
      if(NVG){
        text("ON", 195, 194);       
      }else{
        text("OFF", 195, 194);             
      }
    }
    //Buy Ammo
    text("[" + AMMO_AMMOUNT_PAID_FOR + "] $" + AMMO_COST, 165, 225);

    //Trash Can
    text("$" + TRASHCAN_COST + "                        " + TRASHCAN_HITS, 1100, 280);
 
    //Trash Can
    text("$" + PILONNEN_COST + "                        " + PILONNEN_HITS, 1100, 280 + 90);

    //Trash Can
    text("$" + WALL_COST     + "                        " + WALL_HITS, 1100, 280 + 190);
    
    imageMode(CENTER);
    /*Buy Menu OutLine*/
    //Buy Trashcan    
    if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210+(0 * 85)+10 && mouseY < 210 + (1 * 85)){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(1087,210,180,85); 
    //Buy Pilonnen          
    }else if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210+(1 * 85)+20 && mouseY < 210 + (2 * 85)+10){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(1087,210+(1 * 85)+10,180,85);  
    //Buy Wall        
    }else if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210+(2 * 85)+30 && mouseY < 210 + (3 * 85)+20){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(1087,210+(2 * 85)+20,180,85);
    //Buy / Toggle Fire Rate    
    }else if(mouseX > 15 && mouseX < 15+225 && mouseY > 142+(0 * 30) && mouseY < 142 + (1 * 30)){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(15,(0 * 30)+142,225,30);        
    //Buy / Toggle NVG    
    }else if(mouseX > 15 && mouseX < 15+225 && mouseY >142+(1 * 30) && mouseY < 142 + (2 * 30)){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(15,(1 * 30)+142,225,30);         
    //Buy Ammo    
    }else if(mouseX > 15 && mouseX < 15+225 && mouseY >142+(2 * 30) && mouseY < 142 + (3 * 30)){
        stroke(255, 0, 0);
        fill(0,0,0,0);
        rect(15,(2 * 30)+142,225,30); 
    }
    
    /*Draw objected when placing it*/
    if(newObject != null){
      switch(newObject.getID()) {
        case 1: 
          image(Trash, mouseX, mouseY); 
          break;
        case 2: 
          image(Barrier, mouseX, mouseY);
          break;
        case 3: 
          image(Wall, mouseX, mouseY);
          break;      
      }
    }
    
    imageMode(CORNER);
  }
 
    
  //Border
  image(Border, 0, 0);

  
  //FPS 
  textAlign(LEFT);  
  fill(255);
  text("FPS : " + GetFPS(), 11, 25); 
  text("Time : " + hour() + ":" + minute() + ":" + second(), 11, 25 + 16); 
  
  //Dev Info
  /*int line = 25;
  text("Debug info ", 11, 25 + (line * 16));line++;
  text("oBuild Count : " + getObjectCount(oBuild) + " | " + buildingCounter, 11, 25 + (line * 16));line++; 
  text("oZombie Count : " + getObjectCount(oZombie) + " | " + zombieCounter, 11, 25 + (line * 16));line++;  
  text("money : " + money, 11, 25 + (line * 16));line++;
  text("ammo : " + bulletCount, 11, 25 + (line * 16));line++;
  if(startTimer == true){
    time tempTime = survivalTime.diff(hour(), minute(), second());
    text("Survival Time : " + (tempTime.oHour) + ":" + (tempTime.oMinute) + ":" + (tempTime.oSecond), 11, 25 + (line * 16));line++;
  }
  text("Level : " + gameLevels[currentLevel].name, 11, 25 + (line * 16));line++;
  text("Lives : " + lives, 11, 25 + (line * 16));line++;
  */
  
  //Crosshair
  imageMode(CENTER);
  image(Crosshair, mouseX+7, mouseY+45);
  imageMode(CORNER);
}

void mousePressed(){

  //mainMenu
  if(titleCounter > INTRO_TIME && HUD_Sate == 1){
    //play
    if(mouseX > 452 & mouseX < 798 && mouseY > 313 && mouseY < 313 + 53){  
      HUD_Sate = 2;
      playMenySound();
    //survuvers
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 367 && mouseY < 367 + 53){
      HUD_Sate = 3;
      playMenySound();
    //credits
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 419 && mouseY < 419 + 53){
       HUD_Sate = 4;
       playMenySound();
    //exit
    }else if(mouseX > 452 & mouseX < 798 && mouseY > 472 && mouseY < 472 + 53){
      exit(); 
    }
 
  //creditzMenu
  }else if(HUD_Sate == 3){
    if(mouseX > 452 & mouseX < 798 && mouseY > 459 && mouseY < 459 + 53){
      HUD_Sate = 1;
      playMenySound();
    }  

  //creditzMenu
  }else if(HUD_Sate == 4){
    if(mouseX > 452 & mouseX < 798 && mouseY > 459 && mouseY < 459 + 53){
      HUD_Sate = 1;
      playMenySound();
    }

  //playMenu
  }else if(HUD_Sate == 2){
        
    /*Build*/
    if (mouseButton == LEFT){
      if(buildingCounter < oBuild.length){
        //Buy Trashcan
        if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210 && mouseY < 210 + 85){
          buyObject(1, TRASHCAN_HITS, TRASHCAN_COST);
          playMenySound();
        //Buy Pilonnen          
        }else if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210+(1 * 85)+10 && mouseY < 210 + (2 * 85)+10){
          buyObject(2, PILONNEN_HITS, PILONNEN_COST);
          playMenySound();
        //Buy Wall            
        }else if(mouseX > 1087 && mouseX < 1087+180 && mouseY >210+(2 * 85)+20 && mouseY < 210 + (3 * 85)+20){
          buyObject(3, WALL_HITS, WALL_COST);
          playMenySound();
        //Buy / Toggle Fire Rate    
        }else if(mouseX > 15 && mouseX < 15+225 && mouseY > 142+(0 * 30) && mouseY < 142 + (1 * 30)){
          if(RF_PAID_FOR){
            RF = !RF;
            if(RF)
              weponDamage = 2;
            else
              weponDamage = 1;
          }else{
            RF_PAID_FOR = buyItem(RF_COST);
          }
          playMenySound();         
        //Buy / Toggle NVG    
        }else if(mouseX > 15 && mouseX < 15+225 && mouseY >142+(1 * 30) && mouseY < 142 + (2 * 30)){
          if(NVG_PAID_FOR){
            NVG = !NVG;
          }else{
            NVG_PAID_FOR = buyItem(NVG_COST);
          }
          playMenySound();   
        //Buy Ammo    
        }else if(mouseX > 15 && mouseX < 15+225 && mouseY >142+(2 * 30) && mouseY < 142 + (3 * 30)){
          if(buyItem(AMMO_COST)){
            bulletCount += AMMO_AMMOUNT_PAID_FOR;
          }
          playMenySound();              
        }else{ 
          if(newObject != null){
            newObject.setLocation(mouseX, 675);
            if(canPlaceObjec(oBuild, newObject)){          
              oBuild[buildingCounter++] = newObject;
              newObject = null;
             // buildObject.play();
              //buildObject.rewind();
              println("Placed Object");
            }else{
              println("Object is to close to another"); 
            }
          }
        }  
      }
      
    /*Fire Weapon*/
    }else if (mouseButton == RIGHT){

      //Recoil
      if(Recoil != null){
        Recoil.mouseMove(MouseInfo.getPointerInfo().getLocation().x+(2 * 90 * weponDamage), 
                         MouseInfo.getPointerInfo().getLocation().y-(2 * 60* weponDamage));
      }
      
      if(bulletCount > 0){
        bulletCount--;
        //fireWeapon.play();
        //fireWeapon.rewind();
        println("Shot Fired");

        /*Hit Object*/
        for(int x = 0; x < buildingCounter; x++){    
          if(oBuild[x] == null) continue;
          if(oBuild[x].isMouseOver()){
            println("Hit object " + x + " for " + weponDamage);
            oBuild[x].setHitPoints(oBuild[x].getHitPoints() - weponDamage);
            if(oBuild[x].getHitPoints() <= 0){
              buildingCounter = deleteObjectAt(oBuild, x, buildingCounter);
              println("Destroyed object " + x);
            }
            break;
          }
        }
        /*Hit Object*/
        for(int x = 0; x < zombieCounter; x++){  
          if(oZombie[x] == null) continue;
          if(oZombie[x].isMouseOver()){
            println("Hit Zombie " + x + " for " + weponDamage);
            oZombie[x].setHitPoints(oZombie[x].getHitPoints() - weponDamage);
            if(oZombie[x].getHitPoints() <= 0){
              zombieCounter = deleteObjectAt(oZombie, x, zombieCounter);
              money += gameLevels[x].zombieMoney;
              println("Killed Zombie " + x + ", Added Money : " + gameLevels[x].zombieMoney);                     
            }
            break;              
          }        
        }
      }else{
       // noAmmo.play();
      //  noAmmo.rewind();    
        println("No Ammo"); 
      }   
    }
  }
  
  //Dev Info  
  //println(mouseX + " : " + mouseY);
}


void stop()
{
 // soundTrack1.close();
 // selectMenu.close();
  //noAmmo.close();
  //fireWeapon.close();
  //buildObject.close();
  //minim.stop();
  //super.stop();
}