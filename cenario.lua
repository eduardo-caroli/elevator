local cenario = {}
imagem_do_morador= love.graphics.newImage("images/imagem_de_uma_pessoa.png")
altura_da_imagem = imagem_do_morador:getPixelHeight()
som_campainha_1 = love.audio.newSource("sounds/som.mp3", "stream")

Pi = math.pi
cos = math.cos
sin = math.sin
xM = 50
yM = -600
esc = 1

function drawStairs()
  local degraus = 1180 / 20
  for i = 1, degraus do
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle('fill', 200, 580 - 20*i, 40, -5)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', 200, 580 - 20*i, 40, -5)
  end
  love.graphics.setColor(1,1,0)
  love.graphics.rectangle('fill', 195, -610, 5, 1190)
  love.graphics.rectangle('fill', 240, -610, 5, 1190)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', 195, -610, 5, 1190)
  love.graphics.rectangle('line', 240, -610, 5, 1190)
end

function petdoor(x, y, w, h)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill', x+1, y+1, w-2, h-2)
  --gainsboro
  --aqui sao desenhadas as tiras de plastico
  love.graphics.setColor(223/255, 223/255, 223/255)
  love.graphics.rectangle('fill', x + w/5, y + w/10, w/10, w/5)
  love.graphics.rectangle('fill', x + 7*w/10, y + w/10, w/10, w/5)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x + w/5, y + w/10, w/10, w/5)
  love.graphics.rectangle('line', x + 7*w/10, y + w/10, w/10, w/5)
  --taupe gray
  --aqui e desenhada a folha de plastico que tampa o buraco
  love.graphics.setColor(143/255, 143/255, 142/255)
  love.graphics.rectangle('fill', x + 3*w/20, y + 3*w/20, 7*w/10, 17*w/20)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x + 3*w/20, y + 3*w/20, 7*w/10, 17*w/20)
  --cor: otter brown
  --aqui e desenhada a moldura
  love.graphics.setColor(101/255,67/255,33/255)
  love.graphics.rectangle('fill', x, y, w/10, h)
  love.graphics.rectangle('fill', x+(9*w/10), y, w/10, h)
  love.graphics.rectangle('fill', x, y, w, w/10)
  love.graphics.setColor(0,0,0)
  love.graphics.line(x, y, x + w/10, y  +w/10)
  love.graphics.line(x+ 9*w/10, y+ w/10, x + w, y)
  love.graphics.line(x, y, x, y + h)
  love.graphics.line(x+w, y, x+w, y + h)
  love.graphics.line(x, y, x+w, y)
  love.graphics.line(x+w/10, y+w/10, x+(9*w/10), y+w/10)
  love.graphics.line(x+w/10, y+w/10, x+w/10, y+h)
  love.graphics.line(x+9*w/10, y+w/10, x+9*w/10, y+h)
  love.graphics.line(x, y+h, x+w/10, y+h)
  love.graphics.line(x+9*w/10, y+h, x+w, y+h)

end

function gera_cores(n_andares)
  local cores = {}
  math.randomseed(os.time())
  for i = 1, n_andares do
    local r = math.random(255)
    local g = math.random(255)
    local b = math.random(255)
    table.insert(cores, {r/255,g/255,b/255})
  end
  return cores
end

function gera_cores_paredes(n_andares)
  local cores = {}
  for i = 1, n_andares do
    local r = math.random(255)
    local g = math.random(255)
    local b = math.random(255)
    table.insert(cores, {r/255,g/255,b/255})
  end
  return cores
end



function gera_aleatorio(n, range, tabela, bool)
  --instancia uma lista com n valores aleatorios dentro do intervalo 1, range
  tabela = {}
  math.randomseed(os.time())
  for i = 1, n do
    local valor = math.random(range)
    if bool then
      if valor == 1 then
        table.insert(tabela, true)
      elseif valor == 2 then
        table.insert(tabela, false)
      else
        table.insert(tabela, valor)
      end
    else
      table.insert(tabela, valor)
    end
  end
  return tabela
end

function gera_valores_booleanos_andares(n)
  local valores = {}
  local cores_paredes = gera_cores_paredes(n)
  local moldura = gera_aleatorio(n, 2, {}, true)
  local macaneta = gera_aleatorio(n, 2, {}, false)
  local plantas = gera_aleatorio(n, 5, {}, false)
  local detalhes = gera_aleatorio(n, 3, {}, true)
  local cores_portas = gera_cores(n)
  local olho_magico = gera_aleatorio(n, 2, {}, true)
  for i = 1, n do
    table.insert(valores, {moldura[i], detalhes[i], macaneta[i], cores_portas[i], cores_paredes[i], plantas[i], olho_magico[i]})
  end
  return valores
end

function plant(x, y, w, image)
  local c = image:getPixelWidth()
  local a = image:getPixelHeight()
  local escala = w / a
  love.graphics.setColor(1,1,1)
  love.graphics.draw(image, x, y, 0, escala, escala, c/2, a)
end


