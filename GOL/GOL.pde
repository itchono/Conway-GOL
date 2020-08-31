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
  frameRate(5);

  // init grid
  tiles = new GTile[GRID_W][GRID_H];

  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) tiles[x][y] = new GTile(x, y, position(x), position(y));
  }

  // init button
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

public int wrap(int n, int limit) {
  // allows wrap-around access of indices
  if (n >= 0 && n < limit) return n;
  else if (n < 0) return n + limit; // underflow
  else return n - limit; // overflow
}


class GTile {
  // Drawing mechanics
  public int indX, indY; // indices in the array
  private int posX, posY; // position on screen

  // game Mechanics
  public boolean alive;
  private boolean nextState;

  // FUNCTIONS

  public GTile(int ix, int iy, int px, int py) {
    // constructor
    indX = ix;
    indY = iy;
    posX = px;
    posY = py;
  }

  void prepareState() {
    // perform GOL mechanics

    int neighbours = 0;

    // check 8 surrounding cells
    int[] acX = {-1, 0, 1, -1, 1, -1, 0, 1};
    int[] acY = {-1, -1, -1, 0, 0, 1, 1, 1};

    for (int i = 0; i < 8; i++) {
      if (tiles[wrap(indX + acX[i], GRID_W)][wrap(indY + acY[i], GRID_H)].alive) neighbours++;
      // adds to neighbours if tile is alive
    }

    nextState = ((neighbours == 2 && alive) || neighbours == 3); // set next state
  }

  void propagateState() {
    // updates all states after checking
    alive = nextState;
  }

  void update() {

    if (MODE == 1) propagateState(); // update, if we're playing

    // draw
    if (alive) fill(10, 200, 10);
    else fill(150, 150, 150);

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
  }
}

void mouseClicked() {
  pBtn.click();

  int clickX = mouseToCell(mouseX);
  int clickY = mouseToCell(mouseY);
  if (clickX >= 0 && clickX < GRID_W && clickY >= 0 && clickY < GRID_H) tiles[clickX][clickY].click();

  redraw(); // update screen
}


void draw() {
  clear();
  background(60, 60, 60);

  if (MODE == 1) {
    // calculate
    for (int x = 0; x < GRID_W; x++) {
      for (int y = 0; y < GRID_H; y++) tiles[x][y].prepareState();
    }
  }

  // draw
  for (int x = 0; x < GRID_W; x++) {
    for (int y = 0; y < GRID_H; y++) tiles[x][y].update();
  }

  pBtn.update();
  
}
