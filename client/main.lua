Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    ESX.TriggerServerCallback('zcmg_zonaacidente:estado', function(cb)
        if cb.blip then
            local coords = cb.blipcoords
            CreateBlip(coords, 4, 1, 0.7)
            CreateBlip2(coords, "Zona de Acidente", 380, 1, 0.7)
        end
    end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('zcmg_zonaacidente:blipremove')
AddEventHandler('zcmg_zonaacidente:blipremove', function()
    RemoveBlip(blip)
    RemoveBlip(blip2)
    exports['zcmg_notificacao']:Alerta("POLICIA", "Zona de acidente concluida!", 5000, 'sucesso')
end)


RegisterNetEvent('zcmg_zonaacidente:blipcreate')
AddEventHandler('zcmg_zonaacidente:blipcreate', function(coords)
    CreateBlip(coords, 4, 1, 0.7)
    CreateBlip2(coords, "Zona de Acidente", 380, 1, 0.7)
    TriggerServerEvent('zcmg_zonaacidente:coords', coords)
    exports['zcmg_notificacao']:Alerta("POLICIA", "Zona de acidente criada!", 5000, 'sucesso')
end)

RegisterCommand(Config.ComandoAtivar, function(source, args, rawCommand)
    local autorizado = false
    local acesso = true

    if Config.Tempo then
        if args[1] == nil or tonumber(args[1]) < 1 then
            acesso = false
        end
    end

    if acesso then
        for i=1, #Config.Jobs, 1 do
            if ESX.PlayerData.job.name == Config.Jobs[i][1] then
                autorizado = true
            end
        end

        if autorizado then
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("zcmg_zonaacidente:blipcreate", args[1], coords)
        else
            exports['zcmg_notificacao']:Alerta("POLICIA", "Não tens permissões para realizar este comando", 5000, 'erro')
        end
    else
        exports['zcmg_notificacao']:Alerta("POLICIA", "Tem que definir o tempo", 5000, 'erro')
    end
end)

RegisterCommand(Config.ComandoDesativar, function(source, args, rawCommand)
    local autorizado = false

    for i=1, #Config.Jobs, 1 do
        if ESX.PlayerData.job.name == Config.Jobs[i][1] then
            autorizado = true
        end
    end
    
    if autorizado then
        TriggerServerEvent("zcmg_zonaacidente:blipremove")
    else
        exports['zcmg_notificacao']:Alerta("POLICIA", "Não tens permissões para realizar este comando", 5000, 'erro')
    end
end)

function CreateBlip(coords, sprite, color, scale)
	blip = AddBlipForCoord(table.unpack(coords))

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
end

function CreateBlip2(coords, text, sprite, color, scale)
	blip2 = AddBlipForCoord(table.unpack(coords))

	SetBlipSprite(blip2, sprite)
	SetBlipScale(blip2, scale)
	SetBlipColour(blip2, color)
	SetBlipAsShortRange(blip2, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip2)
end

AddEventHandler('onClientResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        TriggerEvent('chat:removeSuggestion', '/'..Config.ComandoAtivar)
        TriggerEvent('chat:removeSuggestion', '/'..Config.ComandoDesativar)
    end
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if Config.Tempo then
            TriggerEvent('chat:addSuggestion', '/'..Config.ComandoAtivar, 'Permite a policia ativar a zona de acidente.', {{ name="Tempo", help="Tempo que a zona fica activa (em minutos)" },})
        else
            TriggerEvent('chat:addSuggestion', '/'..Config.ComandoAtivar, 'Permite a policia ativar a zona de acidente', {})
        end
        TriggerEvent('chat:addSuggestion', '/'..Config.ComandoDesativar, 'Permite a policia deativar a zona de acidente', {})
    end
end)