function mac1(x, y, w, open)
  --essa funcao recebe as coordenadas e largura de uma PORTA, nao da macaneta em si
  if not open then
    local h = 2.1 * w
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.circle("fill", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 20)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 20)
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle("fill", x + (8 * w / 10), y + h/2, 3*w/20, h/40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x + (8 * w / 10), y + h/2, 3*w/20, h/40)
  else
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle("fill", x + w/15, y + (41 * h / 80) - (w / 20),  w/45, w/10)
    love.graphics.rectangle("fill", x + 4 * w / 45, y + 41 * h / 80 - w / 200, w/30, w/100)
    love.graphics.rectangle("fill", x + 11 * w / 90, y + h/2, w/40, h/40)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", x + w/15, y + (41 * h / 80) - (w / 20),  w/45, w/10)
  end
end

function mac2(x, y, w, open)
  local h = 2.1 * w
  if not open then
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle('fill', x + (15*w/20)+(w/8), y  + 38 * h/80, w/10, 8*h/80)
    love.graphics.circle("fill", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 24)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x + (15*w/20)+(w/8), y  + 38 * h/80, w/10, 8*h/80)
    love.graphics.circle("line", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 24)
  else
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle('fill', x + w/15, y  + 38 * h/80, w/45, 8*h/80)
    love.graphics.rectangle("fill", x + w/15 + w/35, y  + 41 * h/80 - w/24, w/35, w/12)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x + w/15, y  + 38 * h/80, w/45, 8*h/80)
  end
end

function motor(x, y, esc)
  love.graphics.setColor(123/255,182/255,97/255)
  love.graphics.rectangle('fill', x, y, 50*esc, 30*esc, 5*esc, 5*esc)
--  love.graphics.rectangle('fill', x - 5*esc, y+2*esc, 10*esc, 26*esc, 3*esc, 3*esc)
  love.graphics.setColor(.85,.85,.85)
  love.graphics.rectangle('fill', x + 8*esc + vibracao_motor, y, 5*esc, 30*esc)
  love.graphics.rectangle('fill', x + 37*esc + vibracao_motor, y, 5*esc, 30*esc)
  love.graphics.rectangle('fill', x + 50*esc + vibracao_motor, y+12.5*esc, 10*esc, 5*esc)
  love.graphics.setColor(.6,.6,.6)
  love.graphics.rectangle('fill', x + 60*esc + vibracao_motor, y + 3*esc, 10*esc, 24*esc)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x + vibracao_motor, y, 50*esc, 30*esc, 5*esc, 5*esc)
  love.graphics.rectangle('line', x + 8*esc + vibracao_motor, y, 5*esc, 30*esc)
  love.graphics.rectangle('line', x + 37*esc + vibracao_motor, y, 5*esc, 30*esc)
  love.graphics.rectangle('line', x + 50*esc + vibracao_motor, y+12.5*esc, 10*esc, 5*esc)
  love.graphics.rectangle('line', x + 60*esc + vibracao_motor, y + 3*esc, 10*esc, 24*esc)
  love.graphics.draw(electricity, 235 + vibracao_motor, -650, 0, .1, .1)
  love.graphics.setColor(1,1,1)
  if defeitos[3] and corretiva then
    love.graphics.draw(fumaca, quads_fumaca[framefumaca], x + 7, y - 45, 0, .65, .65)
  end
end

function polia(x, y, r, theta, posx, isContrapeso, isMotor)
  local yElevador = oeb:getY()
  local distancia_linhas = 3
  local comprimento_do_cabo = 200*numero_de_andares + 2*80
  local distancia_ao_telhado = math.abs(y - yElevador)
  local altura_do_contrapeso = (comprimento_do_cabo - distancia_ao_telhado) - 800
  local n_de_linhas = distancia_ao_telhado / distancia_linhas
  love.graphics.setColor(0.789,0.789,0.789)
  local altura_do_telhado = 600 - numero_de_andares*200
  local distancia_ao_telhado_contrapeso = math.abs(y - altura_do_contrapeso)
  local n_de_linhas_contrapeso = distancia_ao_telhado_contrapeso/distancia_linhas
