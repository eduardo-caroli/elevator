menu_pedidos = {}
local cenario = require 'cenario'
local elevador = require 'elevador'
local interruptor = require 'interruptor'
local duto = require 'duto'

function botao_fechar(x, y, w)
  local xM, yM = love.mouse.getPosition()
  if x < xM and xM < x + w and y < yM and yM < y+w then
    love.graphics.setColor(1,0.5,0.5)
  else
    love.graphics.setColor(1,0.25,0.25)
  end
  love.graphics.rectangle('fill', x, y, w, w)
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(1)
  love.graphics.line(x, y, x+w, y+w)
  love.graphics.line(x+w, y, x, y+w)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle('line', x, y, w, w)
end

function menu_pedidos.load()
  pedido_do_menu_pedidos = ""
  lista_do_menu_pedidos = {}
  ajudar_usuario_no_menu_pedidos = true
  fonte_do_menu_pedidos = love.graphics.setNewFont('fonts/Roboto-Black.ttf', 80)
  love.graphics.setFont(fonte_do_menu_pedidos)
  regua_ligada = true
  fact = 10
  valores_booleanos_dos_botoes_de_trajetoria = {false, false, false}
  xLinha = 10
  yLinha = 10
  xRegua = 10
  yRegua = 10
  esc = 1
  len = 100
  mensagemTraj1 = 'Ir do primeiro ao último andar (ignorar .txt - Recomendado para gerar o .csv)'
  mensagemTraj2 = 'Seguir o arquivo .txt (pedidos de funcionamentos anteriores)'
  mensagemTraj3 = 'Inserir pedidos novos'
end

function botao_trajetoria(numero, mensagem)
  if valores_booleanos_dos_botoes_de_trajetoria[numero] then
    love.graphics.setColor(114/255, 235/255, 141/255)
  else
    love.graphics.setColor(235/255, 94/255, 121/255)
  end
  
  love.graphics.rectangle('fill', 50, 100 + 100*numero, 35, 35)
  
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', 50, 100 + 100*numero, 35, 35)
  love.graphics.print(mensagem, 90,110 + 100*numero, 0, 1/4, 1/4)
end



function regua()
  if regua_ligada then
    love.graphics.line(xRegua, yRegua, xRegua + len, yRegua)
    love.graphics.line(xRegua, yRegua, xRegua, yRegua -fact)
    love.graphics.line(xRegua + len, yRegua, xRegua + len, yRegua -fact)
  end
end
function menu_pedidos.draw()
  love.graphics.setColor(0,0,0)
  love.graphics.setColor(1,1,1)
  interruptor.draw()
  cenario.draw()
  elevador.draw()
  duto.draw()
  love.graphics.setColor(0.85, 0.6, 0.6)
  love.graphics.rectangle('fill', 250, 100, 300, 400)
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('fill',300, 435, 200, 40)
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle('line', 250, 100, 300, 400)
  love.graphics.rectangle('line',300, 435, 200, 40)
  botao_fechar(530, 105, 15)
  botao_central(267, 169, 74.5, 26.3)
  love.graphics.setFont(fonte_do_menu_pedidos)
  if pedido_do_menu_pedidos ~= 't'  and pedido_do_menu_pedidos ~= "" then
    love.graphics.print(pedido_do_menu_pedidos..'º andar', 305, 432, 0, 0.5, 0.5)
  elseif pedido_do_menu_pedidos == 't' then
    love.graphics.print('Térreo', 305, 432, 0, 0.5, 0.5)
  end
  love.graphics.print('Inserir Pedidos', 275, 110, 0, 0.45, 0.45)
  love.graphics.print('Ajuda', 278, 170, 0, .25, .25)
  if ajudar_usuario_no_menu_pedidos then
    love.graphics.printf("Insira pedidos usando os números do teclado, e confirme o pedido clicando a tecla 'z'. Clique 'backspace' para corrigir o pedido.", 275, 220, 950, 'justify', 0, 0.25, 0.25)
  end
  if love.keyboard.isDown('p') then
    love.graphics.print('Tamanho em px:'..tostring(len)..'\n'..'Posição em x:'..xLinha..'\n'..'Posição em y:'..yLinha..'\n'..'Escala:'..esc..'\n', 0, 0, 0, 1, 1)
  end
end


function menu_pedidos.update(dt)
  
  if love.keyboard.isDown('up') then
    yLinha = yLinha - 1
  elseif love.keyboard.isDown('down') then
    yLinha = yLinha + 1
  end
  if love.keyboard.isDown('right') then
    xLinha = xLinha + 1
  elseif love.keyboard.isDown('left') then
    xLinha = xLinha - 1
  end  
  if love.keyboard.isDown('w') then
    yRegua = yRegua - 1
  elseif love.keyboard.isDown('s') then
    yRegua = yRegua + 1
  end
  if love.keyboard.isDown('d') then
    xRegua = xRegua + 1
  elseif love.keyboard.isDown('a') then
    xRegua = xRegua - 1
  end
  if love.keyboard.isDown('space') then
    len = len + 0.5
  elseif love.keyboard.isDown('b') then
    len = len - 0.5
  end  
  if love.keyboard.isDown('m') then
    esc = esc + 0.5
  elseif love.keyboard.isDown('n') then
    esc = esc - 0.5
  end
  if love.keyboard.isDown('c') then
    xRegua = xLinha
    yRegua = yLinha
  end
end

function menu_pedidos.keypressed(key)
  if key == 'l' then
    regua_ligada = not regua_ligada
  end
  if key == 'i' then
    fact = -fact
  end
  for i = 0, 9 do
    if key == tostring(i) and pedido_do_menu_pedidos ~= 't' then
      pedido_do_menu_pedidos = pedido_do_menu_pedidos .. tostring(i)
    end
  end
  if key == 't' then
    pedido_do_menu_pedidos = 't'
  end
  if key == 'z' then
    if pedido_do_menu_pedidos ~= 't' then
      table.insert(pedidos, pedido_do_menu_pedidos+1)
    else
      table.insert(pedidos, 1)
    end
    pedido_do_menu_pedidos = ""
  end
  if key == 'backspace' then
    pedido_do_menu_pedidos = pedido_do_menu_pedidos:sub(1, -2)
  end
end

function menu_pedidos.mousepressed(x, y)
  for i = 1, 3 do
    if x > 50 and x < 85 and y > 100 + 100*i and y < 135 + 100*i then
      valores_booleanos_dos_botoes_de_trajetoria = {false, false, false}
      valores_booleanos_dos_botoes_de_trajetoria[i] = not valores_booleanos_dos_botoes_de_trajetoria[i]
    end
  end
  if x > 530 and x < 545 and y > 105 and y < 120 then
    currState = simulacao
  end
  if y > 169 and y < 195.3 and x > 267 and x < 267 + 74.5 then
    ajudar_usuario_no_menu_pedidos = not ajudar_usuario_no_menu_pedidos
  end
end

return menu_pedidos