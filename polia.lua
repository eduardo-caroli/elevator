polia = {}
Pi = math.pi
cos = math.cos
sin = math.sin
function polia(x, y, r, theta, posx)
  love.graphics.rectangle('line', x+r/2, y, r/2, 600)
  for i = -3000, 600 do
    love.graphics.line(x+r/2, 5*i-posx,x+r, 10 + 5*i-posx)
  end
  love.graphics.setColor(.600,.600,.600)
  love.graphics.circle('fill', x, y, r)
  love.graphics.setColor(.720,.720,.720)
  love.graphics.circle('fill', x, y, r/3)
  love.graphics.setColor(0,0,0)
  love.graphics.circle('line', x, y, r)
  love.graphics.circle('line', x, y, r/3)
  for i = 0, 3 do
    local rMenor = 3*r/4
    local angle = theta +i*Pi/2
    local cX = rMenor * math.cos(angle)
    local cY = rMenor * math.sin(angle)
    love.graphics.setColor(.720,.720,.720)
    love.graphics.circle('fill', x+cX, y+cY, r/10)
    love.graphics.setColor(0,0,0)
    love.graphics.circle('line', x+cX, y+cY, r/10)
  end
end
return polia