--  love.graphics.polygon("fill",397, altura_do_telhado, 403, altura_do_telhado, 403, oeb:getY(), 397, oeb:getY())
  if isContrapeso then
    love.graphics.setColor(.6,.6,.6)
    love.graphics.rectangle('fill', x + r, y, -6, distancia_ao_telhado_contrapeso)
    love.graphics.rectangle('fill', x - r + 6, y, -6, distancia_ao_telhado)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x + r, y, -6, distancia_ao_telhado_contrapeso)
    love.graphics.rectangle('line', x - r + 6, y, -6, distancia_ao_telhado)
    for i = -1, n_de_linhas do
      love.graphics.line(x-r+6, yElevador -3*i, x-r, yElevador-3*i-5)
    end
    for i = -1, n_de_linhas_contrapeso do
      love.graphics.line(x+r-6, altura_do_contrapeso -3*i, x+r, altura_do_contrapeso-3*i-5)
    end
    love.graphics.setColor(.6, .6, .6)
    love.graphics.rectangle('fill', x+r-3-15, altura_do_contrapeso, 30, 60)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x+r-3-15, altura_do_contrapeso, 30, 60)
    if defeitos[1] and corretiva then
      dualDegrade(800, {1,0,0}, -6, 20, 0.5, x - r + 6, oeb:getY() - 30)
    end
  elseif isMotor then
    love.graphics.setColor(.6,.6,.6)
    love.graphics.rectangle('fill', x, y-r, 90, 6)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x, y-r, 90, 6)
    for i = -1, 30 do
      love.graphics.line(x + 3*i + 5 + varPoliaHorizontal, y - r + 6, x + 3*i + varPoliaHorizontal, y - r)
    end
    love.graphics.setColor(.6,.6,.6)
    love.graphics.rectangle('fill', x-r, y, 6, 63)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x-r, y, 6, 63)
    for i = -1, 20 do
      love.graphics.line(x-r, y + 3*i - varPoliaHorizontal,x-r+6, y+3*i+5 - varPoliaHorizontal)
    end
  else
    love.graphics.setColor(.6,.6,.6)
    love.graphics.rectangle('fill', x + r, y, -6, distancia_ao_telhado)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('line', x + r, y, -6, distancia_ao_telhado)
    for i = -1, n_de_linhas do
      love.graphics.line(x+r-6, yElevador -3*i, x+r, yElevador-3*i-5)
    end
    if defeitos[1] and corretiva then
      dualDegrade(800, {1,0,0}, -6, 20, 0.5, x + r, oeb:getY() - 30)
    end
    --Aqui, desenhamos os cabos do elevador
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

function escala(imagem, largura_max)
  local largura_inicial = imagem:getPixelWidth()
  local escala = largura_max / largura_inicial
  return escala
end

function quadro(x, y, imagem, largura_max)
  local escala = escala(imagem, largura_max)
  love.graphics.draw(imagem, x, y, 0, escala, escala)
end

function botoes_do_elevador(x, y, w)
  local escala = 1.5*w/55
  love.graphics.draw(sheet_botao_elevador, quad_botao_elevador, x, y, 0, escala, escala)
end
function interruptor(x, y, w, piso)
  local escala = w / campainha:getPixelWidth()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(campainha, quad_campainha, x, y, 0, escala, escala)    
end
function janela(x, y, cX, cY)
  --x e y são as coordenadas do centro geométrico da janela.
  -- cX e cY são as metades dos comprimentos da janela nos eixos x e y, respectivamente
  -- S = superior, I = inferior, D = direito, E = esquerdo
  local largura_da_janela = window:getPixelWidth()
  local esc = cX / largura_da_janela
  love.graphics.setColor(1,1,1)
  love.graphics.draw(window, x, y, 0, esc, esc)
--  local xSE, xIE = x - cX, x - cX
--  local xSD, xID = x + cX, x + cX
--  local ySE, ySD = y - cY, y - cY
--  local yIE, yID = y + cY, y + cY
  
--  love.graphics.setColor(77/255, 166/255, 1, 0.25)
--  love.graphics.polygon("fill", xSE, ySE, xIE, yIE, xID, yID, xSD, ySD)
--  --Aqui desenhamos o vidro
  
--  love.graphics.setColor(77/255, 25/255, 0)
  
--  love.graphics.polygon("line", xSE, ySE, xSD, ySD, xID, yID, xIE, yIE)
--  love.graphics.line(x, y + cY, x, y - cY)
--  love.graphics.line(x + cX, y, x - cX, y)
--  love.graphics.rectangle("fill", xIE - cX/8, yIE, 18*cX/8, cY/8)
  
--    --Aqui desenhamos as divisórias e o peitoril
    
  
  
--  love.graphics.setColor(100/255, 200/255, 1)
--  local xI, xS = x - 3*cX/4, x - cX/4
--  local yI, yS = y - cY/4, y - 3*cY/4
--  love.graphics.line(xI, yI, xS, yS)
--  love.graphics.line(xI + cX/4, yI, xS, yS + cY/4)
--  love.graphics.line(xI, yI - cY/4, xS - cX/4, yS)
  
