-- Camera Job ; Code Snippets from Xander1998

local camActive = false
local attachedVehicle = nil
local cameraHandle = nil

local screenEffect = "HeistLocate"


Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(PlayerPedId, true) and IsControlJustPressed(1, 26) then
			print("In Vehicle")
		elseif 
			EnableCamera()
			camActive = true
			HandleZoom(cam)
		end
		if camActive = true and IsControlJustPressed(1, 26) then
			DisableCamera()
			camActive = false
		end	
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



function EnableCamera()
        if CheckVehicleRestriction() then
            StartScreenEffect(screenEffect, -1, false)
            local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
            RenderScriptCams(1, 0, 0, 1, 1)
            SetFocusEntity(attachedVehicle)
            cameraHandle = cam
            SendNUIMessage({
                type = "enablecam"
            })
            dashcamActive = true
        end
    else
        StartScreenEffect(screenEffect, -1, false)
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        RenderScriptCams(1, 0, 0, 1, 1)
        SetFocusEntity(attachedVehicle)
        cameraHandle = cam
        SendNUIMessage({
            type = "enablecam"
        })
        dashcamActive = true
    end
end

function DisableCamera()
    StopScreenEffect(screenEffect)
    RenderScriptCams(0, 0, 1, 1, 1)
    DestroyCam(cameraHandle, false)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    SendNUIMessage({
        type = "disablecam"
    })
    dashcamActive = false
end



function UpdateCamera()
    local gameTime = GetGameTimer()
    local year, month, day, hour, minute, second = GetLocalTime()
    local unitNumber = GetPlayerServerId(PlayerId())
    local unitName = GetPlayerName(PlayerId())
    local unitSpeed = nil

    if DashcamConfig.useMPH then
        unitSpeed = GetEntitySpeed(attachedVehicle) * 2.23694
    else
        unitSpeed = GetEntitySpeed(attachedVehicle) * 3.6
    end

    SendNUIMessage({
        type = "updatecam",
        info = {
            gameTime = gameTime,
            clockTime = {year = year, month = month, day = day, hour = hour, minute = minute, second = second},
            unitNumber = unitNumber,
            unitName = unitName,
            unitSpeed = unitSpeed,
            useMPH = DashcamConfig.useMPH
        }
    })
end
