# pico8-beach-bird-panic

## IntelliJ IDEA + Lua + PICO-8 setup

1. Install the **EmmyLua2** plugin in IntelliJ IDEA.
2. Download `pico8.lua` from https://github.com/peabnuts123/pico8-emmylua-definitions/blob/master/pico8.lua
3. Create a `_pico8` folder at the root of this project if it does not already exist.
4. Place `pico8.lua` inside `_pico8/` so IntelliJ can use the PICO-8 definitions for Lua completion and navigation.

The `_pico8/` folder is already gitignored, so the downloaded definitions stay local to your machine.

## Run configurations

### Prerequisites

Add the PICO-8 install directory to your path so IntelliJ run configurations can launch it.

- **Windows:** add the PICO-8 directory to your system `PATH` environment variable.
- **Linux:** add the PICO-8 directory to the `PATH` environment variable in the IntelliJ run configuration.

### Run
```pico8 -run ./beach_bird_panic.p8```
For linux might need to use the following:
```pico8_dyn -run ./beach_bird_panic.p8```

### Export
```pico8 ./beach_bird_panic.p8 -export beachbirdpanic.p8.png```
For linux might need to use the following:
```pico8_dyn ./beach_bird_panic.p8 -export beachbirdpanic.p8.png```

### Deploy
```./deploy.sh```

This script will export the game and deploy it to Miyoo Mini Plus pico8 cart directory using sftp. The Miyoo Mini Plus must be on the same WIFI network and host must be updated with the ip address of the device.


