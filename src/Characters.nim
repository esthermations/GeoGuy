type
  AttackFormula = tuple[diceSides, numRolls, bonusPerRoll: int]

  CharacterKind = enum
    # Player
    Player,
    # Enemies
    Ling, Zoid, Berg, Bonk, Gorb,
    # Bosses
    Zag, Dig, Lug, Sog, Big

  Character = object
    kind: CharacterKind
    health: Natural
    attack: AttackFormula

const
  CharacterBaseStats* = [
    # Player
    Player: (maxHealth: 15, attack: (6, 1,  0)),
    # Enemies
    Ling  : (maxHealth:  3, attack: (2, 1, -1)),
    Zoid  : (maxHealth:  6, attack: (4, 1, -1)),
    Berg  : (maxHealth: 14, attack: (4, 1, -1)),
    Bonk  : (maxHealth:  9, attack: (6, 1, -1)),
    Gorb  : (maxHealth: 16, attack: (3, 3, -1)),
    # Bosses
    Zag   : (maxHealth: 30, attack: (4, 4, -1)),
    Dig   : (maxHealth: 20, attack: (6, 2,  0)),
    Lug   : (maxHealth: 30, attack: (5, 2,  0)),
    Sog   : (maxHealth: 40, attack: (6, 1,  2)),
    Big   : (maxHealth: 80, attack: (6, 3,  2)),
  ]

func spawnCharacter*(k: CharacterKind): Character =
  var ret: Character
  ret.kind   = k
  ret.health = CharacterBaseStats[k].maxHealth
  ret.attack = CharacterBaseStats[k].attack
  return ret

