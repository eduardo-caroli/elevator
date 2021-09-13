local duto = {}

function duto.load()
  duto = love.graphics.newImage('images/duto3.png')
  local largura_duto = duto:getPixelWidth()
  local altura_duto = duto:getPixelHeight()
end

function duto.update(dt)
end

function duto.draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(duto, 150, altura_do_telhado +100 -  (duto:getHeight()/2), 0, .5, .5)
end
return duto