from Gameplay import Thing, GridCoord

const
  _ = Floor
  AllRooms* = [
    # Empty room
    0: [ 1: [ 1: _, _, _, _, _ ],
         2: [ 1: _, _, _, _, _ ],
         3: [ 1: _, _, _, _, _ ],
         4: [ 1: _, _, _, _, _ ],
         5: [ 1: _, _, _, _, _ ] ],
    # Designed rooms
    1: [ [ _, Wall, _,      _,    _ ],
         [ _, _,    Ling,   _,    _ ],
         [ _, Ling, _,      Ling, _ ],
         [ _, _,    Player, _,    _ ],
         [ _, Wall, _,      _,    _ ] ],
  ]