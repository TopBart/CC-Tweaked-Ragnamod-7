local config = require("config")
local bridge = peripheral.find("meBridge")
local modem  = peripheral.find("modem")

if not modem then
  print("Erreur : modem introuvable !")
  return
end

if not bridge then
  print("Erreur : ME Bridge introuvable !")
  return
end

rednet.open(peripheral.getName(modem))
print("Emetteur actif...")

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

  if #alertes == 0 then
    rednet.broadcast("OK", config.protocole)
  else
    for _, a in pairs(alertes) do
      local msg = string.format("ALERTE|%s|%d|%d", a.label, a.qte, a.seuil)
      rednet.broadcast(msg, config.protocole)
    end
  end

  sleep(config.intervalle)
end