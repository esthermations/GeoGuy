import jscanvas, dom

const
  CanvasSize = 500 # Width and height in pixels
  GridDimension = 5 # 5 = 5x5, 4 = 4x4 etc
  GridSquareSize = CanvasSize div GridDimension
  BackgroundStyle = "white"

type
  GridCoord = range[1..5]

var
  canvas: CanvasElement = nil
  ctx: CanvasContext = nil

func toPixels(c: GridCoord): int = (c * GridSquareSize)

proc clearCanvas() =
  assert ctx != nil
  let prevStyle = ctx.fillStyle
  defer: ctx.fillStyle = prevStyle
  ctx.fillStyle = BackgroundStyle
  ctx.fillRect(0, 0, CanvasSize, CanvasSize)

proc clearGrid(x, y: GridCoord) =
  ctx.fillRect(x.toPixels(), y.toPixels(), GridSquareSize, GridSquareSize)

proc initCanvas() =
  canvas = document.getElementById("gameCanvas").CanvasElement
  canvas.width = CanvasSize
  canvas.height = CanvasSize
  ctx = canvas.getContext2d()

