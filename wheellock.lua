local ped = GetPlayerPed(-1)
local vehicle = GetVehiclePedIsIn(ped, true)

Citizen.CreateThread(function())
	while true do
		if IsControlJustPressed(25, 108) then -- Numpad 5 Toggle On / Off
			if IsPedInAnyVehicle(ped, false) and GetIsVehicleEngineRunning(vehicle) then 
				SetVehicleSteerBias(vehicle, 36.0)
			end
		end
	end
end)
