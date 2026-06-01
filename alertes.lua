local config  = require("config")
local bridge  = peripheral.find("meBridge")
local speaker = peripheral.find("speaker")
local modem   = peripheral.find("modem")

if not bridge then
  print("Erreur : ME Bridge introuvable !")
  return
end

if modem then
  print("Modem détecté, lancement de modem_emetteur...")
  shell.run("modem_emetteur")
  return
end

local function getQuantite(itemName)
  local item = bridge.getItem({ name = itemName })
  if item then return item.amount else return 0 end
end

while true do
  local alertes = {}

  for _, item in pairs(config.items) do
    local qte = getQuantite(item.name)
    if qte < item.seuil then
      table.insert(alertes, {
        label = item.label,
        qte   = qte,
        seuil = item.seuil
      })
    end
  end

  term.clear()
  term.setCursorPos(1,1)
  print("=== Surveillance AE2 ===")
  print(os.date())

  if #alertes == 0 then
    print("Tout est OK !")
  else
    print("ALERTES :")
    for _, a in pairs(alertes) do
      print(string.format("  %s : %d / %d", a.label, a.qte, a.seuil))
    end
    if speaker then speaker.playNote("harp", 1.0, 5) end
  end

  sleep(config.intervalle)
end