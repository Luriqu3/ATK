





































































































UI.Button("Amiguinhos", function()
  UI.MultilineEditorWindow(storage.FriendText or "", {title="Amigos", description="Adicionados", width=250, height=200}, function(text)
      storage.FriendText = text
      reload()
  end)
end)


isAmigo = function(name)
  if type(name) ~= 'string' then
      name = name:getName()
  end
  local tabela = storage.FriendText and storage.FriendText:split('\n') or {}
  return table.find(tabela, name:trim(), true) ~= nil
end


local enemyMacro = macro(50, 'Enemy', function() 
  local possibleTarget = nil
  local possibleTargetHP = 100 

  for _, creature in ipairs(getSpectators(posz())) do
      local specHP = creature:getHealthPercent()
      if creature:isPlayer() and specHP and specHP > 0 then
          if not isAmigo(creature) and creature:getEmblem() ~= 1 then
              if creature:canShoot(9) then
                  if not possibleTarget or possibleTargetHP > specHP or (possibleTargetHP == specHP and possibleTarget:getId() < creature:getId()) then
                      possibleTarget = creature
                      possibleTargetHP = specHP
                  end
              end
          end
      end
  end

  if possibleTarget and g_game.getAttackingCreature() ~= possibleTarget then
      g_game.attack(possibleTarget)
  end
end)


posEnemy = addIcon("Enemy", {item = 21979, text = "Enemy"}, enemyMacro)
posEnemy:breakAnchors()
posEnemy:move(200, 450)





    
    function defineHotkey()
    local tecla = tonumber(storage.tecla) or 1 
    hotkey(tecla, "Follow", function()
        if not g_game.isAttacking() and not g_game.isFollowing() then
            follow(getCreatureByName(storage.seg))
        end
    end)
end


UI.Label("Tecla Do Follow")
addTextEdit("tecla", storage.tecla or "1", function(widget, text) 
    storage.tecla = text
    defineHotkey()
end)


UI.Label("Nome")
addTextEdit("seg", storage.seg or "nick do player", function(widget, text) 
    storage.seg = text
end)


defineHotkey()



macro(100, "Attack Follow Hp50%", function()
    local target = g_game.getAttackingCreature()
      if target and target:isPlayer() and target:getHealthPercent() <= 50 then
          g_game.setChaseMode(1)
    end
end)



macro(200, "ATCPK", function()

for _,pla in ipairs(getSpectators(posz())) do

attacked = g_game.getAttackingCreature()

if not attacked or attacked:isMonster() or attacked:isPlayer() and pla:getHealthPercent() < attacked:getHealthPercent()*0.6 then
if pla:isPlayer() and pla:getEmblem() ~= 1 and pla:getSkull() == 3 then 
g_game.attack(pla)
end
end

end

delay(100)

end)



Panels.AttackLeaderTarget(batTab)  

