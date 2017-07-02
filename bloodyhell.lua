-- Possible Bandage? --

Citzen.CreateThread(function()
	while true do
		Wait(0)
		local myPed = GetPlayerPed(-1)

		if IsPedInjured(myPed) = true and IsControlJustPressed(1, 166) -- Native for the Michael Swap... who knows - POTATOE CODING LLC.
			then SetPlayerHealthRechargeMultiplier(myPed, 1.0)
			ShowNotification("~r~Bandage applied.")
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, false)
end
