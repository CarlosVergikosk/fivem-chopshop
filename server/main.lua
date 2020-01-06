ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('inrp_scrap:success')
AddEventHandler('inrp_scrap:success', function(pay)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(pay)
end)
