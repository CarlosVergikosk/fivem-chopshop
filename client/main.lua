ESX = nil
local disablecontrols = false
local canchop = true
payout = math.random(10,35)
local cooldown = false
local jobstarted = false
local station = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

chopParts = {
	[1] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "wheel_lf",   PartLabel = "Pneu", 		PartProp = "prop_wheel_tyre", 	 PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0},
	[2] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "wheel_rf",   PartLabel = "Pneu", 		PartProp = "prop_wheel_tyre",	 PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0},
	[3] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "wheel_lr",   PartLabel = "Pneu", 		PartProp = "prop_wheel_tyre", 	 PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0},
	[4] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "wheel_rr",   PartLabel = "Pneu", 		PartProp = "prop_wheel_tyre", 	 PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0},
	[5] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "engine", 	   PartLabel = "Bateria", 	PartProp = "prop_car_battery_01",PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0},
	[6] = {chopPart = false, Partgone = false, Partdelivered = false, CarParts = "engine", 	   PartLabel = "Motor", 	PartProp = "prop_car_engine_01", PartBone = 28422, PartX = 0.0,PartY = 0.5,PartZ = -0.05,	PartxR = 0.0, PartyR = 0.0, PartzR = 0.0}
}

ChopCarLocation = {  --- Coords [x] = Door Coords [x2] =location if need be
	[1] = { Chop = vector3(-99.99, -99.99, 99.99), Sell = vector3(-99.99, -99.99, 99.99)}, -- CHOPCAR STATION
	[2] = { Chop = vector3(99.99, -99.99, 99.99), Sell = vector3(99.99, -99.99, 99.99)}, -- MECHANIC STATION
	[3] = { Chop = vector3(-99.99, -99.99, 99.99), Sell = vector3(-99.99, -99.99, 99.99)} -- CHOPCAR STATION
}

Citizen.CreateThread(function()
	while true do
		for i=1, #ChopCarLocation, 1 do
			local DistanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChopCarLocation[i].Chop, true)
			if DistanceCheck <= 10 then
				station = i
			end
			if station ~= nil and DistanceCheck >= 10 then
				station = nil
			end
		end
		if station ~= nil then
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), ChopCarLocation[station].Chop, true) >= 50 and jobstarted then 
				faraway()
			end
		end
		Citizen.Wait(1500)
	end
end)

Citizen.CreateThread(function()
	while true do
		if cooldown then
			canchop = false
			Citizen.Wait(2000) -- cooldown that must be applied 5 min cd
			canchop = true
			cooldown = false
		end 
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if disablecontrols then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 38, true) -- A
			DisableControlAction(0, 31, true) -- S (fault in Keys table!)
			DisableControlAction(0, 30, true) -- D (fault in Keys table!)

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(10)
		if station ~= nil and jobstarted then
			if veh == nil or veh == 0 then
				veh = GetClosestVehicle(ChopCarLocation[station].Chop, 5.0, 0, 70)
			end
			for i=1, #chopParts, 1 do
				if canchop and jobstarted and not chopParts[i].Partgone and not chopParts[i].Partdelivered then
					while not chopParts[i].chopPart do
						local x,y,z = table.unpack(GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, chopParts[i].CarParts)))
						Citizen.Wait(10)
						DrawMarker(27,x,y,z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
						if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), x,y,z, true ) < 2.5 and IsPedStill(GetPlayerPed(-1)) and not chopParts[i].chopPart then --1.2
							DrawText3Ds(x,y,z, tostring("~w~~g~[E]~w~ " .. chopParts[i].PartLabel))
							if(IsControlJustPressed(1, 38)) then
								disablecontrols = true
								chopParts[i].chopPart = true
								chopParts(i)
							end
						end
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(10)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			if canchop and not jobstarted and station ~= nil then 
				DrawMarker(20,ChopCarLocation[station].Chop, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ChopCarLocation[station].Chop, true ) < 1.2 then 
					local x,y,z = table.unpack(ChopCarLocation[station].Chop)
					DrawText3Ds(x,y,z, "~w~~g~[E]~w~ Remover")
					if(IsControlJustPressed(0, 38)) then
						if not cooldown then
							StartChopping()
							Citizen.Wait(1000)
							cooldown = true
						end
						if cooldown and not jobstarted then
							exports['mythic_notify']:SendAlert('error', 'Não podes desmontar outro carro, tens de esperar um pouco.')
						end
					end
				end
			end
	  	else
			Citizen.Wait(500)
		end
	end
end)