--  --Aqui desenhamos os riscos da janela
  
  

  
end
roboto = love.graphics.newFont("fonts/Roboto-Black.ttf", 15)
lampadas_acesas = {}
function mesa(x, y, h, w)
  --x, y, w e h são coordenadas do canto superior esquerdo, 
  --altura e comprimento totais da mesa, respectivamente.
  love.graphics.setColor(153/255, 101/255, 21/255)
  love.graphics.rectangle("fill", x, y, w, h/3)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", x, y, w, h/3)
  --aqui, criamos o "corpo" da mesa
  
  love.graphics.setColor(153/255, 101/255, 21/255)
  love.graphics.rectangle("fill",x + w/8, y + h/3, w/8, 2*h/3)
  love.graphics.rectangle("fill",x + 3*w/4, y + h/3, w/8, 2*h/3)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",x + 3*w/4, y + h/3, w/8, 2*h/3)
  love.graphics.rectangle("line",x + w/8, y + h/3, w/8, 2*h/3)
  --aqui, desenhamos as pernas

  love.graphics.rectangle("line",x + w/5, y + h/12,3*w/5, h/6)
  love.graphics.setColor(1, 215/255, 0)
  love.graphics.circle("fill", x + w/2, y + h/6, w/48, 200)
  --aqui, criamos uma gaveta com maçaneta
  
  love.graphics.setColor(238/255, 1, 204/255)
  love.graphics.rectangle("fill", w/6 + 7 * w / 96 + x, y - h / 2, w / 48, h / 2)
  love.graphics.setColor(179/255, 179/255, 179/255)
  love.graphics.polygon("fill", x + w / 6, y, x + 2 * w / 6, y,  x + 2 * w / 6, y - h / 4, x + w / 6, y - h/4)
  love.graphics.setColor(171/255, 39/255, 79/255)
  love.graphics.polygon("fill", x + w / 6, y - h / 2, x + 2 * w / 6, y - h / 2, x + 11 * w / 36, y - 3 * h / 4, x + 7 * w / 36, y - 3 * h / 4)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", w/6 + 7 * w / 96 + x, y - h / 2, w / 48, h / 2)
  love.graphics.polygon("line", x + w / 6, y, x + 2 * w / 6, y,  x + 2 * w / 6, y - h / 4, x + w / 6, y - h/4)
  love.graphics.polygon("line", x + w / 6, y - h / 2, x + 2 * w / 6, y - h / 2, x + 11 * w / 36, y - 3 * h / 4, x + 7 * w / 36, y - 3 * h / 4)
end
function lampada(x, y, w, andar)
  h = 0.6 * w
--  x e y são as coordenadas da ponta do fio.
--  w é a largura máxima (parte do trapézio)
--  h é a distância da ponta do fio à ponta da lâmpada
  
  love.graphics.setColor(1, 0, 0)
  love.graphics.polygon("fill",x - w/3, y + (3 * h/4), x + w/3, y + (3 * h/4),  x + w / 2, y + h, x - w/2, y + h)
  love.graphics.rectangle("fill",x - w/40, y, w/20, 3 * h / 4)
  love.graphics.setColor(0,0,0)
  love.graphics.polygon("line",x - w/3, y + (3 * h/4), x + w/3, y + (3 * h/4),  x + w / 2, y+ h,x - w/2, y + h)
  love.graphics.rectangle("line",x - w/40, y, w/20, 3 * h / 4)
  --nesse bloco, criamos o fio e o suporte da luminária
  
  if lampadas_acesas[andar] == true then
    love.graphics.setColor(1, 1, 0.2, 0.3)
    love.graphics.polygon("fill", x, y + h, x - w, y +(9 * altura_da_tela / 30), x + w, y + (9 * altura_da_tela / 30))
    love.graphics.setColor(0,0,0)
    love.graphics.arc("line", x, y + h, w/8, math.pi, 0)
    love.graphics.setColor(1, 1, 0.2, 0.8)
    love.graphics.arc("fill", x, y + h, w/8, math.pi, 0)
  else
    love.graphics.setColor(0,0,0)
    love.graphics.arc("line", x, y + h, w/8, math.pi, 0)
    love.graphics.setColor(201/255, 1, 229/255, 0.5)
    love.graphics.arc("fill", x, y + h, w/8, math.pi, 0)
    
    
  end


