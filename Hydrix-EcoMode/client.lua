```javascript
// Load the QB-Core module
const qbcore = exports.qb-core;

// Function to play a specific engine sound for a vehicle
function playEngineSound(vehicle, soundName) {
  // Use the '_FORCE_VEHICLE_ENGINE_AUDIO' native provided by cfx docs
  const [_, isSuccessful] = Citizen.invokeNative('0x1F1F957154EC51DF', vehicle, soundName);
  return isSuccessful;
}

// Function to create a progress bar in the player's screen
function createProgressBar(message, time) {
  SendNUIMessage({
    type: 'progressBar',
    message,
    time,
  });
}

// Function to handle the keybind event
function handleEngineSoundChange() {
  const vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false);

  if (vehicle) {
    // Play the engine sound that was set by the user
    const isSuccessful = playEngineSound(vehicle, currentEngineSound);
    if (isSuccessful) {
      createProgressBar('Changing engine sound', 2500);
    }
  }
}

// Set the default engine sound to 'ENGINE_LOWRIDER'
let currentEngineSound = 'ENGINE_LOWRIDER';

// Register the 'k' keybind to change the engine sound
RegisterKeyMapping('k', 'Change Engine Sound', 'keyboard', 'k');
RegisterCommand('changesound', () => {
  // Create a menu to choose the new engine sound
  const menu = new Menu('Change Engine Sound', {
    'ENGINE_LOWRIDER': () => currentEngineSound = 'ENGINE_LOWRIDER',
    'ENGINE_GENERIC': () => currentEngineSound = 'ENGINE_GENERIC',
    'ENGINE_SUPERCAR': () => currentEngineSound = 'ENGINE_SUPERCAR',
    'ENGINE_SPORT': () => currentEngineSound = 'ENGINE_SPORT',
  });
  // Show the menu in the player's screen
  menu.show();
}, false);

// Register the keybind event handler
on('keydown', (keyCode) => {
  if (keyCode === 'k'.charCodeAt(0)) {
    handleEngineSoundChange();
  }
});