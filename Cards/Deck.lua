local class = {}
local deck = {}

function class.init()
  deck.cards = {
    "cardSpadesA", "cardSpades2", "cardSpades3", "cardSpades4", "cardSpades5", "cardSpades6", "cardSpades7", "cardSpades8", "cardSpades9", "cardSpades10", "cardSpadesJ", "cardSpadesQ", "cardSpadesK",

    "cardHeartsA", "cardHearts2", "cardHearts3", "cardHearts4", "cardHearts5", "cardHearts6", "cardHearts7", "cardHearts8", "cardHearts9", "cardHearts10", "cardHeartsJ", "cardHeartsQ", "cardHeartsK",

    "cardClubsA", "cardClubs2", "cardClubs3", "cardClubs4", "cardClubs5", "cardClubs6", "cardClubs7", "cardClubs8", "cardClubs9", "cardClubs10", "cardClubsJ", "cardClubsQ", "cardClubsK",

    "cardDiamondsA", "cardDiamonds2", "cardDiamonds3", "cardDiamonds4", "cardDiamonds5", "cardDiamonds6", "cardDiamonds7", "cardDiamonds8", "cardDiamonds9", "cardDiamonds10", "cardDiamondsJ", "cardDiamondsQ", "cardDiamondsK"
  }
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

function class.draw()
  if (#deck.cards > 0) then
    local card = deck.cards[1]

    table.remove(deck.cards, 1)

    return card
  end
  
  return "empty"
end

return class