end
function porta(x, y, w)
  -- x e y referentes às coordenadas do canto superior esquerdo,
  --  w = comprimento horizontal da porta sem a "moldura" cinza
  --  h = altura da porta sem a "moldura" cinza
  h = 2.1 * w
  fator_de_escala_x = 0.85 * (w / imagem_do_morador:getPixelWidth())
  fator_de_escala_y = 0.95 * h / altura_da_imagem
  --Aqui, definimos os fatores de escala para a imagem do "morador"
  
  love.graphics.setLineWidth(0.25)
  love.graphics.setColor(169/255, 169/255, 169/255)
  love.graphics.rectangle("fill", x - w/20, y - w/20, 1.1 * w, h + w/20)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", x, y , w, h)
  --Aqui, fazemos a moldura da porta
  
  love.graphics.rectangle("line", x - w/20, y - w/20, 1.1 * w, h + w/20)
  love.graphics.rectangle("line",x, y, w, h)
  --Aqui, desenhamos os contornos
  
  if porta_aberta == false then
    love.graphics.setColor(150/255, 111/255, 214/255)
    love.graphics.rectangle("fill",x, y, w, h)
    --aqui, desenhamos o "corpo" da porta
    
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", x + (3 * w / 20), y + (2 * h / 40) , 6 * w / 20, 5 * h / 40)
    love.graphics.rectangle("line", x + (11 * w / 20), y + (2 * h / 40) , 6 * w / 20, 5 * h / 40)
    love.graphics.rectangle("line", x + (3 * w / 20),  y + (9 * h / 40), 6 * w / 20, 15 * h / 40)
    love.graphics.rectangle("line", x + (11 * w / 20),  y + (9 * h / 40), 6 * w / 20, 15 * h / 40)
    love.graphics.rectangle("line", x + (3 * w / 20),  y + (26 * h / 40), 6 * w / 20, 12 * h / 40)
    love.graphics.rectangle("line", x + (11 * w / 20),  y + (26 * h / 40), 6 * w / 20, 12 * h / 40)
    --Aqui, desenhamos os detalhes

    love.graphics.setColor(1, 215/255, 0)
    love.graphics.circle("fill", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 20)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line", x + (8*w/10)+(w/8), y  + 41 * h/80, w / 20)
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle("fill", x + (8 * w / 10), y + h/2, 3*w/20, h/40)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", x + (8 * w / 10), y + h/2, 3*w/20, h/40)
    --aqui, a maçaneta
  else
    love.graphics.setColor(150/255, 111/255, 214/255)
    love.graphics.rectangle("fill", x, y, w/15, h)
    love.graphics.setColor(1, 215/255, 0)
    love.graphics.rectangle("fill", x + w/15, y + (41 * h / 80) - (w / 20),  w/45, w/10)
    love.graphics.rectangle("fill", x + 4 * w / 45, y + 41 * h / 80 - w / 200, w/30, w/100)
    love.graphics.rectangle("fill", x + 11 * w / 90, y + h/2, w/40, h/40)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(imagem_do_morador, x + 12 * w / 90, y + h - (altura_da_imagem * fator_de_escala_y), 0, fator_de_escala_x,fator_de_escala_y)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", x + w/15, y + (41 * h / 80) - (w / 20),  w/45, w/10)
    love.graphics.rectangle("line", x + 4 * w / 45, y + 41 * h / 80 - w / 200, w/30, w/100)
    love.graphics.rectangle("line", x + 11 * w / 90, y + h/2, w/40, h/40)
    love.graphics.rectangle("line", x, y, w/15, h)
    --Aqui, definimos como a porta vai ficar quando aberta
  end
end

--porta2(50, 29 * altura_da_tela / 30 - 144 - ((andar - 1) * altura_da_tela / 3), 144/2.1, moldura, detalhe, false, macaneta, {1,0,0})
function porta2(x, y, w, moldura, detalhes, porta_aberta, mac, olho_magico, cor)
  local porta_aberta = not porta_aberta
  local r = cor[1]
  local g = cor[2]
  local b = cor[3]
  -- x e y referentes às coordenadas do canto superior esquerdo,
  --  w = comprimento horizontal da porta sem a "moldura" cinza
  --  h = altura da porta sem a "moldura" cinza
  h = 2.1 * w
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('fill', x, y, w, h)
  if moldura then
    love.graphics.setColor(101/255,67/255,33/255)
    love.graphics.rectangle("fill", x - w/20, y - w/20, 1.1 * w, h + w/20)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", x, y , w, h)
    love.graphics.line(x - w/20, y - w/20, x, y)
    love.graphics.line(x+w, y, x + 21*w/20, y - w/20)
    love.graphics.rectangle("line", x - w/20, y - w/20, 1.1 * w, h + w/20)
    love.graphics.rectangle("line",x, y, w, h)
    --Aqui, desenhamos os contornos
    --Aqui, fazemos a moldura da porta
  end
  
  love.graphics.rectangle("line", x - w/20, y - w/20, 1.1 * w, h + w/20)
  love.graphics.rectangle("line",x, y, w, h)
  --Aqui, desenhamos os contornos
  
  if porta_aberta then
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill",x, y, w, h)
    --aqui, desenhamos o "corpo" da porta
    
    if not olho_magico then
      love.graphics.setColor(1, 215/255, 0)
      love.graphics.circle('fill', x+w/2, y + 8*h/40, h/60, 30)
      love.graphics.setColor(0,0,0)
      love.graphics.circle('line', x+w/2, y + 8*h/40, h/60, 30)
    end
    
    if detalhes == true then
      love.graphics.setColor(0,0,0)
      love.graphics.rectangle("line", x + (3 * w / 20), y + (2 * h / 40) , 6 * w / 20, 5 * h / 40)
      love.graphics.rectangle("line", x + (11 * w / 20), y + (2 * h / 40) , 6 * w / 20, 5 * h / 40)
      love.graphics.rectangle("line", x + (3 * w / 20),  y + (9 * h / 40), 6 * w / 20, 15 * h / 40)
      love.graphics.rectangle("line", x + (11 * w / 20),  y + (9 * h / 40), 6 * w / 20, 15 * h / 40)
      love.graphics.rectangle("line", x + (3 * w / 20),  y + (26 * h / 40), 6 * w / 20, 12 * h / 40)
      love.graphics.rectangle("line", x + (11 * w / 20),  y + (26 * h / 40), 6 * w / 20, 12 * h / 40)
      --Aqui, desenhamos os detalhes
    elseif detalhes == false then
      petdoor(x + w/2 - w/6, y + h - w/3, w/3, w/3)
    end
  else
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", x, y, w/15, h)
    --Aqui, definimos como a porta vai ficar quando aberta
  end
  macs[mac](x, y, w, not porta_aberta)

