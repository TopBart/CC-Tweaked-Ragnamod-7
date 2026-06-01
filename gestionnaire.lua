local config = require("config")
local bridge = peripheral.find("meBridge")

if not bridge then
  print("Erreur : ME Bridge introuvable !")
  return
end

local TODO_FILE = "todo.txt"

local function chargerTodo()
  local liste = {}
  if fs.exists(TODO_FILE) then
    local f = fs.open(TODO_FILE, "r")
    local ligne = f.readLine()
    while ligne do
      table.insert(liste, ligne)
      ligne = f.readLine()
    end
    f.close()
  end
  return liste
end

local function sauvegarderTodo(liste)
  local f = fs.open(TODO_FILE, "w")
  for _, tache in pairs(liste) do
    f.writeLine(tache)
  end
  f.close()
end

local function afficherStock()
  term.clear()
  term.setCursorPos(1,1)
  print("=== STOCK AE2 ===")
  print("----------------")
  local items = bridge.listItems()
  if not items or #items == 0 then
    print("Aucun item trouvé.")
  else
    table.sort(items, function(a, b) return a.amount > b.amount end)
    for _, item in pairs(items) do
      print(string.format("%-30s %d", item.displayName, item.amount))
    end
  end
  print("----------------")
  print("Appuie sur une touche...")
  os.pullEvent("key")
end

local function afficherTodo()
  while true do
    term.clear()
    term.setCursorPos(1,1)
    print("=== TODO LIST ===")
    print("----------------")
    local liste = chargerTodo()
    if #liste == 0 then
      print("  Aucune tâche !")
    else
      for i, tache in pairs(liste) do
        print(string.format("  %d. %s", i, tache))
      end
    end
    print("----------------")
    print("A) Ajouter  S) Supprimer  Q) Quitter")
    local _, key = os.pullEvent("char")
    key = string.lower(key)
    if key == "q" then
      return
    elseif key == "a" then
      write("Nouvelle tâche : ")
      local nouvelle = read()
      if nouvelle and nouvelle ~= "" then
        table.insert(liste, nouvelle)
        sauvegarderTodo(liste)
      end
    elseif key == "s" then
      write("Numéro à supprimer : ")
      local num = tonumber(read())
      if num and liste[num] then
        table.remove(liste, num)
        sauvegarderTodo(liste)
      end
    end
  end
end

while true do
  term.clear()
  term.setCursorPos(1,1)
  print("=== GESTIONNAIRE ===")
  print("")
  print("  1. Voir le stock AE2")
  print("  2. Todo list")
  print("  3. Quitter")
  print("")
  write("Choix : ")
  local choix = read()
  if choix == "1" then afficherStock()
  elseif choix == "2" then afficherTodo()
  elseif choix == "3" then break
  end
end