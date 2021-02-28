type
  Consumable = object
    healAmount: int
    goldAmount: int

const
  # Healing
  Plont      = Consumable(healAmount:  3)
  Phontain   = Consumable(healAmount: 10)

  # Money
  Glod       = Consumable(goldAmount:  1)
  Gold       = Consumable(goldAmount:  3)
  ChequeBook = Consumable(goldAmount: 15)
