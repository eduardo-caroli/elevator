controles = {}

function moldura(imagem, x, y, escala, mensagem)
  local h = escala * imagem:getHeight()
  local w = escala * imagem:getWidth()
  local xM, yM = love.mouse.getPosition()
  if x < xM and x + w > xM and y < yM and yM < y + h then
    ajuda = false
    love.graphics.setColor(1,1,1)
    love.graphics.printf(mensagem, 275, 200, 500, 'center', 0, 1/2, 1/2)
  else
    love.graphics.setColor(0.85,0.85,0.85)
  end
  love.graphics.draw(imagem, x, y, 0, escala, escala)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, w, h)
end

function controles.load()
  ajuda = true
  mensagemLkey = "A tecla L liga todas as lâmpadas do mapa"
  mensagemDkey = "A tecla D desliga todas as lâmpadas do mapa"
  mensagemesckey = "A tecla Esc pausa a simulação e abre o menu. Quando nas abas 'Opções' ou 'Controles', a tecla também leva de volta ao menu."
  mensagemIkey = "A tecla I abre o menu de inserção de pedidos durante a simulação"
  mensagemZkey = "A tecla Z confirma a inserção de um pedido na lista, quando o menu de inserção está aberto"
  fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 60)
  xLinha = 10
  yLinha = 10
  esc = 1
  len = 10
  lKey = love.graphics.newImage('images/lKey.png')
  dKey = love.graphics.newImage('images/dKey.png')
  zKey = love.graphics.newImage('images/zKey.png')
  iKey = love.graphics.newImage('images/iKey.png')
  escKey = love.graphics.newImage('images/escKey.png')
end
function controles.draw()
  moldura(dKey, 50, 225, 0.0798, mensagemDkey)
  moldura(lKey, 50, 150, 0.3, mensagemLkey)
  moldura(iKey, 50, 375, 0.3, mensagemIkey)
  moldura(zKey, 50, 450, 0.3, mensagemZkey)
  moldura(escKey, 50, 300, 0.0798, mensagemesckey)
  love.graphics.setBackgroundColor(0.85, 0.6, 0.6)
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.setColor(1,1,1)
--  love.graphics.line(xLinha, yLinha, xLinha + len, yLinha)
--  love.graphics.line(xLinha, yLinha, xLinha, yLinha+ 10)
--  love.graphics.line(xLinha+len, yLinha, xLinha+len, yLinha+10)
  love.graphics.setFont(fonte)
  love.graphics.print('Controles', 242.5, 24, 0, 1.2, 1.2)
  if ajuda then
    love.graphics.printf('Passe o mouse sobre os botões para ver o que fazem', 306, 210, 450, 'center', 0, 0.45, 0.45)
  end
  if love.keyboard.isDown('p') then
    love.graphics.print('Tamanho em px:'..tostring(len-2)..'\n'..'Posição em x:'..xLinha..'\n'..'Posição em y:'..yLinha..'\n'..'Escala:'..esc..'\n', xLinha, yLinha + 300*esc, 0, 1/4, 1/4)
  end
end


function controles.update(dt)
  if love.keyboard.isDown('space') then
    len = len + 1
  elseif love.keyboard.isDown('b') then
    len = len - 1
  end
  
  if love.keyboard.isDown('m') then
    esc = esc + 0.01
  elseif love.keyboard.isDown('n') then
    esc = esc - 0.01
  end
  
  if love.keyboard.isDown('up') then
    yLinha = yLinha - 0.5
  elseif love.keyboard.isDown('down') then
    yLinha = yLinha + 0.5  
  end
  
  if love.keyboard.isDown('left') then
    xLinha = xLinha - 0.5
  elseif love.keyboard.isDown('right') then
    xLinha = xLinha + 0.5
  end
end

function controles.keypressed(key)
  if key == 'escape' then
    ajuda = true
    fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 80)
    currState = menu
  end
end

function controles.mousepressed(x, y)
end
return controles
--[[
    315 px
--]]