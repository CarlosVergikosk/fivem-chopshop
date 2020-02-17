ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('b1g_chopshop:success')
AddEventHandler('b1g_chopshop:success', function(pay)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(pay)
end)
