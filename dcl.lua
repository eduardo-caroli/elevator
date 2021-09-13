dcl = {}

function vetor(x, y, mag, esc, nome)
  --a escala é um valor em pixels correspondente a cada Newton de força
  --recomenda-se que seja igual a 1/100
  esc = esc or 1/100
  local h = mag*esc
  if h < 0 then
    love.graphics.setColor(0,0,1)
  else
    love.graphics.setColor(1,0,0)
  end
  love.graphics.line(x, y, x, y+h)
  local sentido = h/math.abs(h)
  love.graphics.polygon('fill', x - 10, y + h, x + 10, y + h, x, y + h + (10*sentido))
  love.graphics.print(nome, x, y+(h/2))
end



return dcl