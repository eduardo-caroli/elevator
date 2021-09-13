local painel = {}

function danger_bar(x, y, w, h, nL, fill, cabo)
  wLine = w / (2*nL)
  for i = 0, nL-1 do
    if fill then
      love.graphics.polygon('fill', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    else
      love.graphics.polygon('line', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    end
  end
  if cabo then
    love.graphics.line(x, y, x+w, y)
    love.graphics.line(x, y+h, x+w, y+h)
  else
    love.graphics.rectangle('line', x, y, w, h)
  end
end

function raio(x, y, w, h)
  love.graphics.setColor(1,1,0)
  love.graphics.polygon('fill', x, y + (3*h)/5, x + (2*w)/5, y + (3*h)/5, x + (2*w)/5, y)
  love.graphics.polygon('fill', x + (3*w)/5, y + (2*h)/5, x + w, y + (2*h)/5, x + (3*w)/5, y+h)
  love.graphics.rectangle('fill', x + (2*w)/5, y+(2*h)/5, w/5, h/5)
end

function parafuso(x, y, raio, angulo)
  love.graphics.setColor(.85,.85,.85)
  love.graphics.circle('fill', x, y, raio)
  love.graphics.setColor(0,0,0)
  love.graphics.circle('line', x, y, raio)
  love.graphics.line(x + math.cos(angulo)*raio, y + math.sin(angulo)*raio, x - math.cos(angulo)*raio, y - math.sin(angulo)*raio)
  love.graphics.line(x + math.cos(angulo + (math.pi/2))*raio, y + math.sin(angulo + (math.pi/2))*raio, x - math.cos(angulo + (math.pi/2))*raio, y - math.sin(angulo + (math.pi/2))*raio)
end

function painel.load()
  custo = 10
  dFont = love.graphics.newFont('fonts/Digital Display.ttf', 30)
  tahoma = love.graphics.newFont('fonts/tahoma.ttf', 30)
  love.graphics.setFont(dFont)
end

function painel.draw()
--  love.graphics.setColor(0,0.2,0)
--  love.graphics.rectangle('fill', 400, 300, 90, 30)
--  love.graphics.setColor(1,1,0)
--  danger_bar(400 - 20, 300 - 30, 130, 20, 5, true, false)
--  love.graphics.setColor(0,0.8,0)
--  love.graphics.print('10000,00', 400, 300)
--  raio(xM, yM, 30, 50)
  parafuso(xM, yM, 7, 1.115023)
end
function screen(x, y, w, h, custo)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
  love.graphics.setColor(.4,.4,.4)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(.65,.65,.65)
  love.graphics.rectangle('fill', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  xTexto = x + w/2 - (tahoma:getWidth('CUSTO'))/2
  love.graphics.setColor(.0,.3,0)
  love.graphics.rectangle('fill', x + w/2 - (5*w/16), y + h/2, 10*w/16, h/4)
  love.graphics.setColor(0, .8, 0)
  love.graphics.setFont(dFont)
  custo = tonumber(string.format("%.3f", custo))
  local xCusto = x + w/2 - (dFont:getWidth(custo) / 2)
  love.graphics.print(custo, xCusto, y + 9*h/16)
  raio(x + w/11, y +w/11, 20, 100/3)
  raio(x + 10*w/11, y + w/11, -20, 100/3)
  parafuso(x + w/30, y + h - w/30, 5, 1.12364)
  parafuso(x + 29*w/30, y + h - w/30, 5, 2.62364)
  parafuso(x + 29*w/30, y + w/30, 5, 0.62364)
  parafuso(x + w/30, y + w/30, 5, 1.01364)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  love.graphics.rectangle('line', x + w/2 - (5*w/16), y + h/2, 10*w/16, h/4)
  love.graphics.setFont(tahoma)
  love.graphics.print('CUSTO', xTexto, y + w/11)
end

function screen2(x, y, w, h, custo)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
  love.graphics.setColor(.4,.4,.4)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(.65,.65,.65)
  love.graphics.rectangle('fill', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  xTexto = x + w/2 - (tahoma:getWidth('T. MÁX'))/2
  love.graphics.setColor(.0,.3,0)
  love.graphics.rectangle('fill', x + w/2 - (5*w/16), y + h/2, 10*w/16, h/4)
  love.graphics.setColor(0, .8, 0)
  love.graphics.setFont(dFont)
  custo = tonumber(string.format("%.3f", custo))
  local xCusto = x + w/2 - (dFont:getWidth(custo) / 2)
  love.graphics.print(custo, xCusto, y + 9*h/16)
  parafuso(x + w/30, y + h - w/30, 5, 1.12364)
  parafuso(x + 29*w/30, y + h - w/30, 5, 2.62364)
  parafuso(x + 29*w/30, y + w/30, 5, 0.62364)
  parafuso(x + w/30, y + w/30, 5, 1.01364)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  love.graphics.rectangle('line', x + w/2 - (5*w/16), y + h/2, 10*w/16, h/4)
  love.graphics.setFont(tahoma)
  love.graphics.print('T. MÁX', xTexto, y + w/11)
end

function order_screen(x, y, w, h, pedidos)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
  love.graphics.setColor(.4,.4,.4)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(.65,.65,.65)
  love.graphics.rectangle('fill', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  xTexto = x + w/2 - (tahoma:getWidth('PEDIDOS'))*w/180/2
  love.graphics.setColor(.0,.3,0)
  love.graphics.rectangle('fill', x + w/2 - (5*w/16), y + h/4, 10*w/16, 2*h/3)
  love.graphics.setColor(0, .8, 0)
  love.graphics.setFont(dFont)
  if #pedidos <= 16 then
    size = #pedidos
  else
    size = 15
  end
  for i = 1, size, 2 do
    local origem = pedidos[i]
    local destino = pedidos[i+1]
    if destino == nil then
      string = ' ;'..tostring(origem)
    else
      string = tostring(origem)..';'..tostring(destino)
    end
    local xC = x + w/2 - (5*w/16) + 10*w/16 - (dFont:getWidth(string)*w/180) - w/50
    local yC = y + h/4 + ((15*h/400) * i) + ((15*h)/400)
    love.graphics.print(tostring(((i - 1)/2)+1)..'-', x + w/2 - (5*w/16) + w/50, yC, 0, w/180, h/400)
    love.graphics.print(string, xC, yC, 0, w/180, h/400)
  end
  parafuso(x + w/30, y + h - w/30, w/36, 1.12364)
  parafuso(x + 29*w/30, y + h - w/30, w/36, 2.62364)
  parafuso(x + 29*w/30, y + w/30, w/36, 0.62364)
  parafuso(x + w/30, y + w/30, w/36, 1.01364)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x+w/15, y+w/15, 13*w/15, h-2*w/15)
  love.graphics.rectangle('line', x + w/2 - (5*w/16), y + h/4, 10*w/16, 2*h/3)
  love.graphics.setFont(tahoma)
  love.graphics.print('n', x + w/2 - (5*w/16) + w/50, y + h/4  - (tahoma:getHeight('n')*h/400), 0, w/180, h/400)
  local xC = x + w/2 - (5*w/16) + 10*w/16 - (tahoma:getWidth('o d')*w/180) - w/50
  love.graphics.print('o:d', xC, y + h / 4 - (tahoma:getHeight('n')*h/400), 0, w/180, h/400)
  love.graphics.print('PEDIDOS', xTexto, y + w/11, 0, w/180, h/400)
end

function painel.update(dt)
  xM, yM = love.mouse.getPosition()
  if love.keyboard.isDown('m') then
    custo = custo + 2000.100123
  end
  if love.keyboard.isDown('n') then
    custo = custo - 20.1
  end
end

return painel