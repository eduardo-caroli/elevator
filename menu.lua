menu = {}


function clica_botao(x, y, w, h, xM, yM)
  if x < xM and x + w > xM and y < yM and yM < y + h then
    return true
  else
    return false
  end
end


function setJanelaPeq()
  local largura = love.graphics.getPixelWidth()
  if largura > 800 then
    love.window.setMode(800, 600)
  end
end
function elevador(x, y, w)
  --love.graphics.polygon('line', x +15*w/32, 0, x + 17*w/32, 0, x +17*w/32, 600, x +15*w/32, 600)

  local h = 1.3 * w
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", x, y, w, h)
  --Aqui, desenhamos a "caixa" do elevador
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", x + w / 10, y + w / 10, 4 * w / 5, h / 2 )
  --Aqui desenhamos o espelho
  
  love.graphics.setColor(0,0,0)
  local xM = x + w / 2
  local yM = y + w / 10 + h / 4
  local cX = 4 * w / 10
  local cY = h / 4
  love.graphics.setColor(0,0,0)
  local xI, xS = xM - 3*cX/4, xM - cX/4
  local yI, yS = yM - cY/4, yM - 3*cY/4
  love.graphics.line(xI, yI, xS, yS)
  love.graphics.line(xI + cX/4, yI, xS, yS + cY/4)
  love.graphics.line(xI, yI - cY/4, xS - cX/4, yS)
  --Aqui, desenhamos o reflexo no espelho
  
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", x + w/10, y + w / 5 + h / 2, 4 * w / 5, w / 20)
  --Aqui, desenhamos a "barra" do elevador
  
end




function contorno(x, y, w, h)
  love.graphics.rectangle("fill",x,y,w,h)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",x,y,w,h)
end

function botao_central(x, y, w, h)
  local xM, yM = love.mouse.getPosition()
  if x < xM and x+w > xM and y < yM and y+h > yM then
    love.graphics.setColor(0.85, .85, .85)
  else
    love.graphics.setColor(0.75, 0.75, 0.75)
  end
  contorno(x, y, w, h)
end

function menu.load()
  som_de_fundo = love.audio.newSource('sounds/background.mp3', 'stream')
  fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 80)
  xLinha = 214
  yLinha = 26
  len = 1.3
  w = 1.3 * 50
  velocidades = {}
  posix = {}
  for i = 1, 5 do
    table.insert(posix, math.random(450))
    local random = -math.random(2000, 3000)/0  table.insert(velocidades, random)
  end
end


function menu.draw()
  for i = 1, 5 do
    elevador(160*i - 110, posix[i], 50)
  end
  botao_central(217.5 , 194, 365, 55)
  botao_central(217.5 , 294, 365, 55)
  botao_central(217.5 , 394, 365, 55)
  botao_central(217.5 , 494, 365, 55)
  love.graphics.setFont(fonte)
  love.graphics.setBackgroundColor(0.85, 0.6, 0.6)
  love.graphics.setColor(0,0,0)
  if tela_inicial then
    love.graphics.print("Jogar", 352.5, 200, 0, .43, .43)
    love.graphics.print("Simulação", 400 - (.43*fonte:getWidth('Simulação')/2), 300, 0, .43, .43)
    love.graphics.print("Opções", 344, 500, 0, .43, .43)
    love.graphics.print("Controles", 325, 400, 0, .43, .43)
  else
    love.graphics.print("Opções", 344, 500, 0, .43, .43)
    love.graphics.print("Controles", 325, 400, 0, .43, .43)
    love.graphics.print("Dar ragequit", 310, 300, 0, .43, .43)
    if isGame then
        love.graphics.print("Voltar ao Jogo", 288.5, 200, 0, .43, .43)
    else
        love.graphics.print("Voltar à Simulação", 400 - (.43*fonte:getWidth("Voltar à Simulação")/2), 200, 0, .43, .43)
    end
  end
  love.graphics.setColor(1,1,1)
  love.graphics.print("Elevator", 214, 26, 0, 1.29, 1.3)
  love.graphics.setColor(0,0,0)
end

function menu.update(dt)
  setJanelaPeq()
  if currState == menu then
    love.audio.play(som_de_fundo)
  end
  for i = 1, 5 do
    if posix[i] < -w then
      posix[i] = 600
      velocidades[i] = -math.random(2000, 3000)/2000    
    else
      posix[i] = posix[i] + velocidades[i]
    end
  end
end

function menu.mousepressed(x, y)
  if clica_botao(217.5 , 304, 365, 55, x, y) then
    love.audio.pause(som_de_fundo)
    if tela_inicial then
      currState = trajetoria
      tela_inicial = false
    else
      love.event.quit()
    end
  end
  if clica_botao(217.5, 404, 365, 55, x, y) then
    fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 60)
    currState = controles
  end  
  if clica_botao(217.5, 204, 365, 55, x, y) then
    if tela_inicial then 
      isGame = true
      tela_inicial = false
    end
    currState = simulacao
  end  
  if clica_botao(217.5, 504, 365, 55, x, y) then
    fonte = love.graphics.newFont('fonts/Roboto-Black.ttf', 60)
    currState = opcoes
  end
end

function menu.keypressed(key)
  if key == 'g' then
    love.graphics.setBackgroundColor(0.6, 0.85, 0.6)
  end
end
return menu