function chopParts(i)
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	veh = GetClosestVehicle(ChopCarLocation[station].Chop, 4.001, 0, 70)
	if chopParts[i].chopPart then
		SetVehicleDoorOpen(veh, 0, false, false)
		TaskStartScenarioInPlace(plyPed, "WORLD_HUMAN_WELDING", 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "unique_action_name",
			duration = 90000,
			label = "Removendo ".. chopParts[i].PartLabel .. "...",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}
			}, function(status)
			if not status then
				--SetVehicleDoorBroken(veh, 0, true)
				ClearPedTasksImmediately(plyPed)
				chopParts[i].chopPart = false
				chopParts[i].Partgone = true
				disablecontrols = false
				local PackageObject = CreateObject(GetHashKey(chopParts[i].PartProp), 1.0, 1.0, 1.0, 1, 1, 0)
				--SetEntityCollision(PackageObject, false, false)
				--PlaceObjectOnGroundProperly(PackageObject)
				Citizen.Wait(1000)
				CarryingPart(PackageObject, i)
			end
		end)
	end
end

function EndJob()
	TriggerServerEvent('inrp_scrap:success', math.random(30,80))
	local vehchopping = GetClosestVehicle(ChopCarLocation[station].Chop, 4.001, 0, 70)
	jobstarted = false
	DeleteEntity(vehchopping)
	exports['mythic_notify']:SendAlert('success', 'Todo o veículo foi Desmantelado com sucesso')
	for i=1, #chopParts, 1 do
		chopParts[i].chopPart = false
		chopParts[i].Partgone = false
		chopParts[i].Partdelivered = false
	end
	veh = nil

end

function faraway()
	local vehchopping = GetClosestVehicle(ChopCarLocation[station].Chop, 4.001, 0, 70)
	jobstarted = false
	station = nil
	DeleteEntity(vehchopping)
	exports['mythic_notify']:SendAlert('error', 'Afaste-se daqui!')
end

function StartChopping()
	local ped = GetPlayerPed(-1)
	local veh2 = GetVehiclePedIsIn (GetPlayerPed (-1), true)
	local vehiclePedIsIn = GetVehiclePedIsIn(ped, false)
	SetEntityCoords(veh2, ChopCarLocation[station].Chop)
	SetEntityHeading(veh2, 27.77)
	SetVehicleDoorOpen(veh2, 0, false, true)
	SetVehicleDoorOpen(veh2, 1, false, true)
	SetVehicleDoorOpen(veh2, 2, false, true)
	SetVehicleDoorOpen(veh2, 3, false, true)
	SetVehicleDoorOpen(veh2, 4, false, true)
	SetVehicleDoorOpen(veh2, 5, false, true)
	TaskLeaveVehicle(ped, vehiclePedIsIn, 256)
	SetVehicleDoorsLocked(veh2, 2)
	Citizen.Wait(1000)
	jobstarted = true
end

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    local scale = 0.30

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function CarryingPart(partID, i)
	if DoesEntityExist(partID) then
		loadAnimDict("anim@heists@box_carry@")
		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
			ClearPedTasks(PlayerPedId())
			loadAnimDict("anim@heists@box_carry@")
			TaskPlayAnim((GetPlayerPed(-1)),"anim@heists@box_carry@","idle",4.0, 1.0, -1,49,0, 0, 0, 0)
			AttachEntityToEntity(partID, GetPlayerPed(-1), chopParts[i].PartBone, chopParts[i].PartX, chopParts[i].PartY, chopParts[i].PartZ, chopParts[i].PartxR, chopParts[i].PartYR, chopParts[i].PartZR, 1, 1, 0, true, 2, 1)
		end
	else
		return
	end
	local Packaging = true
	while Packaging do
		Citizen.Wait(10)
		if not IsEntityAttachedToEntity(partID, PlayerPedId()) then
			Packaging = false
			DeleteEntity(partID)
		else
			local PedPosition = GetEntityCoords(PlayerPedId())
			local DistanceCheck = GetDistanceBetweenCoords(PedPosition, ChopCarLocation[station].Sell, true)
			local x,y,z = table.unpack(ChopCarLocation[station].Sell)
			DrawText3Ds(x,y,z, tostring("~w~~g~[E]~w~ Vender Peças"))
			if DistanceCheck <= 2.0 then
				if IsControlJustPressed(0, 38) then
					disablecontrols = true
					DeleteEntity(partID)
					ClearPedTasksImmediately(PlayerPedId())
					Packaging = false
					if chopParts[i].Partgone then
						TriggerServerEvent('inrp_scrap:success', payout)
						chopParts[i].Partgone = false
						chopParts[i].Partdelivered = true
						disablecontrols = false
						exports['mythic_notify']:SendAlert('success', 'A peça foi vendida com sucesso!')
						if chopParts[#chopParts].Partdelivered then
							EndJob()
						end
					end
				end
			end
		end
	end
end

Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end) -- Prevents RAM LEAKS :)
