-- News Reporter Job

--  To Do List :
--  Get Spawn Job Start & Vehicle Spawn
--  Create Alert System
--  Create Camera Screen


-- Job Start & Vehicle Spawn

Player.Notification = function(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 1)
end

-- rumpo = 0x4543B74D -- 1162065741, 1162065741 -- (Weazel News Rumpo)
newsReporter = false
	
function getJob()
	local Ped = GetPlayerPed(-1)
	local pedLoc = GetEntityCoords(Ped, true)
	local inVeh = IsPedInAnyVehicle(Ped, false)
	local newsVan = GetHashKey("rumpo")
	local vanSpawn = {x = -562.104, y = -894.062, z = 24.72}
	local pedHead = GetEntityHeading(Ped)

		if inVeh then
			Player.Notification(tostring("You're in a vehicle."))
		elseif GetDistanceBetweenCoords(-592.027, -911.24, 23.88 - 1, pedLoc)) < 10 then
			DrawMarker(1, -592.027, -911.24, 23.88 - 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 165, 0, 165, 0, 0, 0, 0, 0, 0) --- The News Office
			if GetDistanceBetweenCoords(-592.027, -911.24, 23.88 - 1, pedLoc)) < 2 then
				Player.Notification(tostring("Press ~E~ to accept job then locate your van!")) -- Change this to fancy pop up w/ picture.
				newsReporter = true
				if IsControlJustPressed(inputGroup, control) then -- Make this E.
					DrawMarker(1, -562.104, -894.062, 24.72 - 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 165, 0, 0, 0, 0, 0, 0, 0, 0, 0) --- News Vehicle Spawn
					CreateVehicle(newsVan, vanSpawn.x, vanSpawn.y, vanSpawn.z, pedHead, true, false)
					SetVehicleOnGroundProperly(newsVan)
					SetVehicleLivery(newsVan, 1162065741)
					SetEntityAsMissionEntity(newsVan)
				end
			end
		end
end)


---------------------
-- Camera Man View --
---------------------

-- Goal : Use Heli Script from mraes to do /camera and change to first person with camera man style view.


-- Configuration Details

local fov_max = 80.0
local fov_min = 10.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 2.0 -- camera zoom speed
local speed_lr = 3.0 -- speed by which the camera pans left-right 
local speed_ud = 3.0 -- speed by which the camera pans up-down
-- local toggle_reportercam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
-- local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G) -- Removed for now, may be able to add it as a "reporter light"


-- Script Starts Here
RegisterCommand("camera", function(source, args, rawCommand))
	if newsReporter = true then
		TriggerEvent('cameraman')
	end
end)


local fov = (fov_max+fov_min)*0.5

AddEventHandler('cameraman', function())
TriggerEvent('cameraman')
	if newsReporter = true then
		SetTimecycleModifier("heliGunCam")
		SetTimecycleModifierStrength(0.3)
			
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()

			HandleZoom(cam)
			HideHUDThisFrame()
			PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
			PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
			PushScaleformMovieFunctionParameterFloat(zoomvalue)
			PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
			PopScaleformMovieFunctionVoid()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Citizen.Wait(0)

			end
			
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
	end
end)


function HandleZoom(cam)
	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

-- Not Sure If Needed

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end



-- Outlaw Notification Stuff

local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = true --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 2 --in second
local blipMeleeTime = 2 --in second
local blipJackingTime = 10 -- in second
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche it


GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
   if newsReporter = true  then
            Notify(alert)
   end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(tx, ty, tz)
    if newsReporter = true then
            if carJackingAlert then
                local transT = 250
                local thiefBlip = AddBlipForCoord(tx, ty, tz)
                SetBlipSprite(thiefBlip,  10)
                SetBlipColour(thiefBlip,  1)
                SetBlipAlpha(thiefBlip,  transT)
                SetBlipAsShortRange(thiefBlip,  1)
                while transT ~= 0 do
                    Wait(blipJackingTime * 4)
                    transT = transT - 1
                    SetBlipAlpha(thiefBlip,  transT)
                    if transT == 0 then
                        SetBlipSprite(thiefBlip,  2)
                        return end
                end
                
            end
        end
    end
end)

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
    if newsReporter = true then
            if gunshotAlert then
                local transG = 250
                local gunshotBlip = AddBlipForCoord(gx, gy, gz)
                SetBlipSprite(gunshotBlip,  1)
                SetBlipColour(gunshotBlip,  1)
                SetBlipAlpha(gunshotBlip,  transG)
                SetBlipAsShortRange(gunshotBlip,  1)
                while transG ~= 0 do
                    Wait(blipGunTime * 4)
                    transG = transG - 1
                    SetBlipAlpha(gunshotBlip,  transG)
                    if transG == 0 then
                        SetBlipSprite(gunshotBlip,  2)
                        return end
                end
               
            end
        end
    end
end)

RegisterNetEvent('meleePlace')
AddEventHandler('meleePlace', function(mx, my, mz)
   if newsReporter = true then
            if meleeAlert then
                local transM = 250
                local meleeBlip = AddBlipForCoord(mx, my, mz)
                SetBlipSprite(meleeBlip,  270)
                SetBlipColour(meleeBlip,  17)
                SetBlipAlpha(meleeBlip,  transG)
                SetBlipAsShortRange(meleeBlip,  1)
                while transM ~= 0 do
                    Wait(blipMeleeTime * 4)
                    transM = transM - 1
                    SetBlipAlpha(meleeBlip,  transM)
                    if transM == 0 then
                        SetBlipSprite(meleeBlip,  2)
                        return end
                end
                
            end
        end
    end
end)

--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue]]

Citizen.CreateThread( function()
    while true do
        Wait(0)
        if showOutlaw then
            for i = 0, 31 do
                if DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 2 and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                    gamerTagId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(i), ".", false, false, "", 0 )
                    Citizen.InvokeNative(0xCF228E2AA03099C3, gamerTagId, 0) --Show a star
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, true) --Active gamerTagId
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 1) --White star
                elseif DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 1 then
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 255) -- Set Color to 255
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, false) --Unactive gamerTagId
                end
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(0)
        if DecorGetInt(GetPlayerPed(-1), "IsOutlaw") == 2 then
            Wait( math.ceil(timing) )
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(0)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
            local male = IsPedMale(GetPlayerPed(-1))
            if male then
                sex = "men"
            elseif not male then
                sex = "women"
            end
            TriggerServerEvent('thiefInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
            local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            local vehName2 = GetLabelText(vehName)
            if s2 == 0 then
                TriggerServerEvent('thiefInProgressS1', street1, vehName2, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent('thiefInProgress', street1, street2, vehName2, sex)
            end
            Wait(5000)
            origin = false
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(0)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedInMeleeCombat(GetPlayerPed(-1)) then 
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
            local male = IsPedMale(GetPlayerPed(-1))
            if male then
                sex = "men"
            elseif not male then
                sex = "women"
            end
            TriggerServerEvent('meleeInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            if s2 == 0 then
                TriggerServerEvent('meleeInProgressS1', street1, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent("meleeInProgress", street1, street2, sex)
            end
            Wait(3000)
            origin = false
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Wait(0)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedShooting(GetPlayerPed(-1)) then
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
            local male = IsPedMale(GetPlayerPed(-1))
            if male then
                sex = "men"
            elseif not male then
                sex = "women"
            end
            TriggerServerEvent('gunshotInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            if s2 == 0 then
                TriggerServerEvent('gunshotInProgressS1', street1, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent("gunshotInProgress", street1, street2, sex)
            end
            Wait(3000)
            origin = false
        end
    end
end)