end
function cenario.load()
  portas_andares_abertas = {}
  for i = 1, numero_de_andares do
    table.insert(portas_andares_abertas, false)
  end
  valores_andares = gera_valores_booleanos_andares(6)
  plants = {}
  for i = 1, 5 do
    local plant = love.graphics.newImage('images/plant'..tostring(i)..'.png')
    table.insert(plants, plant)
  end
  macs = {mac1, mac2}
  electricity = love.graphics.newImage('images/electricity.png')
  som_motor = love.audio.newSource('sounds/motorelevador.mp3', 'static')
  temp_vibracao_motor = 0
  vibracao_motor = 0
  varPoliaHorizontal = 0
  anguloPolia = 0
  raioDaPolia = 20
  campainha = love.graphics.newImage("images/campainha.png")
  quad_campainha = love.graphics.newQuad(-2, 0, 50, 83, campainha:getPixelWidth(), campainha:getPixelHeight())
  sheet_botao_elevador = love.graphics.newImage("images/botao_elevador.png")
  local largura_botao_elevador = sheet_botao_elevador:getPixelWidth()
  local altura_botao_elevador = sheet_botao_elevador:getPixelHeight()
  quad_botao_elevador = love.graphics.newQuad(119, 6, 55, 83, largura_botao_elevador, altura_botao_elevador)
  sheet_interruptor = love.graphics.newImage("images/interruptor.png")
  quads_interruptor = {}
  frames_interruptor = {}
  for i = 1, 7 do
    table.insert(quads_interruptor, love.graphics.newQuad(15 + (i-1)*(44), 108, 40, 27, 422, 159))
    table.insert(frames_interruptor, 1)
  end
  window = love.graphics.newImage("images/janela.jpg")
  quadros = {}
  for i = 1,4 do
    table.insert(quadros, love.graphics.newImage("images/quadro"..tostring(i)..".png"))
  end
  table.insert(quadros, love.graphics.newImage("images/quadro5.jpg"))
  i = 1
  temp = 0
  local p = 1
  local y_quad = 232
  chami = love.graphics.newImage("images/chamine.png")
  chamine_soltando = {}
  altura_chamine = chami:getPixelHeight()
  largura_chamine = chami:getPixelWidth()
  for i = 1, 9 do
    table.insert(chamine_soltando, love.graphics.newQuad(31 + (i-1) * (45), 232, 31, 60, largura_chamine, altura_chamine))
  end
  for i = 1, 8 do
    table.insert(chamine_soltando, love.graphics.newQuad(31 + (i-1) * (45), 310, 31, 73, largura_chamine, altura_chamine))
  end
  for i = 1, 10 do
    table.insert(chamine_soltando, love.graphics.newQuad(31, 232, 31, 60, largura_chamine, altura_chamine))
  end
    
  sheet_portas = love.graphics.newImage("images/porta.png")
  largura_sheet_portas = sheet_portas:getPixelWidth()
  altura_sheet_portas = sheet_portas:getPixelHeight()
  porta_abrindo = {}
  for quad = 1,7 do
    if quad == 1 then
      table.insert(porta_abrindo, love.graphics.newQuad(3, 45, 32, 64, largura_sheet_portas, altura_sheet_portas))
    elseif 1 < quad and 7 > quad then
      table.insert(porta_abrindo, love.graphics.newQuad(3 + (33 * (quad-2)), 124, 32, 64, largura_sheet_portas, altura_sheet_portas))
    elseif quad == 7 then
      table.insert(porta_abrindo, love.graphics.newQuad(3, 203, 32, 64, largura_sheet_portas, altura_sheet_portas))
    end
  end
  --testar o que está causando erro com 'contador_de_tempo'
  cuzindopp = 1
  contador_de_tempo = 0
  --[[
      Essa tabela contém o frame em que está a animação de cada uma das portas do segundo andar ao último andar. Essa tabela "trabalha" em
      conjunto com a tabela "abrir_portas" definida na main. Se alguma das posições de abrir_portas for true, a posição de mesmo índice de
      frame_portas passará pelo processo definido pela função abrir().
  --]]
  frame_portas = {}
  for i = 1,numero_de_andares-2 do
    table.insert(frame_portas, 1)
  end
  abrir_tela = false
  porta_aberta = false
  numero_de_andares = 1
