local class = {}
local deck = {}

function class.init()
  deck.cards = {
    "SpadesA", "Spades2", "Spades3", "Spades4", "Spades5", "Spades6", "Spades7", "Spades8", "Spades9", "Spades10", "SpadesJ", "SpadesQ", "SpadesK",
    "HeartsA", "Hearts2", "Hearts3", "Hearts4", "Hearts5", "Hearts6", "Hearts7", "Hearts8", "Hearts9", "Hearts10", "HeartsJ", "HeartsQ", "HeartsK",
    "ClubsA", "Clubs2", "Clubs3", "Clubs4", "Clubs5", "Clubs6", "Clubs7", "Clubs8", "Clubs9", "Clubs10", "ClubsJ", "ClubsQ", "ClubsK",
    "DiamondsA", "Diamonds2", "Diamonds3", "Diamonds4", "Diamonds5", "Diamonds6", "Diamonds7", "Diamonds8", "Diamonds9", "Diamonds10", "DiamondsJ", "DiamondsQ", "DiamondsK"
  }
end

function class.count()
  return #deck.cards
end

function class.shuffle()
  math.randomseed(os.time())

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