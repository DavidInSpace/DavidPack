--stylua "C:\Program Files (x86)\Steam\steamapps\common\The Binding of Isaac Rebirth\mods\DavidPack"
david_pack = RegisterMod("David Pack", 1)


-- Misc --
include("scripts.enums")
include("scripts.utils.utils")
include("scripts.utils.wait")
include("scripts.eid")

-- Dead Sea Scrolls --
include("scripts.dssmenucore")
david_pack.SaveManager = include("scripts.save_manager")
david_pack.SaveManager.Init(david_pack)
include("scripts.dss")
include("scripts.changelogs")
include("scripts.permission_manager")
include("scripts.commands")
include("scripts.item_transform_animations")
include("scripts.curses")


-- Collectibles --
include("scripts.items.collectibles.risk_of_gambling")
include("scripts.items.collectibles.coinflips.coinflips_script")
include("scripts.items.collectibles.coinflips.powerful_coinflip")
include("scripts.items.collectibles.coinflips.miserable_coinflip")
include("scripts.items.collectibles.coinflips.blessed_coinflip")
include("scripts.items.collectibles.coinflips.swift_coinflip")

include("scripts.items.collectibles.certificates.torn_death_certificate")
include("scripts.items.collectibles.certificates.rune_certificate")
include("scripts.items.collectibles.certificates.medical_certificate")

include("scripts.items.collectibles.mixed_emotions")

include("scripts.items.collectibles.prison.prison_jumpsuit")
include("scripts.items.collectibles.prison.dirty_prison_jumpsuit")
include("scripts.items.collectibles.prison.handcuffs")
include("scripts.items.collectibles.prison.leg_shackles")

include("scripts.items.collectibles.overcharged_battery")
include("scripts.items.collectibles.overcharged_baby")

include("scripts.items.collectibles.choco_waffles")

include("scripts.items.collectibles.kayos_nox")

include("scripts.items.collectibles.broken_monitor")
include("scripts.items.collectibles.blue_screen")
include("scripts.items.collectibles.bouncy_dvd_logo")

include("scripts.items.collectibles.overbent_spoon")
include("scripts.items.collectibles.glowing_hourglass_cookie")
include("scripts.items.collectibles.point_of_no_return")

include("scripts.items.collectibles.a_bit_of_chaos")

include("scripts.items.collectibles.davids_todo_list")

include("scripts.items.collectibles.creeper")

-- Trinkets --
include("scripts.items.trinkets.blindfold")
include("scripts.items.trinkets.active_worm")
--include("scripts.items.trinkets.orange_countdown")
--include("scripts.items.trinkets.pink_countdown")
include("scripts.items.trinkets.rgb_countdown")

-- Cards --
include("scripts.items.pickups.cards.expired_lottery_ticket")

-- Keys --
include("scripts.items.pickups.keys.handcuffs_key")

-- Transformations --
include("scripts.transformations.prisoner_transformation")
include("scripts.transformations.gambling_addict_transformation")

-- Challenges --
include("scripts.challenges.overgambled")

