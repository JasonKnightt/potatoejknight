-- Modified First Responder Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if Config.EnablePlayerManagement and PlayerData.job.grade_name == "officer" or PlayerData.job.grade_name == "ems" or PlayerData.job.grade_name == "fire" and IsControlPressed(1, 27) then
                loadAnimDict ("random@arrests")
                if (IsEntityPlayingAnim(ped, "random@arrests", "radio_chatter", 3)) then
                    ClearPedSecondaryTask(ped)
                    SetEnableHandcuffs(ped, false)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                elseif
                    IsControlPressed(1, 25) and IsControlJustPressed(1, 27) then -- First is RMB (Aiming) second is Up Arrow "Input_Phone"
                    TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.5, -1, 49, 0, 0, 0, 0)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_PISTOL"), true)
                end
            end
        end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
            DisableControlAction(0, 21, true)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)