end
function cria_andares(n_de_andares, cores)
  numero_de_andares = n_de_andares
  for i = 1, numero_de_andares, 1 do
    table.insert(lampadas_acesas, false)
  end
  local altura = love.graphics.getPixelHeight()
  local largura = love.graphics.getPixelWidth()
  local coordenada_x = (19 * largura / 32) * 8/14
  for andar = 1, n_de_andares, 1 do
    if andar > 1 and andar <= 6 then
      love.graphics.setColor(1,1,1)
      if andar == 5 then
        quadro(210, 29 * altura_da_tela/30 - 109 - ((andar - 1) * altura_da_tela / 3), quadros[andar - 1], 30)
      else
        quadro(210, 29 * altura_da_tela/30 - 109 - ((andar - 1) * altura_da_tela / 3), quadros[andar - 1], 60)
      end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", coordenada_x, 24 * altura_da_tela / 30 - 6 - ((andar - 1) * altura_da_tela / 3), 100, 26)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(tostring(andar-1).."º ANDAR", coordenada_x, 24 * altura_da_tela / 30 - ((andar - 1) * altura_da_tela / 3), 100, "center")
    love.graphics.setColor(47/255, 79/255, 79/255)
    if andar == 1 then
      love.graphics.rectangle("fill", -300, 29 * altura/30 - ((andar - 1) * altura_da_tela / 3), 1400, altura / 30)
    else
      love.graphics.rectangle("fill", 0, 29 * altura/30 - ((andar - 1) * altura_da_tela / 3), 800, altura / 30)
    end
    local cor_parede = {.789, .789, .789}
    love.graphics.setColor(cor_parede[1], cor_parede[2], cor_parede[3])
    love.graphics.rectangle("fill", 0, 20 * altura/30 - ((andar - 1) * altura_da_tela / 3), 800, 9*altura / 30)
    janela(700, 29 * altura_da_tela/30 - 104 - ((andar - 1) * altura_da_tela / 3), 65, 65)
    botoes_do_elevador(330, 29*altura_da_tela/30 - 67 - ((andar - 1) * altura_da_tela / 3), 10)
--    interruptor(570 + 144/2.1, 29 * altura_da_tela / 30 - 72 - ((andar - 1) * altura_da_tela / 3), 10, andar)
    lampada(300, altura_da_tela * (1 - andar/3), 40,andar)
    lampada(500, altura_da_tela * (1 - andar/3), 40, andar)
    lampada(700, altura_da_tela * (1 - andar/3), 40, andar)
    love.graphics.setColor(0, 21/255, 29/255)
    love.graphics.rectangle("fill", 7*largura_da_tela/16, altura_da_tela - (altura_da_tela * n_de_andares / 3), largura / 14, altura_da_tela * n_de_andares / 3 - altura_da_tela/30)
    if andar == 1 then
      love.graphics.setColor(1, 1, 1)
      love.graphics.rectangle("fill", coordenada_x, 24 * altura_da_tela / 30 - 6, 100, 26)
      love.graphics.setColor(0,0,0)
      love.graphics.printf("TÉRREO", coordenada_x, 24 * altura_da_tela / 30, 100, "center")
      mesa(50, 29 * altura_da_tela / 30 - 50, 50, 100)
      lampada(100, 2 * altura_da_tela / 3, 40, 1)
    elseif andar == 2 then
      porta(50, 29 * altura_da_tela / 30 - 144 - (altura_da_tela / 3), 144/2.1, 991)
      interruptor(70 + 144/2.1, 29 * altura_da_tela / 30 - 72 - (altura_da_tela / 3), 10, 0)
    else
      local moldura, detalhe, macaneta, cor_porta = valores_andares[andar][1], valores_andares[andar][2], valores_andares[andar][3], valores_andares[andar][4]
      local olho_magico = valores_andares[7]
      local openDoor = portas_andares_abertas[andar-1]
      porta2(50, 29 * altura_da_tela / 30 - 144 - ((andar - 1) * altura_da_tela / 3), 144/2.1, moldura, detalhe, openDoor, macaneta, olho_magico, cor_porta)
      interruptor(70 + 144/2.1, 29 * altura_da_tela / 30 - 72 - ((andar - 1) * altura_da_tela / 3), 10, 0)
    end
  end
  love.graphics.setColor(161/255,202/255,241/255)
  love.graphics.setColor(1,0,0,0)
  love.graphics.rectangle("fill",0, altura_do_telhado - 2 * altura_da_tela / 3, 800, 2 * altura_da_tela / 3)
  love.graphics.setColor(203/255,65/255,84/255)
  love.graphics.rectangle('fill', 0, altura_do_telhado + 90, 800, 10)
  love.graphics.polygon("fill",-7, altura_do_telhado, 70, altura_do_telhado - 50, 730, altura_do_telhado - 50, 807, altura_do_telhado)
  love.graphics.setColor(0,0,0)
  love.graphics.polygon("line",-7, altura_do_telhado, 70, altura_do_telhado - 50, 730, altura_do_telhado - 50, 807, altura_do_telhado)
  love.graphics.rectangle('line', 0, altura_do_telhado + 90, 800, 10)
  love.graphics.setColor(1,1,1)
end

