---------------------------------------------------------------
-- Hand on Gun Holster


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


Citizen.CreateThread(function())

	local ped = GetPlayerPed(-1)

	while true do
		if Config.EnablePlayerManagement and PlayerData.job.grade_name == "officer" and IsControlPressed(1, 10) and DoesEntityExist(ped) and not IsEntityDead(ped) then -- Page Up
			loadAnimDict("move_m@intimidation@cop@unarmed")
			if IsEntityPlayingAnim(ped, "move_m@intimidation@cop@unarmed", "idle", 3) then
				ClearPedSecondaryTask(ped)
				SetEnableHandcuffs(ped, false)
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			else
				TaskPlayAnim(ped, "move_m@intimidation@cop@unarmed", "idle", 8.0, 2.5, -1, 49, 0, 0, 0, 0 )
				SetEnableHandcuffs(ped, true)
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			end
		end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "move_m@intimidation@cop@unarmed", "idle", 3) then
            DisableControlAction(0, 21, true)
			DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)