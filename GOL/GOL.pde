// Mingde Yin GOL
// Aug 31, 2020


/*

INIT

*/

final int TILE_SIZE = 20;
final int PADDING = 1;

final int GRID_OFFSET = 100;

final int GRID_W = 50;
final int GRID_H = 25;

GTile[][] tiles; // tiles for map
PlayPauseButton pBtn; // button to play and pause

int MODE = 0;

// 0 -- placing, 1 -- playing


/*

MAIN CODE

*/

void setup() {
  // called when the program is launched

  // init processing stuff
  size(1280, 720);
  noStroke();

  tiles = new GTile[GRID_W][GRID_H];

  // init grid
  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) {
      tiles[x][y] = new GTile(x, y, position(x), position(y));
    } 
  }

  pBtn = new PlayPauseButton(1200, 100, 70);

}


public int position(int p) {
  // transforms array index to corresponding position on screen
  return p * (TILE_SIZE + PADDING) + GRID_OFFSET;
}

public boolean inCell(int ix, int iy) {
  // checks if mouse is in the cell with indices ix, iy
  return mouseX > position(ix) && mouseX < position(ix) + TILE_SIZE && mouseY > position(iy) && mouseY < position(iy) + TILE_SIZE;
}

public int mouseToCell(int n) {
  /// apply reverse of position formula to construct cell indices
  return (n - GRID_OFFSET) / (TILE_SIZE + PADDING);
}

public boolean inCirc(int pX, int pY, int dia) {
  // checks if mouse is in circle
  return sqrt(sq(mouseX-pX) + sq(mouseY-pY)) < dia/2;
}

class GTile {

  // Drawing mechanics
  public int indX, indY; // indices in the array
  private int posX, posY; // position on screen

  // game Mechanics
  private boolean alive;

  // FUNCTIONS

  public GTile(int ix, int iy, int px, int py) {
    // constructor
    indX = ix;
    indY = iy;
    posX = px;
    posY = py;
  }

  void update() {
    // draw

    if (alive) {
      fill(10, 10, 200);
    }
    else {
      fill(150, 150, 150);
    }

    square(posX, posY, TILE_SIZE);
  }

  void click() {
    if (MODE == 0) {
      alive = !alive;
    }
  }

}

class PlayPauseButton {

  private int posX, posY, SIZE;
  // position on screen

  public PlayPauseButton(int x, int y, int s) {
    posX = x;
    posY = y;
    SIZE = s;
  }

  void update() {
    // draw

    if (MODE == 0) fill(150, 150, 150);
    else fill(150, 200, 150);

    circle(posX, posY, SIZE);

  }

  void click() {

    if (inCirc(posX, posY, SIZE)) MODE = 1-MODE;
    
    else {
      int clickX = mouseToCell(mouseX);
      int clickY = mouseToCell(mouseY);
      if (clickX >= 0 && clickX < GRID_W && clickY >= 0 && clickY < GRID_H) tiles[clickX][clickY].click();
    }

  }

}

void mouseClicked() {

  pBtn.click();

}


void draw() {
  clear();
  background(60, 60, 60);

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) tiles[x][y].update();
  }

  pBtn.update();
  
}
