import dom, random
import Render, Gameplay, Rooms

proc onKeyDown*(ev: KeyboardEvent) {.exportc.}

proc onPageLoad*() {.exportc.} =
  document.addEventListener("keydown", onKeyDown)
  initCanvas()
  clearCanvas()
  Gameplay.roomRng = initRand(100)

proc drawThings*() {.exportc.} =
  nextRoom(Left)

proc loadRoom*(roomNumber: Positive) {.exportc.} =
  assert roomNumber <= AllRooms.len
  for (x, y) in allMapCoords():
    currentRoom[x][y] = AllRooms[roomNumber][y][x]
  currentRoom.drawRoom()

proc onKeyDown*(ev: KeyboardEvent) {.exportc.} =
  echo "onKeyDown called!"
  case $ev.key
  of "ArrowLeft" : movePlayer(Left)
  of "ArrowUp"   : movePlayer(Up)
  of "ArrowRight": movePlayer(Right)
  of "ArrowDown" : movePlayer(Down)
  else: return