function cenario.update(dt)
  if velocidadeY ~= 0 then
    temp_vibracao_motor = temp_vibracao_motor + dt
    if vibracao_motor < 1 and temp_vibracao_motor > 0.1 then
      vibracao_motor = vibracao_motor + 1
      temp_vibracao_motor = 0
    end
    if vibracao_motor > -1 and temp_vibracao_motor > 0.1 then
      vibracao_motor = vibracao_motor -1
      temp_vibracao_motor = 0
    end
  end
  if love.keyboard.isDown('up') then
    yM = yM - 1
  elseif love.keyboard.isDown('down') then
    yM = yM + 1
  end
  if love.keyboard.isDown('left') then
    xM = xM - 1
  elseif love.keyboard.isDown('right') then
    xM = xM + 1
  end
  if love.keyboard.isDown('m') then
    esc = esc + 0.01
  elseif love.keyboard.isDown('n') then
    esc = esc - 0.01
  end
  if varPoliaHorizontal > -3 and varPoliaHorizontal < 3 then
    varPoliaHorizontal = varPoliaHorizontal + velocidadeY/MtoP
  else
    varPoliaHorizontal = 0
  end
  local velocidadeAngularPolia = velocidadeY / (20 * MtoP)
  anguloPolia = anguloPolia + velocidadeAngularPolia
  
  contador_de_tempo = contador_de_tempo + dt
  for porta = 1, #abrir_portas - 1 do
    if abrir_portas[porta] == true then
      if frame_portas[porta] < 7 then
        if contador_de_tempo > 0.15 then
          frame_portas[porta] = frame_portas[porta] + 1
          contador_de_tempo = 0
        end
      elseif frame_portas[porta] == 7 and contador_de_tempo > 1 then
        abrir_portas[porta] = false
        contador_de_tempo = 0
      end
    elseif abrir_portas[porta] == false and frame_portas[porta] > 1 then
      if contador_de_tempo > 0.15 then
        frame_portas[porta] = frame_portas[porta] - 1
        contador_de_tempo = 0
      end
    end
  end
  temp = temp + dt
    if i < 27 then
      if temp > 0.1 then
        i = i + 1
        temp = 0
      end
    elseif i == 27 then
      if temp > 0.1 then
        i = 1
        temp = 0
      end
    end
end

function cenario.draw(cores)
  if love.keyboard.isDown('p') then
    love.graphics.print(xM, 50, -600)
    love.graphics.print(yM, 50, -620)
    love.graphics.print(esc, 50, -640)
  end
  love.graphics.setColor(.789,.789,.789)
  love.graphics.rectangle('fill', 0, altura_do_telhado, 800, 90)
  motor(210, -655, 1.5)
  vetor(310, -635, fMotor)
  love.graphics.setFont(roboto)
  love.graphics.setBackgroundColor(161/255,202/255,241/255)
  cria_andares(6, cores)
  love.graphics.setColor(1,1,1)
  --vamos desabilitar o desenho da chaminé por enquanto
--  if i <= 9 or i > 17 then
--    love.graphics.draw(chami, chamine_soltando[i], 550, altura_do_telhado - 101, 0, 1.5, 1)
--  elseif i > 9 and i <= 17 then
--    love.graphics.draw(chami, chamine_soltando[i], 550, altura_do_telhado - 115, 0, 1.5, 1)
--  end
  polia(325, altura_do_telhado +25, 20, anguloPolia, oeb:getY(), false, true)
  polia(415, altura_do_telhado +25, 20, anguloPolia, oeb:getY(), false, false)
  polia(385, altura_do_telhado +65, 20, -anguloPolia, oeb:getY(), true, false)
  local yElevador = oeb:getY()
  local y = altura_do_telhado + 65
  local distancia_linhas = 3
  local comprimento_do_cabo = 200*numero_de_andares + 2*80
  local distancia_ao_telhado = math.abs(y - yElevador)
  local altura_do_contrapeso = (comprimento_do_cabo - distancia_ao_telhado) - 800
  vetor(401, altura_do_contrapeso, -fContrapeso)
  vetor(401, altura_do_contrapeso+60, 500*9.81)
  love.graphics.setColor(.789,.789,.789)
  love.graphics.rectangle('fill', 297, -612, 20, 0.72)
  love.graphics.setColor(203/255,65/255,84/255)
  love.graphics.rectangle('fill', 0, altura_do_telhado + 90, 800, 10)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', 0, altura_do_telhado + 90, 800, 10)
  if not valores_booleanos_dos_botoes_do_menu_opcoes[1] then
    love.graphics.setColor(203/255,65/255,84/255)
    love.graphics.rectangle('fill', 0, altura_do_telhado, 800, 90)
  end
  vetor(310, -635, fMotor)
end

function cenario.keypressed(key)
  if key == "space" then
    valores_andares = gera_valores_booleanos_andares(6)
  end
  if key == "l" then
    for i = 1, #lampadas_acesas, 1 do
      lampadas_acesas[i] = true
    end
  end
  if key == "d" then
    for i = 1, #lampadas_acesas, 1 do
      lampadas_acesas[i] = false
    end
  end
  if key == 'p' then
    io.write(tostring(passengers[1].hasShutDoor)..'\n')
    for i = 1, #pedidos do
      if i == #pedidos then
        io.write(pedidos[i]..'\n')
      else
        io.write(pedidos[i]..'\t')
      end
    end
  end
end
return cenario