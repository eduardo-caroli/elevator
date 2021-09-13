manutencao = {}
local auxiliar_manutencao = require 'auxiliar_manutencao'
local elevador = require 'elevador'
local cenario = require 'cenario'
local interruptor = require 'interruptor'
local duto = require 'duto'
local fundo = require 'fundo'
local engineman = require 'engineman'

function danger_bar(x, y, w, h, nL, fill)
  love.graphics.setColor(0,0,0)
  wLine = w / (2*nL)
  for i = 0, nL-1 do
    if fill then
      love.graphics.polygon('fill', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    else
      love.graphics.polygon('line', x + (i*2*wLine), y+h, x + wLine + (i*2*wLine), y+h, x + 2*wLine + (i*2*wLine), y, x + wLine +(i*2*wLine), y)
    end
  end
  love.graphics.rectangle('line', x, y, w, h)
end

function aviso(x, y, w, h)
  love.graphics.setFont(tahoma, scala)
  love.graphics.setColor(1,1,0)
  love.graphics.rectangle('fill', x, y, w, h)
  love.graphics.setColor(.6, .6, .6)
  love.graphics.rectangle('fill', x, y + h/12, 13*w/40, 5*h/6)
  love.graphics.rectangle('fill', x+(27*w/40), y + h/12, 13*w/40, 5*h/6)
  love.graphics.rectangle('fill', x+(13*w/40), y + 34*h/48, 7*w/20, h/4.8)
  love.graphics.rectangle('fill', x+(13*w/40), y + h/12, 7*w/20, h/3)
  love.graphics.setColor(1,1,1,transparencia_da_placa)
  love.graphics.draw(placa, x + 9*w/10, y + (h/12) + 10, 0, .1, .1,placa:getWidth()/2)
  love.graphics.draw(placa, x + (1*w/10), y + (10+(h/12)), 0, .1, .1,placa:getWidth()/2)
  love.graphics.setColor(0,0,0)
  love.graphics.print('ATENÇÃO!', 400 - (1.6*tahoma:getWidth('ATENÇÃO')/2), y + 75, 0, 1.6, 1.6)
  danger_bar(x, y, w, h/12, 5, true)
  danger_bar(x, y + (11*h/12), w, h/12, 5, true)
  love.graphics.setLineWidth(1)
  love.graphics.rectangle('line', x, y, w, h/12)
  love.graphics.rectangle('line', x, y, w, h)
  love.graphics.rectangle('line', x, y+(11*h/12), w, h/12)
  love.graphics.setLineWidth(1)
end
scala = .3

function manutencao.load()
  ja_previu = false
  auxiliar_manutencao.load()
  timer_manutencao = 60
  timer_inicial_manutencao = 30
  manter = false
  predicao = false
  transparencia_da_placa = 0
  timertransparencia = 0
  cicla_transparencia = false
  placa = love.graphics.newImage('images/danger.png')
  ferramentas = love.graphics.newImage('images/ferramentas.png')
  lupa = love.graphics.newImage('images/looking_glass.png')
  defeitos = {true, false, false}
end

function manutencao.update(dt)
  if currState == manutencao then
    fundo.update(dt)
  end
  if manter or predicao then
    currState = manutencao
  else 
    currState = simulacao
  end
  if exibir_aviso or ja_previu then
    animacao_defeito.update(dt)
  end
  auxiliar_manutencao.update(dt)
  xM, yM = love.mouse.getPosition()
  timertransparencia = timertransparencia + dt
  if timer_manutencao > 0 then
    timer_manutencao = timer_manutencao - dt
  else
    corretiva = true
    if not manter then
      defeitos = sorteia_defeito(defeitos)
    end
    if transparencia_da_placa < 1 and cicla_transparencia then
      if timertransparencia > 0.01 then
        transparencia_da_placa = transparencia_da_placa + 0.01
        timertransparencia = 0
      end
    else
      cicla_transparencia = false
    end
    
    if transparencia_da_placa > 0 and not cicla_transparencia then
      if timertransparencia > 0.01 then
        transparencia_da_placa = transparencia_da_placa - 0.01
        timertransparencia = 0
      end
    else
      cicla_transparencia = true
    end
  end
  if manter then
    corretiva = false
    timer_manutencao = 60
    exibir_aviso = false
  end
end

function manutencao.draw()
  if exibir_aviso and ja_previu then
    aviso(200, -350 + y_cam, 400, 480)
    animacao_defeito.draw()
  end
  if predicao or manter then
    fundo.draw()
    if valores_booleanos_dos_botoes_do_menu_opcoes[5] then
      screen(850, 330, 200, 150, custo_total)
    end
  end
  love.graphics.translate(0, 450 - y_cam)
  if predicao or manter then
    cenario.draw()
    elevador.draw()
    love.graphics.setColor(1,1,1)
    interruptor.draw()
    duto.draw()
  end
  if corretiva then love.graphics.translate(0, y_cam - 450) end
  botao_manutencao(lupa, frame_lupa, dados_lupa, raio_botao_azul, {0,0,1}, y_cam)
  if not predicao then
    botao_manutencao(ferramentas, frame_ferramentas, dados_ferramentas, raio_botao_amarelo, {1,1,0}, y_cam)
  end
  if corretiva then love.graphics.translate(0, -y_cam + 450) end
  auxiliar_manutencao.draw()
  love.graphics.translate(0,y_cam - 450)
--  love.graphics.print(valor(), 100, 100)
  if love.keyboard.isDown('p') then
    love.graphics.print(scala, 0, 0)
    love.graphics.print(xM, 0, 20)
    love.graphics.print(yM, 0, 40)
  end
  if defeitos == {false, false, false} then
    print('tudo falso', 100, 200)
  end
end

function manutencao.keypressed(key)
  if key == 'm' then
    scala = scala + 0.05
  end
  if key == 'n' then
    scala = scala - 0.05
  end
end

function manutencao.mousepressed(x, y)
  x = x - 300
  auxiliar_manutencao.mousepressed(x, y)
end



return manutencao