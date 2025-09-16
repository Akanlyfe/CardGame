local Card = require("Cards/Card")

local class = {}
local deck = {}

function class.init()
  deck.cards = {}
  deck.backs = {
    "Back_red1", "Back_red2", "Back_red3", "Back_red4", "Back_red5",
    "Back_green1", "Back_green2", "Back_green3", "Back_green4", "Back_green5",
    "Back_blue1", "Back_blue2", "Back_blue3", "Back_blue4", "Back_blue5"
  }

  deck.back = deck.backs[math.random(#deck.backs)]

  for color = 1, 4 do
    for value = 1, 13 do
      local card = Card.create(color, value, deck.back, 10, 10)
      table.insert(deck.cards, card)
    end
  end
end

function class.getBack()
  return deck.back
end

function class.count()
  return #deck.cards
end

function class.shuffle()
  for i = #deck.cards, 2, -1 do
    local random = math.random(i)

    local temp = deck.cards[i]
    deck.cards[i] = deck.cards[random]
    deck.cards[random] = temp
  end
end

function class.drawCard()
  if (#deck.cards > 0) then
    local card = deck.cards[1]
    table.remove(deck.cards, 1)

    return card
  end

  return nil
end

return class