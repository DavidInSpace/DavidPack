local game = Game()
local sfx = SFXManager()
--local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)

david_pack.Tear = {
	--X = Isaac.GetEntityVariantByName("x"),

	CHOCO_WAFFLES_TEAR = Isaac.GetEntityVariantByName("Choco Waffles Tear")
}

david_pack.Familiar = {
	--X = Isaac.GetEntityVariantByName("x"),
	OVERCHARGED_BABY = Isaac.GetEntityVariantByName("Overcharged Baby Familiar"),
	KAYOS_NOX = Isaac.GetEntityVariantByName("Kayos_Nox Familiar"),
	CREEPER = Isaac.GetEntityVariantByName("Creeper Familiar")
}

---@enum
david_pack.Collectible = {
	--X = Isaac.GetItemIdByName("x"),

	-- Prisoner Transformation --
	PRISON_JUMPSUIT = Isaac.GetItemIdByName("Prison Jumpsuit"),
	DIRTY_PRISON_JUMPSUIT = Isaac.GetItemIdByName("Dirty Prison Jumpsuit"),
	HANDCUFFS = Isaac.GetItemIdByName("Handcuffs"),
	LEG_SHACKLES = Isaac.GetItemIdByName("Leg Shackles"),

	-- Gambling Addict Transformation --
	RISK_OF_GAMBLING = Isaac.GetItemIdByName("Risk Of Gambling"),
	POWERFUL_COINFLIP = Isaac.GetItemIdByName("Powerful Coinflip"),
	MISERABLE_COINFLIP = Isaac.GetItemIdByName("Miserable Coinflip"),
	BLESSED_COINFLIP = Isaac.GetItemIdByName("Blessed Coinflip"),
	SWIFT_COINFLIP = Isaac.GetItemIdByName("Swift Coinflip"),
	
	-- Certificates --
	TORN_DEATH_CERTIFICATE = Isaac.GetItemIdByName("Torn Death Certificate"),
	RUNE_CERTIFICATE = Isaac.GetItemIdByName("Rune Certificate"),
	MEDICAL_CERTIFICATE = Isaac.GetItemIdByName("Medical Certificate"),

	MIXED_EMOTIONS = Isaac.GetItemIdByName("Mixed Emotions"),

	OVERCHARGED_BATTERY = Isaac.GetItemIdByName("The Overcharged Battery"),
	OVERCHARGED_BABY = Isaac.GetItemIdByName("Overcharged Baby"),

	KAYOS_NOX = Isaac.GetItemIdByName("Kayos_Nox"),

	CHOCO_WAFFLES = Isaac.GetItemIdByName("Chocolate Waffles"),

	BROKEN_MONITOR = Isaac.GetItemIdByName("Broken Monitor"),
	BROKEN_MONITOR_PASSIVE = Isaac.GetItemIdByName("Broken Monitor Passive"),
	BLUE_SCREEN = Isaac.GetItemIdByName("Blue Screen"),
	BOUNCY_DVD_LOGO = Isaac.GetItemIdByName("Bouncy DVD Logo"),

	A_BIT_OF_CHAOS = Isaac.GetItemIdByName("A Bit Of Chaos"),

	OVERBENT_SPOON = Isaac.GetItemIdByName("Overbent Spoon"),

	POINT_OF_NO_RETURN = Isaac.GetItemIdByName("Point Of No Return"),
	GLOWING_HOURGLASS_COOKIE = Isaac.GetItemIdByName("Glowing Hourglass Cookie"),

	ACTIVE_MATTMAN = Isaac.GetItemIdByName("Active Mattman"),

	CREEPER = Isaac.GetItemIdByName("Creeper")

}

david_pack.Trinket = {
	--X = Isaac.GetTrinketIdByName("x"),
	BLINDFOLD = Isaac.GetTrinketIdByName("Bloody Blindfold"),
	ACTIVE_WORM = Isaac.GetTrinketIdByName("Active Worm"),
	ORANGE_COUNTDOWN = Isaac.GetTrinketIdByName("Orange Countdown"),
	PINK_COUNTDOWN = Isaac.GetTrinketIdByName("Pink Countdown"),
	RGB_COUNTDOWN = Isaac.GetTrinketIdByName("RGB Countdown"),
}

david_pack.NullItem = {
	--X = Isaac.GetNullItemIdByName("x"),

	PRISONER_TRANSFORMATION_COUNTER = Isaac.GetNullItemIdByName("Prisoner Transformation Counter"),
	PRISONER_TRANSFORMATION = Isaac.GetNullItemIdByName("Prisoner Transformation"),

	GAMBLING_ADDICT_TRANSFORMATION_COUNTER = Isaac.GetNullItemIdByName("Gambling Addict Transformation Counter"),
	GAMBLING_ADDICT_TRANSFORMATION  = Isaac.GetNullItemIdByName("Gambling Addict Transformation"),

	OVERCHARGED_BATTERY_CHARGE = Isaac.GetNullItemIdByName("Overcharged Battery Charge"),

	POWERFUL_COINFLIP_UP = Isaac.GetNullItemIdByName("Powerful Coinflip Up"),
	MISERABLE_COINFLIP_UP = Isaac.GetNullItemIdByName("Miserable Coinflip Up"),
	BLESSED_COINFLIP_UP = Isaac.GetNullItemIdByName("Blessed Coinflip Up"),
	SWIFT_COINFLIP_UP = Isaac.GetNullItemIdByName("Swift Coinflip Up"),

	POWERFUL_COINFLIP_DOWN = Isaac.GetNullItemIdByName("Powerful Coinflip Down"),
	MISERABLE_COINFLIP_DOWN = Isaac.GetNullItemIdByName("Miserable Coinflip Down"),
	BLESSED_COINFLIP_DOWN = Isaac.GetNullItemIdByName("Blessed Coinflip Down"),
	SWIFT_COINFLIP_DOWN = Isaac.GetNullItemIdByName("Swift Coinflip Down"),

	HANDCUFFED = Isaac.GetNullItemIdByName("Handcuffed"),
}

