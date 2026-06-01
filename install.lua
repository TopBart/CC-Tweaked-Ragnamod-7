local base = "https://raw.githubusercontent.com/TopBart/CC-Tweaked-Ragnamod-7/main/"
local fichiers = {
  "config.lua",
  "alertes.lua",
  "modem_emetteur.lua",
  "modem_recepteur.lua",
  "gestionnaire.lua",
}

for _, fichier in pairs(fichiers) do
  print("Mise à jour de " .. fichier .. "...")
  -- Supprime l'ancien fichier avant de télécharger
  if fs.exists(fichier) then fs.delete(fichier) end
  shell.run("wget", base .. fichier, fichier)
end

print("")
print("Installation/mise à jour terminée !")
print("Lance 'alertes' sur le computer AE2")
print("Lance 'modem_recepteur' sur le computer écran")