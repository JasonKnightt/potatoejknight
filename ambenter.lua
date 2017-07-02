-- Get In Ambulance --

Citizen.CreateThread(function()
	if IsControlJustPressed(1, 58) then
	if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			TriggerEvent('GetInAmbulance')
		end
	end
end)


AddEventHandler('GetInAmbulance', function()
TriggerEvent('GetInAmbulance')
	local victim = GetPlayerPed(-1)
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local ambulance = getVehicleInDirection(coordA, coordB)
	
		if not IsPedInAnyVehicle(victim, true) then
			local ambulance = getVehicleInDirection(4.0)
			if GetEntityModel(ambulance) == GetHashKey("ambulance") then
				TaskEnterVehicle(victim, ambulance, 6, 2, 1.0, 2, 0)
			end
		end
end)


function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end


---- Created by Potatoe King Jason Knight ----
-- If you steal me, and use me...atleast abuse me and give me credit, fucker. --
