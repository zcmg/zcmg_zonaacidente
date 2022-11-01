Config = {}

-- Jobs com permisão para fazer o comando
Config.Jobs = {
    {"police"},
    {"ambulance"}
}

Config.Tempo = false -- Se activo permite definir a zona de acidente durante o tempo (em minutos)

Config.ComandoAtivar = "zonaacidente" -- Comando para ativar a zona de acidente
Config.ComandoDesativar = "zonaacidenteconcluir" --Comando para desativar a zona de acidente