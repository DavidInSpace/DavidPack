-- https://github.com/wofsauge/External-Item-Descriptions/wiki/Markup
-- https://docs.google.com/spreadsheets/d/1wmpPKldrU4aXYF7gIxwgLODOPeYvA_Z_Po5Yq-BIelA/edit?gid=0#gid=0


if EID then
	-- General --

	EID:setModIndicatorName("David Pack")
	local ModIcon = Sprite()

	ModIcon:Load("gfx/mod_icon.anm2", true)
	EID:addIcon("ModIcon", "ModIcon", -1, 5, 5, 6, 6, ModIcon)


	EID:setModIndicatorIcon("ModIcon")
	-- Append Descriptions --

	EID:AddSynergyConditional({david_pack.Collectible.OVERCHARGED_BABY}, CollectibleType.COLLECTIBLE_BFFS, "Time to trigger an effect is halved", "hellooooo")

	-- Icons --

	local handcuffsKeyIcon = Sprite()
	handcuffsKeyIcon:Load("gfx/icon_key_effect.anm2", true)
	EID:addIcon("HandcuffsKey", "Icon", -1, 9, 9, 4, 6, handcuffsKeyIcon)

	local handcuffsIcon = Sprite()
	handcuffsIcon:Load("gfx/handcuffs_indicator.anm2", true)
	EID:addIcon("Handcuffs", "LockedIcon", -1, 9, 9, 4, 6, handcuffsIcon)

	local unlockedHandcuffs = Sprite()
	unlockedHandcuffs:Load("gfx/handcuffs_indicator.anm2", true)
	EID:addIcon("UnlockedHandcuffs", "UnlockedIcon", -1, 9, 9, 4, 6, unlockedHandcuffs)



	-- Transformations --

	local GAMBLING_ADDICT_TRANSFORMATION_ID = "GamblingAddictTransformation"
	local gamblingAddictTransformationIcon = Sprite()


	gamblingAddictTransformationIcon:Load("gfx/gambling_addict_transformation_icon.anm2", true)
	EID:addIcon(GAMBLING_ADDICT_TRANSFORMATION_ID, "Idle", -1, 9, 9, 4, 6, gamblingAddictTransformationIcon)

	EID:createTransformation(GAMBLING_ADDICT_TRANSFORMATION_ID, "Gambling Addict")
	EID:assignTransformation("collectible", david_pack.Collectible.RISK_OF_GAMBLING, GAMBLING_ADDICT_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.POWERFUL_COINFLIP, GAMBLING_ADDICT_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.MISERABLE_COINFLIP, GAMBLING_ADDICT_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.BLESSED_COINFLIP, GAMBLING_ADDICT_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.SWIFT_COINFLIP, GAMBLING_ADDICT_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", CollectibleType.COLLECTIBLE_PORTABLE_SLOT, GAMBLING_ADDICT_TRANSFORMATION_ID)
	--EID.TransformationData["GamblingAddict"] = { NumNeeded = 3 } --3 default


	local PRISONER_TRANSFORMATION_ID = "PrisonerTransformation"
	EID:createTransformation(PRISONER_TRANSFORMATION_ID, "Prisoner Transformation")
	EID:assignTransformation("collectible", CollectibleType.COLLECTIBLE_BAR_OF_SOAP, PRISONER_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.PRISON_JUMPSUIT, PRISONER_TRANSFORMATION_ID)
	EID:assignTransformation("collectible", david_pack.Collectible.HANDCUFFS, PRISONER_TRANSFORMATION_ID)

	--  Collectibles --

	EID:addCollectible(
		david_pack.Collectible.PRISON_JUMPSUIT,
		"↓ 0.7x multiplier to all stats except shot speed#↑ +1.25 shot speed #{{EmptyHeart}} -1 Health#{{Warning}} Isaac is forced to put it on")

EID:addCollectible(
		david_pack.Collectible.DIRTY_PRISON_JUMPSUIT,
		"↓ 0.6x multiplier to all stats except shot speed#↑ +2 shot speed #{{EmptyHeart}} -2 Health#{{RottenHeart}} All red hearts turn in to roten hearts#{{Warning}} Isaac is forced to put it on")

	EID:addCollectible(
		david_pack.Collectible.HANDCUFFS,
		"{{HandcuffsKey}} Enemies have a 50% chance to spawn with the Key effect#{{Handcuffs}} If an enemy with the Key effect hurts isaac the handcuffs will lock#When handcuffs are locked Isaac can not do anything (except picking up hearts, story items, opening doors, moving and shooting)#{{UnlockedHandcuffs}} While the handcuffs are locked enemies with the keyed effect have a 10% chance to drop a handcuffs key which unlocks the handcuffs when picked up")

	EID:addCollectible(
		david_pack.Collectible.RISK_OF_GAMBLING,
		"Spawns a button in the starting room of each floor# Pressing the button spawns an {{Quality2}}, {{Quality3}} or {{Quality4}} item and increases the gambling risk by 1%#↓ Gambling risk is the chance of isaac loosing all his passive items (excluding this one and story items) and removing all item pedestals in the room#{{LuckSmall}} Gambling risk goes down by [1 + Luck Stat / 2] every floor")
	--EID:addCollectible(david_pack.Collectible.LOUIS, "{{Collectible" .. david_pack.Collectible.LOUIS .."}}#{{EmptyHeart}} 80% chance to instantly kill isaac#{{DeathMark}} 10% chance to instantly kill isaac and remove all completion marks from the current character{{Coin}} 9% Chance to drains all your coins#{{Quality4}} 1% chance to spawn 15 random quality 4 items or higher ")
	EID:addCollectible(
		david_pack.Collectible.TORN_DEATH_CERTIFICATE,
		"{{Warning}} SINGLE USE {{Warning}}#Teleports Isaac to a room with 12 random items #Pick 1 the rest disappears")

	EID:addCollectible(
		david_pack.Collectible.RUNE_CERTIFICATE,
		"{{Warning}} SINGLE USE {{Warning}}#Teleports Isaac to a room with every rune and soulstone in the vanilla game#Pick 1 the rest disappears#A random card will replace a rune if the rune has not been unlocked yet")

	EID:addCollectible(
		david_pack.Collectible.MEDICAL_CERTIFICATE,
		"{{Warning}} SINGLE USE {{Warning}}#Teleports Isaac to a room with 24 random horse pills#Pick 1 the rest disappears")

	EID:addCollectible(
		david_pack.Collectible.MIXED_EMOTIONS,
		"Allows Isaac to switch between 17 fixed item wisps#Wisps granted by this item are indestructible# Grants 4 {{Trinket139}} while held")

	EID:addCollectible(david_pack.Collectible.POWERFUL_COINFLIP,
		"On use has a 50/50 chance to grant Isaac a ↑ damage up or a ↓ damage down#Removes 1 charge per use#{{Warning}} The item gets destroyed if no charges are left#{{Warning}} Can not be recharged")

	EID:addCollectible(david_pack.Collectible.MISERABLE_COINFLIP,
		"On use has a 50/50 chance to grant Isaac a ↑ tears up or a ↓ tears down#Removes 1 charge per use#{{Warning}} The item gets destroyed if no charges are left#{{Warning}} Can not be recharged")

	EID:addCollectible(david_pack.Collectible.BLESSED_COINFLIP,
		"On use has a 50/50 chance to grant Isaac a ↑ luck up or a ↓ luck down#Removes 1 charge per use#{{Warning}} The item gets destroyed if no charges are left#{{Warning}} Can not be recharged")

	EID:addCollectible(david_pack.Collectible.SWIFT_COINFLIP,
		"On use has a 50/50 chance to grant Isaac a ↑ speed up or a ↓ speed down#Removes 1 charge per use#{{Warning}} The item gets destroyed if no charges are left#{{Warning}} Can not be recharged")

	EID:addCollectible(david_pack.Collectible.OVERCHARGED_BATTERY,
		"Allows isaac to overcharge his active item up to 4 times#A number appears near the active item which indicates how many overcharges isaac has#{{Warning}} Active item only gets overcharged when clearing rooms")

	EID:addCollectible(david_pack.Collectible.OVERCHARGED_BABY,
		"Allows isaac to overcharge his active item up to 4 times#A number appears near the active item which indicates how many overcharges isaac has#{{Warning}} Active item only gets overcharged when clearing rooms")

	EID:addCollectible(david_pack.Collectible.KAYOS_NOX,
		"#Spawns a fox familiar that automaticly shoots spectral tears at the nearest enemy dealing 2.5 damage#Tear rate scales with the amount of coins, bombs and keys Isaac has#When killing an enemy following things can drop:#{{IND}}{{Blank}} Nothing#{{IND}}{{IsaacSmall}} 25% Mini-Isaac#{{IND}}{{Pill2}} 15% Random Pill#{{IND}}{{Collectible}} 1% Random Item")

	EID:addCollectible(david_pack.Collectible.BROKEN_MONITOR,
		"{{Warning}} SINGLE USE {{Warning}}#Isaac is teleported to a room with 12 random quality {{Quality3}} or {{Quality4}} items and sets the game window to windowed mode#Isaac can choose 3 items#If the window gets fullscreened or resized the 3 chosen items will be removed")

	EID:addCollectible(david_pack.Collectible.BROKEN_MONITOR_PASSIVE,
		"{{Warning}} SINGLE USE {{Warning}}#Isaac is teleported to a room with 12 random quality {{Quality3}} or {{Quality4}} items and sets the game window to windowed mode# If the window gets fullscreened the 3 chosen items will be removed")

	EID:addCollectible(david_pack.Collectible.BLUE_SCREEN,
		"{{Warning}} Crashes the game#Can be used to roll back the game")

	EID:addCollectible(david_pack.Collectible.A_BIT_OF_CHAOS,
		"{{Trinket166}} Each room grants Isaac 2 random passive items from a random item pool")

	EID:addCollectible(david_pack.Collectible.OVERBENT_SPOON,
		"↑ +10 range#Grants homing tears#{{Collectible369}} Grants continuum effect#{{Warning}} Isaac looses the ability to shoot up or down")

	EID:addCollectible(david_pack.Collectible.POINT_OF_NO_RETURN,
		"A blackhole spawns at the door Isaac came out from Enemies# Isaac can not walk in the direction of the door he came out from")

	EID:addCollectible(david_pack.Collectible.GLOWING_HOURGLASS_COOKIE,
		"Isaacs movement and shooting directions are inverted#{{Slow}} Isaacs tears slow down enemies#{{Collectible232}} Applies stopwatch effect")

	EID:addCollectible(david_pack.Collectible.ACTIVE_MATTMAN,
		"Spawns a active mattman familiar#active mattman says mattman related phrases and sounds from time to time")

	EID:addCollectible(david_pack.Collectible.CREEPER,
		"#Spawns a creeper familiar that automaticly shoots ipecac like tears at the nearest enemy in sight dealing 10 damage#Tear rate scales with the amount of coins, bombs and keys Isaac has#Killing an enemy has a 15% chance to drop a bomb")


	-- Trinkets --

	EID:addTrinket(david_pack.Trinket.BLINDFOLD,
		"↓ Isaac can not shoot#↑ All Isaacs familiars are doubled#{{CurseDarknessSmall}} Can not be dropped if curse of darnkess is active") -- TODO: Add this trinket to google sheets

	EID:addTrinket(david_pack.Trinket.ACTIVE_WORM,
		"↑ +0.5 Shot Speed#↓ -0.5 Damage")


	-- Cards --

	EID:addCard(david_pack.Card.EXPIRED_LOTTERY_TICKET,
		"+1 {{" .. GAMBLING_ADDICT_TRANSFORMATION_ID .. "}} gambling addict transformation")

	local ExpiredLotteryTicketIcon = Sprite()
	ExpiredLotteryTicketIcon:Load("gfx/card_expired_lottery_ticket.anm2", true)
	EID:addIcon("Card" .. david_pack.Card.EXPIRED_LOTTERY_TICKET, "HUD", -1, 9, 9, 2, 5, ExpiredLotteryTicketIcon)

	-- Entities --
end



function david_pack:updateEID()
	if EID then
		EID:addCondition(CollectibleType.COLLECTIBLE_BATTERY, david_pack.Collectible.OVERCHARGED_BATTERY,
			"No Effect")
		EID:addCondition(david_pack.Collectible.OVERCHARGED_BATTERY, CollectibleType.COLLECTIBLE_JUMPER_CABLES,
			"No Effect")
	end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_ROOM_EXIT, david_pack.updateEID)
