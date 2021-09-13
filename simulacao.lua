simulacao = {}

local elevador = require 'elevador'
local cenario = require 'cenario'
local duto = require 'duto'
local interruptor = require 'interruptor'
local manutencao = require 'manutencao'
local trajetoria = require 'trajetoria'
local fundo = require 'fundo'
local painel = require 'painel' 
local passageiro = require 'passageiro'
local engineman = require 'engineman'

function setJanela()
  local largura = love.graphics.getPixelWidth()
  if largura == 800 then
    love.window.setMode(1400, 600)
  end
end

function simulacao.load()
  painel.load()
  elevador.load()
  cenario.load()
  passageiro.load()
  duto.load()
  manutencao.load()
  trajetoria.load()
  fundo.load()
  engineman.load()
end

function simulacao.update(dt)
  setJanela()
  if isGame then
    manutencao.update(dt)
    engineman.update(dt)
    if engineer.yCoord < 450 then
      y_cam = engineer.yCoord
    else
      y_cam = 450
    end
  else
    y_cam = valor()
  end
  if not corretiva then
    elevador.update(dt)
  end
  cenario.update(dt)
  duto.update(dt)
  fundo.update(dt)
  passageiro.update(dt)
  interruptor.update(dt)
  trajetoria.update(dt)
end

function simulacao.draw()
--  love.graphics.scale(3,3)
--  love.graphics.translate(-100,0)
  fundo.draw()
  if valores_booleanos_dos_botoes_do_menu_opcoes[5] then
    screen(850, 330, 200, 150, custo_total)
    screen2(-250, 140, 200, 150, pedido_mais_longo[4])
    order_screen(900, 40, 112.5, 250, lista_de_pedidos_recebidos)
  end
  love.graphics.translate(0,450 -y_cam)
  cenario.draw()
  elevador.draw()
  passageiro.draw()
  if defeitos[2] and corretiva then
    draw_doors(7*largura_da_tela/16, oeb:getY(), x_portas_defeito)
  else
    draw_doors(7*largura_da_tela/16, oeb:getY(), x_de_abertura_das_portas)
  end
  duto.draw()
  interruptor.draw()
  if isGame then
    drawStairs()
    manutencao.draw()
    engineman.draw()
  end
  if corretiva or ja_previu then
    if defeitos[2] then
      love.graphics.setColor(1,0,0, 0.1)
      love.graphics.rectangle('fill', 300, oeb:getY(), 200, 130)
      love.graphics.setColor(1,0,0)
      love.graphics.rectangle('line', 300, oeb:getY(), 200, 130)
    elseif defeitos[1] then
      love.graphics.setColor(1,0,0, 0.1)
      love.graphics.rectangle('fill', 300, oeb:getY(), 200, -80)
      love.graphics.setColor(1,0,0)
      love.graphics.rectangle('line', 300, oeb:getY(), 200, -80)
    elseif defeitos[3] then
      love.graphics.setColor(1,0,0, 0.1)
      love.graphics.rectangle('fill', 210 - 30, -700, 165, 90)
      love.graphics.setColor(1,0,0)
      love.graphics.rectangle('line', 210 - 30, -700, 165, 90)
    end
  end
end

function simulacao.mousepressed(x, y)
  manutencao.mousepressed(x, y)
  love.graphics.setColor(1,0,0)
  trajetoria.mousepressed(x, y)
end

function simulacao.keypressed(key)
  for i = 1, 6 do
    if tonumber(key) == i then
      ordena_pedidos(i)
    end
  end
  cenario.keypressed(key)
  if key == 'escape' then
    currState = menu
  end
  if key =="i" then
    currState = menu_pedidos
  end
  if key == 'up' then
    y_cam = y_cam  + 1
  end
  if key == 'p' then
    io.write(engineer.yCoord)
    io.write('\t')
    io.write(engineer.xCoord)
    io.write('\t')
    io.write(tostring(engineer.canFixMotor))
    io.write('\n')
  end
  manutencao.keypressed(key)
end

return simulacao