david_pack.Pickup = {
	--X = Isaac.GetEntityVariantByName("x"),
	EXPIRED_LOTTERY_TICKET = Isaac.GetEntityVariantByName("Expired Lottery Ticket"),
	HANDCUFFS_KEY = Isaac.GetEntitySubTypeByName("Handcuffs Key")
}

david_pack.Sack = {
	--X = Isaac.GetEntitySubTypeByName("x"),
}

david_pack.Card = {
	--X = Isaac.GetCardIdByName("x"), !! THIS GETS THE "hud" PROPERTY IN pocketitems.xml NOT THE "name" PROPERTY
	EXPIRED_LOTTERY_TICKET = Isaac.GetCardIdByName("Expired Lottery Ticket")
}

david_pack.Effect = {
	--X = Isaac.GetEntityVariantByName("x"),
	GAMBLING_BUTTON = Isaac.GetEntityVariantByName("Gambling Button"),
	CHOCO_WAFFLES_ICON = Isaac.GetEntityVariantByName("Choco Waffles Icon"),
}

david_pack.Sound = {
	--X = Isaac.GetSoundIdByName("x"),
	LETS_GO_GAMBLING = Isaac.GetSoundIdByName("lets_go_gambling"),
	AW_DANG_IT = Isaac.GetSoundIdByName("aw_dang_it"),
	I_CANT_STOP_WINNING = Isaac.GetSoundIdByName("i_cant_stop_winning"),
	CREEPER_HISS = Isaac.GetSoundIdByName("creeper_hiss"),
}

david_pack.Giantbook = {
	--X = Isaac.GetGiantBookIdByName("x"),
}

david_pack.ItemPool = {
	--X = Isaac.GetPoolIdByName("x"),
}

david_pack.Price = {
	--X = 1,
}

david_pack.LevelCurse = {
	CURSE_OF_BLACKOUT = 1 << (Isaac.GetCurseIdByName("Curse of the Blackout!") - 1),
	CURSE_OF_THE_CATACOMB = 1 << (Isaac.GetCurseIdByName("Curse of the Catacomb!") - 1),
	CURSE_OF_ABSOLUTE_DISORIENTATION = 1 << (Isaac.GetCurseIdByName("Curse of the Absolute Disorientation!") - 1),
	CURSE_OF_UNFATHOMABLE = 1 << (Isaac.GetCurseIdByName("Curse of the Unfathomable!") - 1),
	CURSE_OF_UNPREDICTABILITY = 1 << (Isaac.GetCurseIdByName("Curse of the Unpredictability!") - 1),
	CURSE_OF_VISIONLESS = 1 << (Isaac.GetCurseIdByName("Curse of the Visionless!") - 1)
}



david_pack.RealCollectible = {
	--X = Isaac.GetItemIdByName("x"),

	-- Prisoner Transformation --
	PRISON_JUMPSUIT = Isaac.GetItemIdByName("Prison Jumpsuit"),
	HANDCUFFS = Isaac.GetItemIdByName("Handcuffs"),

	-- Gambling Addict Transformation --
	RISK_OF_GAMBLING = Isaac.GetItemIdByName("Risk Of Gambling"),
	POWERFUL_COINFLIP = Isaac.GetItemIdByName("Powerful Coinflip"),
	BLESSED_COINFLIP = Isaac.GetItemIdByName("Blessed Coinflip"),
	SWIFT_COINFLIP = Isaac.GetItemIdByName("Swift Coinflip"),
	
	-- Certificates --
	TORN_DEATH_CERTIFICATE = Isaac.GetItemIdByName("Torn Death Certificate"),
	RUNE_CERTIFICATE = Isaac.GetItemIdByName("Rune Certificate"),
	MEDICAL_CERTIFICATE = Isaac.GetItemIdByName("Medical Certificate"),

	MIXED_EMOTIONS = Isaac.GetItemIdByName("Mixed Emotions"),

	OVERCHARGED_BATTERY = Isaac.GetItemIdByName("The Overcharged Battery"),

	BROKEN_MONITOR = Isaac.GetItemIdByName("Broken Monitor"),
	BLUE_SCREEN = Isaac.GetItemIdByName("Blue Screen"),

	A_BIT_OF_CHAOS = Isaac.GetItemIdByName("A Bit Of Chaos")
}
