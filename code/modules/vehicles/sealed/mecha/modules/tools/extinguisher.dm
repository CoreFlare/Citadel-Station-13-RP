/obj/item/vehicle_module/tool/extinguisher
	name = "extinguisher"
	desc = "Exosuit-mounted extinguisher (Can be attached to: Engineering exosuits)"
	mech_flags = EXOSUIT_MODULE_WORKING | EXOSUIT_MODULE_COMBAT
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	range = MELEE|RANGED
	required_type = list(/obj/vehicle/sealed/mecha/working)
	var/spray_particles = 5
	///Units of liquid per particle. 5 is enough to wet the floor - it's a big fire extinguisher, so should be fine
	var/spray_amount = 5
	var/max_water = 1000

/obj/item/vehicle_module/tool/extinguisher/Initialize(mapload)
	. = ..()
	reagents = new/datum/reagent_holder(max_water)
	reagents.my_atom = src
	reagents.add_reagent("firefoam", max_water)

/obj/item/vehicle_module/tool/extinguisher/action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
	if(!action_checks(target) || get_dist(chassis, target)>3) return
	if(get_dist(chassis, target)>2) return
	set_ready_state(0)
	if(do_after_cooldown(target))
		if( istype(target, /obj/structure/reagent_dispensers) && get_dist(chassis,target) <= 1)
			var/obj/o = target
			var/amount = o.reagents.trans_to_obj(src, 200)
			occupant_message(SPAN_NOTICE("[amount] units transferred into internal tank."))
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			return

		if (src.reagents.total_volume < 1)
			occupant_message(SPAN_WARNING("\The [src] is empty."))
			return

		playsound(src, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(chassis,target)

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		for(var/a = 1 to 5)
			spawn(0)
				var/obj/effect/water/W = new /obj/effect/water(get_turf(chassis))
				var/turf/my_target
				if(a == 1)
					my_target = T
				else if(a == 2)
					my_target = T1
				else if(a == 3)
					my_target = T2
				else
					my_target = pick(the_targets)
				W.create_reagents(5)
				if(!W || !src)
					return
				reagents.trans_to_obj(W, spray_amount)
				W.set_color()
				W.set_up(my_target)
		return TRUE

/obj/item/vehicle_module/tool/extinguisher/get_equip_info()
	return "[..()] \[[src.reagents.total_volume]\]"

/obj/item/vehicle_module/tool/extinguisher/on_reagent_change()
	return
