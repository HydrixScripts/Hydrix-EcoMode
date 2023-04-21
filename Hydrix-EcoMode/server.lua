-- Load the QB-Core module
local qbcore = exports["qb-core"]

-- Define the available engine sounds
local engineSounds = {
  ["ENGINE_LOWRIDER"] = true,
  ["ENGINE_GENERIC"] = true,
  ["ENGINE_SUPERCAR"] = true,
  ["ENGINE_SPORT"] = true,
}

-- Function to play a specific engine sound for a vehicle
function playEngineSound(vehicle, soundName)
  -- Use the '_FORCE_VEHICLE_ENGINE_AUDIO' native provided by cfx docs
  local isSuccessful = Citizen.invokeNative("0x1F1F957154EC51DF", vehicle, soundName)
  return isSuccessful
end

-- Function to handle the change sound request
local changeSoundFunction = Instance.new("RemoteFunction")
changeSoundFunction.Name = "ChangeSound"
changeSoundFunction.OnServerInvoke = function(player, soundName)
  if engineSounds[soundName] then
    local vehicle = player.Character and player.Character:FindFirstChildOfClass("Vehicle")
    if vehicle then
      -- Play the engine sound that was set by the user
      local isSuccessful = playEngineSound(vehicle, soundName)
      if isSuccessful then
        return true
      end
    end
  end
  return false
end
changeSoundFunction.Parent = game:GetService("ReplicatedStorage")

-- Function to handle the keybind event
function handleEngineSoundChange(source, args, rawCommand)
  -- Get the player who triggered the event
  local player = source

  local vehicle = player.Character and player.Character:FindFirstChildOfClass("Vehicle")
  if vehicle then
    -- Show the menu to choose the new engine sound
    qbcore:OpenMenu("default", function(data)
      local soundName = data.current.value
      -- Send the request to the server to change the engine sound
      local isSuccessful = changeSoundFunction:InvokeClient(player, soundName)
      if isSuccessful then
        createProgressBar(player, "Changing engine sound", 2500)
      end
    end, { header = "Change Engine Sound", align = "bottom-right", elements = {
      { label = "Engine Lowrider", value = "ENGINE_LOWRIDER" },
      { label = "Engine Generic", value = "ENGINE_GENERIC" },
      { label = "Engine Supercar", value = "ENGINE_SUPERCAR" },
      { label = "Engine Sport", value = "ENGINE_SPORT" },
    }})
  end
end

-- Register the 'k' keybind to change the engine sound
RegisterCommand("k", function(source, args, rawCommand)
  handleEngineSoundChange(source, args, rawCommand)
end, false)
