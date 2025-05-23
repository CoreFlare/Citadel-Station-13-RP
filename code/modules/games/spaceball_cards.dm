/obj/item/pack/spaceball
	name = "spaceball booster pack"
	desc = "Officially licensed to take your money."
	icon_state = "card_pack_spaceball"
	parentdeck = "spaceball"

/obj/item/pack/spaceball/Initialize(mapload)
	. = ..()
	var/datum/playingcard/P
	var/i
	var/year = 554 + text2num(time2text(world.timeofday, "YYYY"))
	for(i=0;i<5;i++)
		P = new()
		if(prob(1))
			P.name = "Spaceball Jones, [year] Brickburn Galaxy Trekers"
			P.card_icon = "spaceball_jones"
		else
			var/language_type = pick(/datum/prototype/language/human,/datum/prototype/language/diona_local,/datum/prototype/language/tajaran,/datum/prototype/language/unathi)
			var/datum/prototype/language/L = new language_type()
			var/team = pick("Brickburn Galaxy Trekers","Mars Rovers", "Qerrbalak Saints", "Moghes Rockets", "Meralar Lightning", "[(LEGACY_MAP_DATUM).starsys_name] Vixens", "Euphoric-Earth Alligators")
			P.name = "[L.get_random_name(pick(MALE,FEMALE))], [year - rand(0,50)] [team]"
			P.card_icon = "spaceball_standard"
		P.back_icon = "card_back_spaceball"

		cards += P
