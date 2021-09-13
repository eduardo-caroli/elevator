trajetoria = {}




function determina_andar_atual(coordenada_y)
  for i  = 0, numero_de_andares do
    if (600 - (200*i)) >= coordenada_y and (600 - (200*(i+1))) <= coordenada_y then
      return i
    end
  end
end


function trajetoria.load()
  pedido_que_esta_sendo_recebido = ""
  lista_de_pedidos_recebidos = {}
  fonte = love.graphics.setNewFont('fonts/Roboto-Black.ttf', 80)
  love.graphics.setFont(fonte)
  regua_ligada = true
  fact = 10
  valores_booleanos_dos_botoes_de_trajetoria = {false, false, false}
  xLinha = 10
  yLinha = 10
  xRegua = 10
  yRegua = 10
  esc = 1
  len = 10
  mensagemTraj1 = 'Ir do primeiro ao último andar (ignorar .txt - Recomendado para gerar o .csv)'
  mensagemTraj2 = 'Seguir o arquivo .txt (pedidos de funcionamentos anteriores)'
  mensagemTraj3 = 'Seguir Pedidos Online'
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
-- Função para gerar aleatoriamente um destino para um pedido (origem)
local function gera_destino(origem)
  local destino_atual = math.random(1,6)
  while destino_atual == origem do
    destino_atual = math.random(1,6)
  end
  destino_atual_da_lista_passageiros = destino_atual
  return destino_atual
end

