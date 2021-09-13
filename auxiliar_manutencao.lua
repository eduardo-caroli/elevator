auxiliar_manutencao = {}

function barra(x, y, tamanho, altura, timer, limite_de_tempo)
  local ratio = (timer/limite_de_tempo)
  local comprimento_atual = ratio * tamanho
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('fill', x, y, tamanho, altura)
  love.graphics.setColor((1-ratio)+.2, ratio+.2, 0)
  love.graphics.rectangle('fill', x, y, comprimento_atual, altura)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle('line', x, y, comprimento_atual, altura)
end
  
function sorteia_defeito(defeitos)
  math.randomseed(os.time())
  local j = math.random(3)
  tudoFalse= true
  for i =1 , #defeitos do
    if defeitos[i] == true then
      tudoFalse = false
    end
  end
  if tudoFalse then
    defeitos[j] = true
  end
  return defeitos
end

function botao_redondo (xCentro, yCentro, raio, x, y)
  if math.sqrt((x - xCentro)^2 + (y - yCentro)^2) <= raio then
    return true
  end
  return false
end

function escandir(char, string)
  char = '['..char..']'
  posChar = 1
  subStrings = {}
  while string:find(char) ~= nil do
    posChar = string:find(char)
    table.insert(subStrings, string:sub(1, posChar - 1))
    string = string:sub(posChar + 1, -1)
  end
  table.insert(subStrings, string)
  return subStrings
end
    


function le_csv_de_animacao(filename)
  dados = {}
  local file = io.open(filename, 'r')
  for line in file:lines() do
    valores = escandir(',', line)
    for i = 1, #valores do
      valores[i] = tonumber(valores[i])
    end
    table.insert(dados, valores)
  end
  return dados
end

function atualiza_frame(frame, limiteInferior, limiteSuperior, valorBooleano)
  if frame < limiteSuperior and valorBooleano then
    frame = frame + 1
    valorBooleano = true
  else
    frame = limiteInferior
    valorBooleano = false
  end
  return frame, valorBooleano
end

function atualiza_raio(raio, valorBooleano, contador, limite)
  if valorBooleano then
    if contador < limite then
      raio = raio + 100
    elseif raio > 50 then
      raio = raio - 100
    end
  end
  return raio
end

function botao_manutencao(imagem, frame, dados, raioBotao, corBotao, yCam)
  local x = dados[frame][1]
  local y = dados[frame][2] - 450 + yCam
  local angulo = dados[frame][3]
  local escala = dados[frame][4]
  local xM, yM = love.mouse.getPosition()
  if botao_redondo(x, y , raioBotao, xM, yM) and raioBotao <= 50 then
    love.graphics.setColor(corBotao[1]-.1, corBotao[2]-.1, corBotao[3]-.1)
  else
    love.graphics.setColor(corBotao[1], corBotao[2], corBotao[3])
  end
  if not predicao and not manter and not corretiva then
    love.graphics.circle('fill', x, y- 450 + y_cam, raioBotao)
    love.graphics.setColor(0,0,0)
    love.graphics.circle('line', x, y- 450 + y_cam, raioBotao)
    love.graphics.draw(imagem, x, y - 450 + y_cam, angulo, escala, escala,imagem:getWidth()/2, imagem:getHeight()/2)
  else
    love.graphics.circle('fill', x, y, raioBotao)
    love.graphics.setColor(0,0,0)
    love.graphics.circle('line', x, y, raioBotao)
    love.graphics.draw(imagem, x, y, angulo, escala, escala,imagem:getWidth()/2, imagem:getHeight()/2)
  end
end

function auxiliar_manutencao.load()
  lupa = love.graphics.newImage('images/looking_glass.png')
  ferramentas = love.graphics.newImage('images/ferramentas.png')
  dados_ferramentas = le_csv_de_animacao('animacao_ferramentas.csv')
  dados_lupa = le_csv_de_animacao('animacao_lupa.csv')
  raio_botao_azul = 43
  raio_botao_amarelo = 43
  predicao = false
  manter = false
  exibir_aviso = false
  frame_ferramentas = 2
  frame_lupa = 1
end

function auxiliar_manutencao.update(dt)
  frame_ferramentas, manter = atualiza_frame(frame_ferramentas, 2, #dados_ferramentas, manter)
  frame_lupa, predicao = atualiza_frame(frame_lupa, 1, #dados_lupa, predicao)
  raio_botao_amarelo = atualiza_raio(raio_botao_amarelo, manter, frame_ferramentas, #dados_ferramentas/2)
  raio_botao_azul = atualiza_raio(raio_botao_azul, predicao, frame_lupa, #dados_lupa/2)
end 

function auxiliar_manutencao.draw()
end

function auxiliar_manutencao.mousepressed(x, y)
  if botao_redondo(57, 350, 50, x, y)  then
    if (ja_previu or corretiva) then
      for i = 1, 3 do
        if (defeitos[i] == engineer.canFix[i] and defeitos[i] == true) then
          manter = true
          love.audio.play(som_elevador)
          ja_previu = false
          defeitos[1] = false
          defeitos[2] = false
          defeitos[3] = false
        end
      end
    end
  end
  if botao_redondo(57, 500, 50, x, y) then
    if not ja_previu then
      predicao = true
      defeitos = {false, false, true}--sorteia_defeito(defeitos)
      ja_previu = true
    else
      exibir_aviso = not exibir_aviso
    end
  end
end

return auxiliar_manutencao


