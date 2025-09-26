local Constants = require("Util/Constants")
local Collision = require("Util/Collision")

local GameState = require("GameState/GameState")
local Deck = require("Cards/Deck")
local Card = require("Cards/Card")
local StackManager = require("Stack/StackManager")

local DrawAPI = require("Util/DrawAPI")
local AkanMath = require("Util/Lib/AkanMath")

local class = {}
local solitaire = {}

function solitaire.stackRule(_card, _cardNext)
  return (_card.color % 2 ~= _cardNext.color % 2) and (_card.value == _cardNext.value + 1)
end

function class.load()
  solitaire.drawnCards = {}

  Deck.init()
  Deck.shuffle()

  StackManager.init(Deck.getCardSize().width, Deck.getCardSize().height)

  local previousCard = nil
  for i = 1, 7 do
    for j = 1, i do
      local card = Deck.drawCard(true)

      -- TODO if (j == 1) then stack on Stack.getStacks()[i] end
      if (j == 1) then
        StackManager.getStacks()[i]:addCard(card)
      end

      local x = 10 + i * card.width * 1.5
      local y = card.height * 1.5 + j * card.height / 5

      card:setPosition(x, y)

      if (j > 1 and previousCard ~= nil) then
        card:stackOn(previousCard)
      end

      if (j == i) then
        card.isUncovered = true
      end

      previousCard = card
    end
  end
end

function class.unload()
  Card.clear()
  collectgarbage('collect')
end

function class.update(_dt)
end

function class.draw()
  love.graphics.setBackgroundColor(0, .5, 0, 1)

  if (Deck.getCount() > 0) then
    DrawAPI.draw(Constants.priority.normal, Constants.color.white, Deck.getSpriteBack(), Deck.getPosition().x, Deck.getPosition().y)
  end

  StackManager.draw()
end

function class.keypressed(_key)
  if (_key == 'tab') then
    GameState.request("gameOver")
  end
end

function class.mousepressed(_x, _y, _button)
  local mousePosition = {
    x = _x,
    y = _y
  }

  if (_button == 1) then
    local deckPosition = Deck.getPosition()
    local deckBB = Deck.getBoundingBox()

    if (Collision.isPointRectangleColliding(mousePosition, deckBB)) then
      if (Deck.getCount() > 0) then
        local card = Deck.drawCard()
        if (card == nil) then return end

        if (solitaire.previousPriority ~= nil) then
          card.priority = solitaire.previousPriority + 1
        end

        solitaire.previousPriority = card.priority

        card.canStack = false
        card:setPosition(deckPosition.x, deckPosition.y)
        card:moveTo(deckPosition.x + deckBB.width * 3, deckPosition.y)
        card:flip()

        table.insert(solitaire.drawnCards, card)
      else
        for _, card in pairs(solitaire.drawnCards) do
          Deck.addCard(card)
        end

        solitaire.drawnCards = {}
      end
    end

    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          local isPickedUp = card:pickUp(solitaire.stackRule)
          if (isPickedUp) then
            solitaire.selectedCard = card
          end

          break
        end
      end
    end
  elseif (_button == 2) then
    -- TODO Add auto placement when right-click on card
    -- TODO set the flip automatic
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          card:flip()
          break
        end
      end
    end

    -- TODO Remove this debug.
  elseif (_button == 3) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (Collision.isPointRectangleColliding(mousePosition, card:getBoundingBox())) then
          print(card.name, card.priority)
        end
      end
    end

    for _, stack in pairs(StackManager.getStacks()) do
      if (Collision.isPointRectangleColliding(mousePosition, stack:getBoundingBox())) then
        for _, card in pairs(stack.cards) do
          print(card.name)
        end
      end
    end
  end
end

function class.mousereleased(_x, _y, _button)
  if (_button == 1) then
    if (solitaire.selectedCard) then
      local isStacked = solitaire.selectedCard:drop(solitaire.stackRule)
      if (isStacked) then
        for i = #solitaire.drawnCards, 1, -1 do
          local card = solitaire.drawnCards[i]
          if (card == solitaire.selectedCard) then
            table.remove(solitaire.drawnCards, i)

            card.priority = Constants.priority.normal
            card.canStack = true
            break
          end
        end
      end

      solitaire.selectedCard = nil
    end
  end
end

function class.mousemoved(_x, _y, _moveX, _moveY)
  if (love.mouse.isDown(1)) then
    if (Card.getCardCount() > 0) then
      for i = Card.getCardCount(), 1, -1 do
        local card = Card.getCard(i)
        if (card.isSelected) then
          local worldX, worldY = Constants.screenToWorld(_x, _y)
          card:setPosition(worldX - card.dragOffsetX, worldY - card.dragOffsetY)
          break
        end
      end
    end
  end
end

return class