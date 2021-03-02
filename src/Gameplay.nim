import random, options

const
  GridDimension* = 5 # 5 = 5x5, 4 = 4x4 etc

type
  GridCoord* = range[1..GridDimension]

  Point* = tuple[x: GridCoord, y: GridCoord]

  Room = array[GridCoord, array[GridCoord, Thing]]

  Thing* = enum
    # Map squares
    Floor, Wall,
    # Player
    Player,
    # Bosses
    Big, Zag,
    # Rooms
    BossRoom, Home, ItemRoom, CombatRoom, UnknownRoom,
    # Consumables
    BankNote, Glod, Gold, Phontain, Plont,
    # Enemies
    Berg, Bonk, Gorb, Ling, Zoid,
    # Items
    Clof, Dog, Hart, Knif, Plast, Spon, Whip

  Direction* = enum Left, Up, Right, Down

var
  gameGrid*: Room


proc diceRoll(numSides: Positive): Positive =
  rand(numSides) + 1

proc findPlayer(): Option[Point] =
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      if gameGrid[x][y] == Player:
        return some (x, y)

func isValidCoord(val: int): bool =
  val >= GridCoord.low and val <= GridCoord.high

### Get the point one square in the given Direction from the given Point. If the
### resulting position is out of bounds, will return None.
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
  gameGrid[p.x][p.y]

proc setThingAtPoint(p: Point, t: Thing) =
  gameGrid[p.x][p.y] = t

proc movePlayer*(d: Direction) =
  let oPlayerPos = findPlayer()
  if oPlayerPos.isNone(): return
  let
    playerPos = oPlayerPos.get()
    oTargetPos = targetPos(playerPos, d)
  if oTargetPos.isNone(): return
  let target = oTargetPos.get()
  case thingAtPoint(target)
  of Floor:
    setThingAtPoint(target, Player)
    setThingAtPoint(playerPos, Floor)
  else:
    return
