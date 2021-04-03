# Inert gameplay constants

type
  Thing* = enum
    # Map squares
    Floor, Portal, Wall,
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
