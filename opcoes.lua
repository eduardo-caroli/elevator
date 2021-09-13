opcoes = {}

function tobool(string)
  if string == 'true' then
    return true
  end
  return false
end

function le_opcoes()
  lista ={}
  local arqops = io.open('opcoes.csv', 'r')
  for line in arqops:lines() do
    if tonumber(line) == 1 then
      table.insert(lista, true)
    elseif tonumber(line) == 2 then
      table.insert(lista, false)
    end
  end
  arqops:close()
  return lista
end

function esc_opcoes(lista)
  local arqops = io.open('opcoes.csv', 'w')
  for i = 1, #lista do
    if lista[i] then
      char = 1
    else
      char = 2
    end
    arqops:write(tostring(char)..'\n')
  end
  arqops:close()
end


function altera_txt()
  local arquivo = io.open('pedidos.txt', 'w')
  io.output(arquivo)
  arquivo:write(2)
  arquivo:write(', ')
  arquivo:write(1)
--  for i = 1, #tabela_de_pedidos-1 do
--    arquivo:write(tostring(tabela_de_pedidos[i])..','..tostring(tabela_de_pedidos[i+1]))
--  end
end


function export_mute()
  local mute = valores_booleanos_dos_botoes_do_menu_opcoes[3]
  return mute
end

function export_vai_ao_ultimo_andar()
  local export = valores_booleanos_dos_botoes_do_menu_opcoes[1]
  return export
end

function opcoes.load()
  y_cam_opc = 0
  numero_de_botoes_no_menu_opcoes = 4
  valores_booleanos_dos_botoes_do_menu_opcoes = le_opcoes()
  fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 60)
  xLinha = 10
  yLinha = 10
  esc = 1
  len = 10
end

function botao(numero, mensagem)
  if valores_booleanos_dos_botoes_do_menu_opcoes[numero] then
    love.graphics.setColor(114/255, 235/255, 141/255)
  else
    love.graphics.setColor(235/255, 94/255, 121/255)
  end
  if numero < 5 then
    love.graphics.rectangle('fill', 80, 100 + 100*numero, 35, 35)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', 80, 100 + 100*numero, 35, 35)
    love.graphics.print(mensagem, 120,110 + 100*numero, 0, 1/3, 1/3)
  else
    love.graphics.rectangle('fill', 430, 100 + 100*(numero-4), 35, 35)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', 430, 100 + 100*(numero-4), 35, 35)
    love.graphics.print(mensagem, 470,110 + 100*(numero-4), 0, 1/3, 1/3)
  end
end

function regua()
  
  local x = 10
  local y = 10
  local size
  if love.keyboard.isDown('up') then
    y_cam_opc = y_cam_opc - 0.5
  elseif love.keyboard.isDown('down') then
    y_cam_opc = y_cam_opc + 0.5  
  end
  
  if love.keyboard.isDown('left') then
    x = x - 0.5
  elseif love.keyboard.isDown('right') then
    x = x + 0.5
  end
  
  if love.keyboard.isDown('space') then
    size = size + 1
  elseif love.keyboard.isDown('b') then
    size = size - 1
  end
  
  love.graphics.line(x, y, x+size, y)
end







function opcoes.draw()
  local xM, yM = love.mouse.getPosition()
  love.graphics.translate(0, -y_cam_opc)
  botao(5, "Exibir Custo em R$")
  botao(4, "Exibir vetores")
  botao(3, "Desativar sons")
  botao(2, "Exibir Velocímetro")
  botao(1, "Exibir Casa de Máquinas")
  love.graphics.setBackgroundColor(0.85, 0.6, 0.6)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(fonte)
  love.graphics.print('Opções', 279, 24, 0, 1.2, 1.2)
  if love.keyboard.isDown('p') then
    love.graphics.print('Tamanho em px:'..tostring(len-2)..'\n'..'Posição em x:'..xM..'\n'..'Posição em y:'..yM..'\n'..'Escala:'..esc..'\n', xLinha, yLinha + 300*esc, 0, 1/4, 1/4)
  end
end


function opcoes.update(dt)
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

function opcoes.keypressed(key)
  if key == 'escape' then
    fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 80)
    love.graphics.setColor(0.789, 0.789, 0.789)
    currState = menu
  end
end

function opcoes.mousepressed(x, y)
  y = y + y_cam_opc
  local x_row = 0
  for i = 1, #valores_booleanos_dos_botoes_do_menu_opcoes do
    if i < 5 then x_row, y_row = 0, 0 else x_row, y_row = 350, 4 end
    if x > x_row + 80 and x < x_row +115 and y > 100 + 100*(i-y_row) and 135 + 100*(i-y_row) > y then
      valores_booleanos_dos_botoes_do_menu_opcoes[i] = not valores_booleanos_dos_botoes_do_menu_opcoes[i]
      esc_opcoes(valores_booleanos_dos_botoes_do_menu_opcoes)
    end
  end
end

--[[
    315 px
--]]

return opcoes