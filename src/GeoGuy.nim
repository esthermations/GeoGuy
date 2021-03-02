import
  Render,
  Gameplay,
  Rooms

import
  dom,
  random,
  strformat


proc onKeyDown*(ev: KeyboardEvent) {.exportc.}

proc onPageLoad*() {.exportc.} =
  document.addEventListener("keydown", onKeyDown)

  echo "onPageLoad() called!"
  initCanvas()
  echo "initCanvas() called!"
  clearCanvas()
  echo "clearCanvas() called!"

proc randomCoord(): GridCoord =
  rand[GridCoord](GridCoord.low .. GridCoord.high)

proc randomThing(): Thing =
  rand[Thing](Thing.low .. Thing.high)

proc clearGrid() =
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      gameGrid[x][y] = Floor

proc drawEntireGrid() =
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      drawGrid(gameGrid[x][y], x, y)

proc loadRoom*(roomNumber: Positive) {.exportc.} =
  assert roomNumber <= AllRooms.len
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      gameGrid[x][y] = AllRooms[roomNumber][y][x]
  drawEntireGrid()

proc drawThings*() {.exportc.} =
  clearGrid()
  drawEntireGrid()
  echo "drawing things."
  for i in 1 .. 5:
    let (x, y, thing) = (randomCoord(), randomCoord(), randomThing())
    gameGrid[x][y] = thing
    echo fmt"Putting {$thing} at {$x} {$y}"
  drawEntireGrid()

proc onKeyDown*(ev: KeyboardEvent) {.exportc.} =
  echo "onKeyDown called!"
  defer: drawEntireGrid()
  if   ev.key == "ArrowLeft" : movePlayer(Left)
  elif ev.key == "ArrowUp"   : movePlayer(Up)
  elif ev.key == "ArrowRight": movePlayer(Right)
  elif ev.key == "ArrowDown" : movePlayer(Down)
  else: return

