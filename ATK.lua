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