
local robbedEntities = {}
AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
	CurrentWeapon = currentWeapon
end)

RegisterNetEvent('ultrax:npc:rob', function(entity, distance,coords,name,bone)
	local targetPed = entity.entity


	
	for i=1, #robbedEntities do
		if robbedEntities[i] == targetPed then
			return
		end
	end


	ESX.TriggerServerCallback('ultrax:engine:checkPlayersWithJob', function(count)
		if count >= Ultrax.Robbing.minPd then
			local robTime = Ultrax.Robbing.RobTime * 1000
			TaskCombatPed(targetPed, PlayerPedId(),0, 16)
			if IsPedArmed(PlayerPedId(), 7) and IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 1) then
				TaskStandStill(targetPed, robTime)
		
		
		
				loadDict('random@mugging3')
		
				FreezeEntityPosition(targetPed, true)
				TaskPlayAnim(targetPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
				alert()
				if lib.progressBar({
					duration = robTime,
					label = 'Okradanie przechodnia...',
					useWhileDead = false,
					canCancel = true,
				}) then pedRobbed(targetPed) else actionAborted(targetPed) end
			else
				--TaskSmartFleePed(targetPed, PlayerPedId(), 150.0, -1, true, true)
				ESX.ShowNotification("Nie stwarzasz żadnego zagrożenia!", 4000, 'error')
			end
		else
			ESX.ShowNotification("Brak wystarczającej liczby funkcjonariuszy policji na służbie!", 4000, 'error')
		end
	end,'police')
end)


pedRobbed = function(tped)
	robbedEntities[#robbedEntities+1] = tped

	ClearPedTasks(tped)
	loadDict('mp_common')
	TaskPlayAnim(tped, 'mp_common', 'givetake1_a', 8.0, -8, .01, 49, 0, 0, 0, 0)
	TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, -8, .01, 49, 0, 0, 0, 0)
	Wait(2300)
	ClearPedTasks(PlayerPedId())
	ClearPedTasks(tped)
	FreezeEntityPosition(tped, false)
	TaskSmartFleePed(tped, PlayerPedId(), 150.0, -1, true, true)
	TriggerServerEvent('ultrax:npc:robbed')

end





RegisterNetEvent('ultrax:npc:takeHost', function(entity)
	local targetPed = entity.entity
	local takeHostTime = Ultrax.Hostage.takeTime * 1000
	if DoesEntityExist(targetPed) then
		if IsPedArmed(PlayerPedId(), 7) and IsPedArmed(PlayerPedId(), 4) or IsPedArmed(PlayerPedId(), 1) then
			TaskStandStill(targetPed, takeHostTime)
			if lib.progressBar({
				duration = takeHostTime,
				label = 'Branie zakładnika...',
				useWhileDead = false,
				canCancel = true,
			}) then takeHost(targetPed) else actionAborted(targetPed) end
		else
			ESX.ShowNotification("Nie stwarzasz zadnego zagrozenia...", 4000, 'error')
		end

	end
end)



alert = function()
	local job = "police" -- Jobs that will recive the alert
	local text = "Podejrzany napada ofiarę z bronią" -- Main text alert
	local coords = GetEntityCoords(PlayerPedId()) -- Alert coords
	local id = GetPlayerServerId(PlayerId()) -- Player that triggered the alert
	local title = "NAPAŚĆ" -- Main title alert
	local panic = false -- Allow/Disable panic effect
   
	TriggerServerEvent('Opto_dispatch:Server:SendAlert', job, title, text, coords, panic, id)
end

takeHost = function(tped)
	hostage = tped
	loadDict(Ultrax.Hostage.Anims.Aggressor.dict)
	AttachEntityToEntity(tped, PlayerPedId(), 0, Ultrax.Hostage.Anims.Victim.attachX, Ultrax.Hostage.Anims.Victim.attachY, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
	TaskPlayAnim(PlayerPedId(), Ultrax.Hostage.Anims.Aggressor.dict, Ultrax.Hostage.Anims.Aggressor.anim, 8.0, -8, .01, 49, 0, 0, 0, 0)
	TaskPlayAnim(tped, Ultrax.Hostage.Anims.Aggressor.dict, Ultrax.Hostage.Anims.Victim.anim, 8.0, -8, .01, 49, 0, 0, 0, 0)
	TaskStandStill(tped, -1)
	textUi("[G] - Puść zakładnika wolno | [H] - Zabij zakładnika")
	enableBinds = true
	bindLoop()
end

RegisterCommand('detcz', function()
	DetachEntity(PlayerPedId(), true, true)
	DetachEntity(hostage)
	ClearPedTasks(hostage)
	ClearPedTasks(PlayerPedId())
	print('puszczony')
	hostage = nil
	textUi()
end)

bindLoop = function()
	while enableBinds do
		Wait(5)
		disableBtns()
		if IsDisabledControlJustPressed(0,47) then
			releaseHostage()
			enableBinds = false
		elseif IsDisabledControlJustPressed(0,74) then
			killHostage()
			enableBinds = false
		end
	end
end

releaseHostage = function()
	DetachEntity(PlayerPedId(), true, true)
	DetachEntity(hostage)
	ClearPedTasks(hostage)
	ClearPedTasks(PlayerPedId())
	print('puszczony')
	hostage = nil
	textUi()
end


RegisterCommand('xxef', function()
	loadDict("anim@gangops@hostage@")
	TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "perp_fail", 8.0, -8.0, -1, 168, 0, false, false, false)

end)
killHostage = function()
	loadDict("anim@gangops@hostage@")
	ClearPedTasks(PlayerPedId())
	TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "perp_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
	textUi()
	Wait(750)
	SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, 0)
	DetachEntity(PlayerPedId(), true, true)
	DetachEntity(hostage)
	SetEntityHealth(hostage, 0)
	hostage = nil
end



disableBtns = function()
	print('bind off')
	DisableControlAction(0,24,true)
	DisableControlAction(0,25,true)
	DisableControlAction(0,47,true)
	DisableControlAction(0,58,true)
	DisableControlAction(0,21,true)
	DisablePlayerFiring(PlayerPedId(),true)
end



actionAborted = function(tped)
	FreezeEntityPosition(tped, false)
	ClearPedTasks(tped)
	TaskSmartFleePed(tped, PlayerPedId(), 150.0, -1, true, true)
	ESX.ShowNotification('Przestałeś celować, ofiara zaczęła uciekać!', 4000, 'error')
end


loadDict = function(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

textUi = function(text)
	if text ~= nil then
		lib.showTextUI(text, {
			position = "top-center",
			icon = 'fas fa-male',
			style = {
				borderRadius = 10,
				backgroundColor = 'rgba(20,20,20, 0.75)',
				color = 'white'
			}
		})
	else
		lib.hideTextUI()
	end
end