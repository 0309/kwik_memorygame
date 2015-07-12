local placeHolder = {}
for i=1, layer.gp_photos.numChildren do
  placeHolder[i] = {}
  placeHolder[i].x, placeHolder[i].y = layer.gp_photos[i].x, layer.gp_photos[i].y
end

for i=1, layer.gp_photos.numChildren do
  local ind = math.random(#placeHolder)
  layer.gp_photos[i].x, layer.gp_photos[i].y = placeHolder[ind].x, placeHolder[ind].y
  table.remove(placeHolder,ind)
  layer.gp_photos[i].alpha = 0.01
  layer.gp_photos[i].matched = false
end

local flips = 1
local flipped = {}

layer.hitTest= function(self)
  if self.matched  then return true end
  isHistTest = true
  if (flips == 1) then
    composer.trans.flipCard = transition.to( self, {alpha=1, time=1000, delay=0})
    if flipped[1] ~= self then
      table.insert(flipped,self)
      self.photoNum  = photoNum
      flips = 2
    end
  elseif flips == 2 then --second flip in the round
    if flipped[1] ~= self then
      table.insert(flipped,self)
      self.photoNum  = photoNum
      composer.trans.flipCard = transition.to( self, {alpha=1, time=1000, delay=0})
      if (flipped[1].photoNum == flipped[2].photoNum) then
        flipped[1].matched = true
        flipped[2].matched = true
        flips = 1 -- returns the number of flips to 1
        flipped = {} --cleans the flipped table
      else
        -- cards don’t match
        local card1, card2 = flipped[1],flipped[2]
        local function hideAgain()
          composer.trans.flipCard1 = transition.to( card1, {alpha=0.01, time=1000, delay=0})
          composer.trans.flipCard2 = transition.to( card2, {alpha=0.01, time=1000, delay=0})
        end
        composer.timerStash.hideAgain = timer.performWithDelay( 2000, hideAgain, 1 ) --timer to block the cards again, with the cover image
        flips = 1
        flipped = {}
      end
    end
  end
  return true
end
