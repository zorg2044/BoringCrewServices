# Installation instructions
- We strongly recommend installing via the CKAN mod manager for KSP. It will automatically handle all the dependencies. Set game compatibility to KSP v1.12.0 and later.

### [DOWNLOAD CKAN](https://forum.kerbalspaceprogram.com/topic/197082-ckan-the-comprehensive-kerbal-archive-network-v1332-laplace-ksp-2-support/)

Alternatively:
- Download Boring Crew Services from the github releases page or spacedock. BoringCrewServices folder goes into GameData.
### DO NOT CLONE THE MAIN BRANCH CODE. The plugin is only available in the release package: [Github Releases](https://github.com/zorg2044/BoringCrewServices/releases/)   
- Download and install all the dependencies listed below. Note some of them may have dependencies of their own.

# Dependencies:

- Module Manager: https://forum.kerbalspaceprogram.com/topic/50533-18x-112x-module-manager-423-july-03th-2023-fireworks-season/
- B9PartSwitch: https://github.com/blowfishpro/B9PartSwitch/releases
- KSPCommunityPartModules: https://github.com/KSPModdingLibs/KSPCommunityPartModules/releases
  - Harmony KSP (needed for KSPCPM): https://github.com/KSPModdingLibs/HarmonyKSP/releases
- Simple Adjustable Fairings: https://github.com/blowfishpro/SimpleAdjustableFairings/releases
- Waterfall: https://github.com/post-kerbin-mining-corporation/Waterfall/releases
- AnimatedDecouplers: https://github.com/Starwaster/AnimatedDecouplers/releases
- Resurfaced: PBR Texture Support. Some texture variants and built in decal functionality is only available with resurfaced. The IVA uses resurfaced materials by default and the models will not load without it. https://github.com/Tantares/Resurfaced/releases

# Recommendations:

- Bluedog Design Bureau: For Atlas V Rocket https://github.com/CobaltWolf/Bluedog-Design-Bureau/releases
- Habtech: US Orbital Segment International Space Station parts https://github.com/benjee10/HabTech2/releases
- Tantares: Russian Orbital Segment International Space Station parts https://github.com/Tantares/Tantares/releases
- Free IVA: Allows free 1st person traversal of internal spaces https://github.com/FirstPersonKSP/FreeIva/releases

# Created by
- Zorg - Models, textures, current lead.
- DylanSemrau - Models, textures, original creator.
- SofieBrink - Coding.

# Additional credits

- NDS Docking Port from Benjee10SharedAssets. Copyright Benedict Jewer, All Rights Reserved. Used with permission.
- Engine sounds from KW Rocketry by Kickasskyle and Winston, licensed CC-BY-NC-SA.

# Special thanks
- CashnipLeaf - Debugging critical aero issues.
- Rodger - Various debugging and config advice.
- EmberSkyMedia - Contributing various compatibility configs and custom staging icons art.
-

# Features
- 2.75m 5 crew capacity space capsule with built in inflatable airbags that can be automatically deployed near the ground.
- 2.75m Heat shield with low orbit and lunar return configurations.
- Jettisonable parachute bay cover with built in deployable nose cone.
- Alternate version of Jettisonable parachute bay cover without the nose cone. Will fit a 1.25m abort tower on top.
- Drogue parachutes that automatically cut when the main parachutes are deployed
- Main parachute with functional "bucket handle". The chutes deploy offset from the capsule initially and just like the real thing, the bucket handle swings up to center it at the end of full deployment.
- Hinged docking port cover.
- Central airbag that can be deployed automatically for emergency splashdown over water.
- 2.75m Service module with animated umbilical and radial nodes for thruster packs. Also features a toggle for the central solar panel (allows for custom fuel tanks or equipment to be inserted) and an extended length variant with more propellant such as for lunar use.
- Thruster doghouses in both layouts. Each thruster pack contains low power RCS thrusters and high power OMAC thrusters (orbital maneuvering and attitude control). RCS is used for attitude control and fine maneuvers like docking. OMACs are used for abort control authority and significant orbital maneuvers. Extra length variant available for use with extended service module.
- Standalone decoupler in 2.75 and 2.5m variants. Based on top of Service Module model.
- RS88 launch abort engines which also features a low thrust, high Isp orbital variant.
- Spacecraft adapter with built in shroud. Adapts to 1.875m upper stages. Designed to match the Atlas V N22 from Bluedog Design Bureau.
- Generic small multi adapter that adapts the 2.75m service module to 2.5m, 3.125m, 3.5m and 3.75m.
- Generic large multi adapter that adapts the 2.75m service module to 4.25m, 4.375m and 5m. Also supports a secondary payload inside if used with the matching secondary adapter base.
- 5x paint variants for the capsule, parachute bay cover and docking port cover:
  - Real world blue-grey blankets.
  - White blankets.
  - Restock like white paint.
  - Silver Orion-like (needs Resurfaced PBR mod).
  - Black tiles Orion EFT-1-like.
- Custom textures and support for native PBR (Physically Based Rendering) via the Resurfaced mod. Deferred rendering mod is recommended together with Resurfaced for best results.
- Custom conformal decal part with Boring Crew Services and Boeing decal sets.
- Built in toggleable decals on the capsule using a dedicated decal shader. Requires the Resurfaced mod.
- Craft files: Standalone starliner and together with BDB Atlas V.
- Support for Connected Living Spaces.
- Support for Engine Ignitor.
- Support for TAC Life Support (default configs should also work for Snacks! and Kerbalism).
- Support for VABOrganizer.
- Waterfall plumes for RCS and engines.
- 5 and 7 crew IVA internals with native PBR texture support and painstakingly recreated control panel.
- FreeIVA support including animated hatches.
- Calypso narwhal zero G indicator (as flown to the ISS by Suni Williams) with freeIVA physics support and squeaky sound fx!
- Support for interactive Raster Prop Monitor IVA. Requires ASET props and RPM. Reviva for IVA switching is also supported and reccomended if using this.

# License
This mod is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

Docking port and sounds licensed separately, please see additional credits above.