--[[

--->> TODO LIST <<---
- TODO: Maybe move the david pack settings to the repentagon ImGui menu which appear on the top bar when pressing console button
- [DONE] TODO: Make Kayos_Nox tears spectral to combat the issue of it targeting enemies that are behind obstacles
- TODO: Add costumes to all items that need one
- [DONE] TODO: Add special effects to the jumpsuit
- TODO: Add Prisoner Transformation Effect
- TODO: Make so enemies don't receive any knockback when Isaac has the prison jumpsuit
- [DONE] TODO: Add Gambling Addict Transformation Effect
- [1/2] TODO: Add icons to transformation progress for EID ^
- TODO: Make textures for unused items and trinkets and add functionality to them
- TODO: Add Overcharged Baby
- TODO: Make so there is a slightly higher chance to find broken modem when holding The Tower card so the odds of actually getting the broken monitor items aren't that small 
- TODO: Add Leg Shackles
- [DONE] TODO: Slightly increase the health of enemies and make them receive no knockback with the key effect
- TODO: Slightly increase the sprite size of enemies with the key effect
- [DONE] TODO: Add Handcuffs|
- TODO: Make so all stats up/down get removed when dropping rgb countdown trinket
- TODO: Make so super curses can not show up in challenges
- TODO: Add a toggle to DSS menu to toggle whether super curses can appear in challenges (Default: false)
- TODO: Make so all red hearts are always converted to rotten hearts when having dirty prison jumpsuit
- TODO: Add a costume for Handcuffs
- TODO: Add a costume for Leg Shackles
- TODO: Make so enemi
- [DONE] TODO: Fix rubber cement wisp not getting removed when switching with mixed emotions
- [DONE] TODO: Add Dr. Fetus, Epic Fetus, Technology, and TechX to Mixed Emotions
- [DONE] TODO: Add Torn certificate to item pools 
- [DONE] TODO: Give functinality to other certificates
- [DONE] TODO: Make so canMove can be chosen which directions it applies to
- TODO: Add logic to canBuy
- TODO: Add logic to the "Overgambled" challenge
- TODO: Add logic to canUnlockDoors
- TODO: Add logic to canInteractWithSlots
- TODO: Add more gambling related items that contribute to the gambling addict transformation
- [DONE] TODO: Add overcharged battery
- [DONE] TODO: Add EID to coinflips
- TODO: Make so bloody blindfold trinket can not be dropped in uncleared rooms or if dropped all isaacs familiars are removed for the room probably just make it so all familiars are removed because if it couldnt be dropped in uncleared rooms you could softlock
- TODO: Make so bloody blindfold can not be picked up by lilith or if the character is already blindfolded
- [DONE] TODO: Make so broken monitor saves the 2 picked up items across game restarts and removes them if the game becomes fullscreen
- [DONE] TODO: Finish Miserable Coinflip
- TODO: Combine all anm2 files with entity effect icons like choco waffles and keyed effect in to one and do the same for other icons like transformation icons
- TODO: Add potraits to all items (the ones you see on the death screen and on wisps I think)
- TODO: Add unlocks and achievements (Read Notes 1)
]]

--[[

---> Notes <---
Note 1: 
Add achievements and make so they appear to be a steam achievement by replicating
the look of a steam achievement popup and making it popup up in the corner with
the right sound

]]


--[[

--->> Ideas <<---


--> Characters <--
Variant: Normal
Name: Inmate
Appearnce: A little different to Isaac wearing (the look will be finished by the starting items)
Description:
- Starts with prison jumpsuit, handcuffs and leg shackles.
- Chance for enemies have the key effect from handcuffs is 20% higher (60%)
Notes: None
--> Characters <--


--> Collectibles <--
Name: Idk yet
Quality: Idk yet
Description:
- Isaac gets stats up the smaller the game window is
Notes: None

Name: Idk yet
Quality: Idk yet
Description:
- Isaac gets tears up depending on how loud game music volume setting is
- Isaac gets damage up depending on how loud game SFX volume setting is
- A voice randomly says up, right, down or left which means you
need to press the respective arrow direction 5 times within 5 seconds
- Not doing so will deal 1.5 hearts damage


--> Collectibles <--

--> Pickups <--



--> Pickups <--


--> Consumables <--

Name: SPR-INT
Description: 
- Grants +1 speed for 30 seconds

Name: Perithesene
Description:
- Full health (3 soul hearts if the chracter has no heart containers) 

--> Consumables <--


--> Enemies <--

Name: Pandemonium
Description:
- Every second while being in a cleared room there 
is a 1 in 30000 (30k) for the screen to flicker which means
pandemonium has spawned
- pandemonium will make a increasing in volume 
sound and will appear about 10 seconds after the 
flicker, going through the room Isaac is currently in
- A locker will appear in the room which Isaac will need to get in
if he doesn't want to get jumpscared by pandemonium
- Once in the locker and pandemonium is spawned a mini-game will start
where Isaac needs to hold his cursor in the circle which pandemonium will
try to prevent by kicking the cursor around the screen
This is a reference to pandemonium from pressure
Notes:
- Pandemonium music is not copy-righted I think
- Possibly also make a standalone mod that adds this

--> Enemies <--




Add SCP Related Items/Things

Add Backrooms Related Items/Things

Add a Planetarium Item





]]


--->> Useful things <<---
-- https://wofsauge.github.io/IsaacTools/charactersheet_generator.html
-- https://wofsauge.github.io/IsaacTools/deathscreen_generator.html