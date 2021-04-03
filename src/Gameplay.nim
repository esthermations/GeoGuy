import random, options
import GameplayConstants, Render

type
  Point* = tuple[x: GridCoord, y: GridCoord]
  Room = array[GridCoord, array[GridCoord, Thing]]

  Direction* = enum Left, Up, Right, Down

const
  MapSquares  = { Thing.Floor .. Thing.Wall }
  Bosses      = { Big .. Zag }
  Rooms       = { BossRoom .. UnknownRoom }
  Consumables = { BankNote .. Plont }
  Enemies     = { Berg .. Zoid }
  Items       = { Clof .. Whip }

  WalkableTiles = { Floor, Portal } + Consumables + Items

  CoordRange = GridCoord.low .. GridCoord.high
  WalkableRange = BorderWidth .. GridDimension - BorderWidth

  MiddleCoord: GridCoord = (GridCoord.high div 2) + 1

  PlayerStartingPos: array[Direction, Point] = [
    Left : (x: succ GridCoord.low,  y: MiddleCoord),
    Up   : (x: MiddleCoord,         y: succ GridCoord.low),
    Right: (x: pred GridCoord.high, y: MiddleCoord),
    Down : (x: MiddleCoord,         y: pred GridCoord.high),
  ]

# Forward decls
proc generateRandomRoom*(): Room

var
  currentRoom*: Room
  roomRng*: Rand

func oppositeDirection(d: Direction): Direction =
  case d
  of Left: Right
  of Right: Left
  of Up: Down
  of Down: Up

proc drawRoom*(room: Room) =
  for (x, y) in allMapCoords():
    drawGrid(room[x][y], x, y)

proc findPlayer(): Option[Point] =
  for (x, y) in allMapCoords():
    if currentRoom[x][y] == Player:
      return some (x, y)

func isValidCoord(val: int): bool =
  val >= GridCoord.low and val <= GridCoord.high

### Get the point one square in the given Direction from the given Point. If the
### resulting position is out of bounds, will return None.
### FIXME: Name this better.
func targetPos(p: Point, d: Direction): Option[Point] =
  var
    x: int = p.x
    y: int = p.y
    target: tuple[x, y: int] = case d
      of Left : (x - 1, y    )
      of Up   : (x,     y - 1)
      of Right: (x + 1, y    )
      of Down : (x,     y + 1)

  if target.x.isValidCoord() and target.y.isValidCoord():
    return some (target.x.GridCoord, target.y.GridCoord)

proc thingAtPoint(p: Point): Thing =
  currentRoom[p.x][p.y]

proc placeAt(room: var Room, where: Point, what: Thing) =
  room[where.x][where.y] = what

proc nextRoom*(entryDirection: Direction) =
  clearEntireGrid()
  currentRoom = generateRandomRoom()
  currentRoom.placeAt(
    PlayerStartingPos[oppositeDirection(entryDirection)],
    Player
  )
  currentRoom.drawRoom()

proc movePlayer*(d: Direction) =
  defer: currentRoom.drawRoom()

  let oPlayerPos = findPlayer()
  if oPlayerPos.isNone(): return
  let
    playerPos = oPlayerPos.get()
    oTargetPos = targetPos(playerPos, d)
  if oTargetPos.isNone(): return
  let
    target = oTargetPos.get()
    targetThing = thingAtPoint(target)

  if targetThing notin WalkableTiles: return

  case thingAtPoint(target)
  of Portal:
    nextRoom(d)
  else:
    currentRoom.placeAt(target, Player)
    currentRoom.placeAt(playerPos, Floor)

proc randomCoord*(): GridCoord =
  rand[GridCoord](roomRng, GridCoord.low .. GridCoord.high)

proc randomThing*(excepting: set[Thing] = {}): Thing =
  let AllowedThings = { Thing.low .. Thing.high } - excepting
  sample[Thing](roomRng, AllowedThings)

proc placeWalls(room: var Room) =
  for x in GridCoord.low .. BorderWidth:
    for y in CoordRange:
      room[x][y] = Wall
  for x in GridCoord.high - BorderWidth + 1 .. GridCoord.high:
    for y in CoordRange:
      room[x][y] = Wall
  for y in GridCoord.low .. BorderWidth:
    for x in CoordRange:
      room[x][y] = Wall
  for y in GridCoord.high - BorderWidth + 1 .. GridCoord.high:
    for x in CoordRange:
      room[x][y] = Wall

proc placePaths(room: var Room) =
  for x in CoordRange: room[x][MiddleCoord] = Floor
  for y in CoordRange: room[MiddleCoord][y] = Floor

proc placePortals(room: var Room) =
  room[GridCoord.low + 1][MiddleCoord] = Portal
  room[MiddleCoord][GridCoord.low + 1] = Portal
  room[GridCoord.high - 1][MiddleCoord] = Portal
  room[MiddleCoord][GridCoord.high - 1] = Portal


proc placeThings(room: var Room) =
  for (x, y) in allMapCoords():
    room[x][y] = randomThing(excepting = { Player } + MapSquares)

proc generateRandomRoom*(): Room =
  result.placeThings()
  result.placeWalls()
  result.placePaths()
  result.placePortals()
