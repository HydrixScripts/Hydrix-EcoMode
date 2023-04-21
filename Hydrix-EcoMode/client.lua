-- Load the QB-Core module
local qbcore = exports["qb-core"]

-- Event handler for when the server requests the engine sound to be changed
local function onChangeSound(soundName)
  -- Play the new engine sound
  TriggerEvent("qb-enginesound:playEngineSound", soundName)
end

-- Function to handle the engine sound menu
function handleEngineSoundMenu()
  -- Show the menu to choose the new engine sound
  qbcore:OpenMenu("default", function(data)
    local soundName = data.current.value
    -- Send the request to the server to change the engine sound
    TriggerServerEvent("qb-enginesound:changeSound", soundName)
    createProgressBar("Changing engine sound", 2500)
  end, { header = "Change Engine Sound", align = "bottom-right", elements = {
    { label = "Engine Lowrider", value = "ENGINE_LOWRIDER" },
    { label = "Engine Generic", value = "ENGINE_GENERIC" },
    { label = "Engine Supercar", value = "ENGINE_SUPERCAR" },
    { label = "Engine Sport", value = "ENGINE_SPORT" },
  }})
end

-- Register the 'k' keybind to show the engine sound menu
RegisterKeyMapping("k", "Change Engine Sound", "keyboard", "k")
RegisterCommand("changesound", function()
  handleEngineSoundMenu()
end, false)

-- Play the specified engine sound for a vehicle
AddEventHandler("qb-enginesound:playEngineSound", function(soundName)
  -- Use the '_FORCE_VEHICLE_ENGINE_AUDIO' native provided by cfx docs
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if DoesEntityExist(vehicle) then
    Citizen.InvokeNative("0x1F1F957154EC51DF", vehicle, soundName)
  end
end)

-- Event handler for when the player enters a vehicle
AddEventHandler("playerEnteredVehicle", function(vehicle)
  -- Get the current engine sound for the vehicle
  local soundName = GetVehicleMod(vehicle, 11)
  -- Play the current engine sound
  TriggerEvent("qb-enginesound:playEngineSound", soundName)
end)
