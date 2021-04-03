import jscanvas, dom, strformat, strutils
import GameplayConstants

const
  CanvasSize = 750 # Width and height in pixels
  GridDimension* = 17 # 5 = 5x5, 4 = 4x4 etc
  BorderWidth* = 2
  GridSquareSize = CanvasSize div GridDimension
  BackgroundStyle = "lavender"

type
  GridCoord* = range[1..GridDimension]

iterator allMapCoords*(): (GridCoord, GridCoord) =
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      yield (x, y)

var
  iconElements: array[Thing, ImageElement]
  canvas: CanvasElement = nil
  ctx: CanvasContext = nil

proc loadIcon(t: Thing): ImageElement =
  let iconPath = toLower(fmt"./icons/{$t}.png")
  result = document.createElement("img").ImageElement
  # result.onload = proc(ev: Event) {.closure.} =
  result.src = iconPath
  echo "Loading: ", $iconPath

func toPixels(c: GridCoord): int = ((c-1) * GridSquareSize)

proc drawGrid*(x, y: GridCoord, style: string) =
  assert ctx != nil
  ctx.fillStyle = style.cstring
  ctx.fillRect(x.toPixels(), y.toPixels(), GridSquareSize, GridSquareSize)

proc clearGrid*(x, y: GridCoord) =
  assert ctx != nil
  drawGrid(x, y, BackgroundStyle)

proc drawGrid*(thing: Thing, x, y: GridCoord) =
  assert ctx != nil

  if thing == Floor:
    clearGrid(x, y)
  elif thing == Wall:
    drawGrid(x, y, "black")
  else:
    assert iconElements[thing] != nil
    ctx.drawImage(
      image   = iconElements[thing],
      dx      = x.toPixels(),
      dy      = y.toPixels(),
      dWidth  = GridSquareSize,
      dHeight = GridSquareSize
    )

proc clearEntireGrid*() =
  for (x, y) in allMapCoords():
    Render.clearGrid(x, y)


proc clearCanvas*() =
  assert ctx != nil
  for x in GridCoord.low .. GridCoord.high:
    for y in GridCoord.low .. GridCoord.high:
      clearGrid(x, y)

proc initCanvas*() =
  canvas = document.getElementById("gameCanvas").CanvasElement
  canvas.width = CanvasSize
  canvas.height = CanvasSize
  ctx = canvas.getContext2d()

  for t in Thing:
    if t in [ Floor, Wall ]: continue
    iconElements[t] = loadIcon(t)
