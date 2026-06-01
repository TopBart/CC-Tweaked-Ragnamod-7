local config  = require("config")
local modem   = peripheral.find("modem")
local monitor = peripheral.find("monitor")
local speaker = peripheral.find("speaker")

if not modem then
  print("Erreur : modem introuvable !")
  return
end

rednet.open(peripheral.getName(modem))
print("Récepteur actif, en attente...")

local function afficherMonitor(alertes)
  if not monitor then return end
  monitor.clear()
  monitor.setCursorPos(1,1)

  if #alertes == 0 then
    monitor.setTextColor(colors.green)
    monitor.write("Stock OK")
  else
    monitor.setTextColor(colors.red)
    monitor.write("ALERTES : " .. #alertes)
    for i, a in pairs(alertes) do
      monitor.setCursorPos(1, i + 1)
      monitor.setTextColor(colors.orange)
      monitor.write(string.format("%s: %d/%d", a.label, a.qte, a.seuil))
    end
  end
  monitor.setTextColor(colors.white)
end

while true do
  local _, message, protocole = rednet.receive(config.protocole)

  if message == "OK" then
    afficherMonitor({})
    print("Stock OK")

  elseif string.sub(message, 1, 6) == "ALERTE" then
    local _, label, qte, seuil = string.match(message, "([^|]+)|([^|]+)|([^|]+)|([^|]+)")
    local alerte = { label = label, qte = tonumber(qte), seuil = tonumber(seuil) }

    afficherMonitor({ alerte })
    print(string.format("ALERTE : %s %d/%d", label, alerte.qte, alerte.seuil))

    if speaker then speaker.playNote("harp", 1.0, 5) end
  end
end