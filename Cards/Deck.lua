local class = {}
local deck = {}

function class.init()
  deck.cards = {
    "SpadesA", "Spades2", "Spades3", "Spades4", "Spades5", "Spades6", "Spades7", "Spades8", "Spades9", "Spades10", "SpadesJ", "SpadesQ", "SpadesK",
    "HeartsA", "Hearts2", "Hearts3", "Hearts4", "Hearts5", "Hearts6", "Hearts7", "Hearts8", "Hearts9", "Hearts10", "HeartsJ", "HeartsQ", "HeartsK",
    "ClubsA", "Clubs2", "Clubs3", "Clubs4", "Clubs5", "Clubs6", "Clubs7", "Clubs8", "Clubs9", "Clubs10", "ClubsJ", "ClubsQ", "ClubsK",
    "DiamondsA", "Diamonds2", "Diamonds3", "Diamonds4", "Diamonds5", "Diamonds6", "Diamonds7", "Diamonds8", "Diamonds9", "Diamonds10", "DiamondsJ", "DiamondsQ", "DiamondsK"
  }

  deck.backs = {
    "Back_red1", "Back_red2", "Back_red3", "Back_red4", "Back_red5",
    "Back_green1", "Back_green2", "Back_green3", "Back_green4", "Back_green5",
    "Back_blue1", "Back_blue2", "Back_blue3", "Back_blue4", "Back_blue5"
  }

  deck.back = deck.backs[math.random(#deck.backs)]
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

  return "empty"
end

return class