-- Função para separar lista de pedidos em subida, descida e lista complementar
local function separa_pedidos()
  local subida = {}
  local descida = {}
  local complementar = {}
  local comeca_subindo = false
  local preencheu_subida = false
  local preencheu_descida = false
  local ultimo_preenchido
  local subindo = false
  local andar = determina_andar_atual(oeb:getY()) + 1
  local descendo = false
  if #lista_de_pedidos_recebidos == 1 then
    table.insert(subida, lista_de_pedidos_recebidos[1])
  else  
    subindo = (andar < lista_de_pedidos_recebidos[1])
    descendo = (andar > lista_de_pedidos_recebidos[1])
    if lista_de_pedidos_recebidos[1] < lista_de_pedidos_recebidos[2] then
      table.insert(subida, lista_de_pedidos_recebidos[1])
      ultimo_preenchido = "s"
      comeca_subindo = true
    else
      table.insert(descida, lista_de_pedidos_recebidos[1])
      ultimo_preenchido = "d"
      comeca_subindo = false
    end
  end
  
  for i=2, #lista_de_pedidos_recebidos - 1 do
    if lista_de_pedidos_recebidos[i] < lista_de_pedidos_recebidos[i+1] then
      if not comeca_subindo then
        preencheu_subida = true
      end
      
      if preencheu_descida or (ultimo_preenchido ~= 's' and subindo) or andar == origem then
        print(subindo)
        table.insert(complementar, lista_de_pedidos_recebidos[i])
        ultimo_preenchido = "c"
      else
        table.insert(subida, lista_de_pedidos_recebidos[i])
        ultimo_preenchido = "s"
      end
    else
      if comeca_subindo then
        preencheu_descida = true
      end
      
      if preencheu_subida or(ultimo_preenchido ~='d'and descendo) or andar == origem then 
        print('descendo:')
        print(descendo)
        table.insert(complementar, lista_de_pedidos_recebidos[i])
        ultimo_preenchido = "c"
      else
        table.insert(descida, lista_de_pedidos_recebidos[i])
        ultimo_preenchido = "d"
      end
    end
  end
  
  if #lista_de_pedidos_recebidos >= 2 then
    local ultimo = lista_de_pedidos_recebidos[#lista_de_pedidos_recebidos]
    if ultimo_preenchido == "c" then
      table.insert(complementar, ultimo)
    elseif ultimo_preenchido == "d" then
      table.insert(descida, ultimo)
    else
      table.insert(subida, ultimo)
    end
  end

  return subida, descida, complementar
end

-- Função para unificar subida, descida e lista complementar, gerando a nova lista de pedidos
local function unifica_pedidos(primeira, segunda, complementares)
  lista_de_pedidos_recebidos = {}
  for i=1, #primeira do
    table.insert(lista_de_pedidos_recebidos, primeira[i])
  end
  
  for i=1, #segunda do
    table.insert(lista_de_pedidos_recebidos, segunda[i])
  end
  
  for i=1, #complementares do
    table.insert(lista_de_pedidos_recebidos, complementares[i])
  end
  
  -- Removendo duplicatas
  for i=#lista_de_pedidos_recebidos, 2, -1 do
    if lista_de_pedidos_recebidos[i] == lista_de_pedidos_recebidos[i-1] then
      table.remove(lista_de_pedidos_recebidos, i)
    end
  end
end

-- Verifica se o andar já está ou não na lista passada por parametro
local function andar_nao_esta_na_lista(pedidos, andar)
  for i=1, #pedidos do
    if andar == pedidos[i] then
      return false
    end
  end
  
  return true
end

local function reordena_pedidos(pedidos, andar, subindo)
  if andar_nao_esta_na_lista(pedidos, andar) then
    local novos_pedidos = {}
    local ja_inseriu = false
    local condicao
    
    for i=1, #pedidos do
      if subindo then
        condicao = pedidos[i] > andar
      else
        condicao = pedidos[i] < andar
      end
      
      if condicao and not ja_inseriu then
        table.insert(novos_pedidos, andar)
        ja_inseriu = true
      end
      
      table.insert(novos_pedidos, pedidos[i])
    end
    
    if not ja_inseriu then
      table.insert(novos_pedidos, andar)
    end
    
    return novos_pedidos
  end
  
  return pedidos
end

local function mostra_tabela(nome, tabela)
  print(nome)
  for i=1, #tabela do
    io.write(tabela[i]..',')
  end
  io.write('\n')
end

function ordena_pedidos(origem)
  local destino_atual = gera_destino(origem)
  --local andar = determina_andar_atual(oeb:getY())
  passageiro_entra(destino_atual)
  local tPedido = {origem, destino_atual, false, 0}
  table.insert(tempos_dos_pedidos, tPedido)
  local andar = determina_andar_atual(oeb:getY()) + 1
--  local passageiro = create_passenger(.3, sansWalk, sansOut, sansIn, sansSheet, origem-1, destino_atual, 170, 230, 275)
  local passageiro = generate_random_passenger(origem, destino_atual)
  table.insert(passengers, passageiro)
    
  print("Origem atual:", origem)
  print("Destino atual:", destino_atual)
  
  if #lista_de_pedidos_recebidos > 1 then
    print("Lista preenchida")
    local subida, descida, complementar = separa_pedidos()

    if (andar < lista_de_pedidos_recebidos[1]) or (#lista_de_pedidos_recebidos >= 2 and andar == lista_de_pedidos_recebidos[1] and andar < lista_de_pedidos_recebidos[2]) then
      print("Elevador subindo!")
      
      if origem < destino_atual then
        print("Cliente quer subir")
        
        if andar < origem then
          print("Da tempo de atender este pedido!")
          
          subida = reordena_pedidos(subida, origem, true)
          subida = reordena_pedidos(subida, destino_atual, true)
        else
          print("Não da tempo de atender este pedido! Vai entrar para a lista complementar.")
          
          complementar = reordena_pedidos(complementar, origem, true)
          complementar = reordena_pedidos(complementar, destino_atual, true)
        end
      else
        print("Cliente quer descer")
        
        descida = reordena_pedidos(descida, origem, false)
        descida = reordena_pedidos(descida, destino_atual, false)
      end
      
      unifica_pedidos(subida, descida, complementar)
    elseif (andar > lista_de_pedidos_recebidos[1]) or (#lista_de_pedidos_recebidos >= 2 and andar == lista_de_pedidos_recebidos[1] and andar > lista_de_pedidos_recebidos[2]) then
      print("Elevador descendo!")
      
      if origem < destino_atual then
        print("Cliente quer subir")
        
        subida = reordena_pedidos(subida, origem, true)
        subida = reordena_pedidos(subida, destino_atual, true)
      else
        print("Cliente quer descer")
        
        if andar > origem then
          print("Da tempo de atender este pedido!")
          
          descida = reordena_pedidos(descida, origem, false)
          descida = reordena_pedidos(descida, destino_atual, false)
        else
          print("Não da tempo de atender este pedido! Vai entrar para a lista complementar.")
          
          complementar = reordena_pedidos(complementar, origem, false)
          complementar = reordena_pedidos(complementar, destino_atual, false)
        end
      end
      
      unifica_pedidos(descida, subida, complementar)
    end
    
    mostra_tabela("Subida:", subida)
    mostra_tabela("Descida:", descida)
    mostra_tabela("Complementar:", complementar)
    
  else
    print("Lista vazia ou com um único elemento")
    
    table.insert(lista_de_pedidos_recebidos, origem)
    table.insert(lista_de_pedidos_recebidos, destino_atual)
  end
end


function love.keypressed(k)
  if tonumber(k) >= 0 and tonumber(k) <=5 then
    ordena_pedidos(tonumber(k))
  end
end
function regua()
  if regua_ligada then
    love.graphics.line(xRegua, yRegua, xRegua + len, yRegua)
    love.graphics.line(xRegua, yRegua, xRegua, yRegua -fact)
    love.graphics.line(xRegua + len, yRegua, xRegua + len, yRegua -fact)
  end
end
function trajetoria.draw()
  love.graphics.setColor(1,1,0)
  love.graphics.setColor(0.789, 0.789, 0.789)
  botao_central(605, 525, 40.5*3, 40.5)
  love.graphics.setColor(0,0,0)
  if valores_booleanos_dos_botoes_de_trajetoria[3] or isGame then
    love.graphics.setColor(0,0,0)
    love.graphics.print("Clique pelo menos uma tecla de 0 a 6", 255, 550, 0, .2, .2)
    if pedido_que_esta_sendo_recebido ~= 't' and pedido_que_esta_sendo_recebido ~= "" then
      love.graphics.print(pedido_que_esta_sendo_recebido.."º andar", 311, 488, 0, 0.5, 0.5)
    elseif pedido_que_esta_sendo_recebido == 't' then
      love.graphics.print('Térreo', 311, 488, 0, 0.5, 0.5)
    end
  end
  love.graphics.print('Confirmar', 615, 532, 0, 0.27, 0.27)
  botao_trajetoria(1, mensagemTraj1)
  botao_trajetoria(2, mensagemTraj2)
  botao_trajetoria(3, mensagemTraj3)
  love.graphics.setBackgroundColor(0.85, 0.6, 0.6)
  love.graphics.print('Agora, falta só determinar a trajetória do elevador', 75, 50, 0, .35, .35)
  if love.keyboard.isDown('p') then
    love.graphics.print('Tamanho em px:'..tostring(len-2)..'\n'..'Posição em x:'..xLinha..'\n'..'Posição em y:'..yLinha..'\n'..'Escala:'..esc..'\n', 0, 0, 0, 1/4, 1/4)
  end
end


function trajetoria.update(dt)
  
  if valores_booleanos_dos_botoes_de_trajetoria[1] then
    pedidos = {6, 1}
  end
  if valores_booleanos_dos_botoes_de_trajetoria[3] or isGame then
    pedidos = lista_de_pedidos_recebidos
  end
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
    esc = esc + 0.1
  elseif love.keyboard.isDown('n') then
    esc = esc - 0.1
  end
  if love.keyboard.isDown('c') then
    xRegua = xLinha
    yRegua = yLinha
  end
end

function trajetoria.keypressed(key)
  if key == 'l' then
    regua_ligada = not regua_ligada
  end
  if key == 'i' then
    fact = -fact
  end
  if valores_booleanos_dos_botoes_de_trajetoria[3] then
    
    if key == '6' or key == '1' or key == '2' or key == '3' or key == '4' or key == '5' then
      ordena_pedidos(tonumber(key))
      for i = 1, #lista_de_pedidos_recebidos do 
        print(lista_de_pedidos_recebidos[i])
      end
    end
    if key == 'backspace' then
      pedido_que_esta_sendo_recebido = pedido_que_esta_sendo_recebido:sub(1, -2)
    end
  end
  end

function trajetoria.mousepressed(x, y)
  for i = 1, 3 do
    if x > 50 and x < 85 and y > 100 + 100*i and y < 135 + 100*i then
      valores_booleanos_dos_botoes_de_trajetoria = {false, false, false}
      valores_booleanos_dos_botoes_de_trajetoria[i] = not valores_booleanos_dos_botoes_de_trajetoria[i]
    end
  end
  if x > 605 and y > 525 and x < 605 + 40.5*3 and y < 525 + 40.5 then
    currState = simulacao
  end
end

return trajetoria