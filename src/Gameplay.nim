import random

proc diceRoll(numSides: Positive): Positive =
  rand(numSides) + 1

