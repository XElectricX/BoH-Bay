/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a multipurpose neurostimulant and cardioregulator. Commonly used to slow bleeding and stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00bfff"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.5

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE)
		M.add_chemical_effect(CE_PAINKILLER, 10)
		M.add_chemical_effect(CE_BLOODRESTORE, 1)

/datum/reagent/inaprovaline/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	if(prob(5))
		M.slurring = max(M.slurring, 10)
	if(prob(2))
		M.drowsyness = max(M.drowsyness, 5)

/datum/reagent/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#bf0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.9

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 * removed, 0)
		M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + volume - overdose)/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(4))
				E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/kelotane
	name = "Kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffa800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.9

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 6 * removed)

/datum/reagent/dermaline
	name = "Dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ff8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.9

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 12 * removed)

/datum/reagent/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00a000"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.1
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/datum/reagent/toxin/zombiepowder,
		/datum/reagent/soporific,
		/datum/reagent/chloralhydrate
	)

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(remove_generic)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_up_to_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/datum/reagent/R in ingested.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			ingested.remove_reagent(R.type, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			M.reagents.remove_reagent(R.type, removing)
			return

/datum/reagent/dexalin
	name = "Dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080ff"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.4

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else if(alien != IS_DIONA && alien != IS_MANTID)
		M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent(/datum/reagent/lexorin, 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	description = "Dexalin Plus is used in the treatment of extreme oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040ff"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.7

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else if(alien != IS_DIONA)
		M.add_chemical_effect(CE_OXYGENATED, 2)
	holder.remove_reagent(/datum/reagent/lexorin, 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040ff"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 6

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(3 * removed, 3 * removed)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080ff"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.9

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-100 * removed)
		M.add_chemical_effect(CE_OXYGENATED, 1)
		M.heal_organ_damage(30 * removed, 30 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(!BP_IS_ROBOTIC(I))
					I.heal_damage(20*removed)

/datum/reagent/cryoxadone/affect_tray(var/obj/machinery/portable_atmospherics/hydroponics/H, var/datum/seed/seed, var/removed)
	H.toxins -= removed*3
	return

/datum/reagent/clonexadone
	name = "Clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80bfff"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	heating_products = list(/datum/reagent/cryoxadone, /datum/reagent/sodium)
	heating_point = 50 CELSIUS
	heating_message = "turns back to sludge."
	value = 5.5

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-300 * removed)
		M.add_chemical_effect(CE_OXYGENATED, 2)
		M.heal_organ_damage(50 * removed, 50 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(!BP_IS_ROBOTIC(I))
					I.heal_damage(30*removed)

/datum/reagent/clonexadone/affect_tray(var/obj/machinery/portable_atmospherics/hydroponics/H, var/datum/seed/seed, var/removed)
	H.toxins -= removed*5
	H.mutation_level -= removed*3
	return

/datum/reagent/nanitefluid
	name = "Nanite Fluid"
	description = "A solution of repair nanites used to repair robotic organs. Due to the nature of the small magnetic fields used to guide the nanites, it must be used in temperatures below 170K."
	taste_description = "metallic sludge"
	reagent_state = LIQUID
	color = "#c2c2d6"
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/nanitefluid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.heal_organ_damage(30 * removed, 30 * removed, affect_robo = TRUE)
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(BP_IS_ROBOTIC(I))
					I.heal_damage(20*removed)
		else
			M.heal_organ_damage(30 * removed, 30 * removed)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.3

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 35)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	M.druggy = max(M.druggy, 2)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller. Don't mix with alcohol."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose = 30
	scannable = 1
	metabolism = 0.05
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.1
	var/pain_power = 80 //magnitide of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/effectiveness = 1
	if(M.chem_doses[type] < effective_dose) //some ease-in ease-out for the effect
		effectiveness = M.chem_doses[type]/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	if(M.chem_doses[type] > 0.5 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(M.chem_doses[type] > 0.75 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(M.chem_doses[type] > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination(120, 30)
	M.druggy = max(M.druggy, 10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/tramadol/proc/isboozed(var/mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		var/list/pool = M.reagents.reagent_list | ingested.reagent_list
		for(var/datum/reagent/ethanol/booze in pool)
			if(M.chem_doses[booze.type] < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2

/datum/reagent/tramadol/oxycodone
	name = "Oxycodone"
	description = "An effective and very addictive painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	scannable = 1
	overdose = 20
	pain_power = 200
	effective_dose = 2

/datum/reagent/deletrathol
	name = "Deletrathol"
	description = "An effective painkiller that causes confusion."
	taste_description = "confusion"
	color = "#800080"
	reagent_state = LIQUID
	overdose = 15
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE

/datum/reagent/deletrathol/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PAINKILLER, 80)
	H.add_chemical_effect(CE_SLOWDOWN, 1)
	H.make_dizzy(2)
	if(prob(75))
		H.drowsyness++
	if(prob(25))
		H.confused++

/datum/reagent/deletrathol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 2)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99ccff"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE / 6 // 5
	scannable = 1
	value = 4.6

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(/datum/reagent/mindbreaker, 5)
	M.adjust_hallucination(-10)
	M.add_chemical_effect(CE_MIND, 2)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20)

/datum/reagent/dylovene/venaxilin
	name = "Venaxilin"
	description = "Venixalin is a strong, specialised antivenom for dealing with advanced toxins and venoms."
	taste_description = "overpowering sweetness"
	color = "#dadd98"
	scannable = 1
	metabolism = REM * 2
	remove_generic = 0
	remove_toxins = list(
		/datum/reagent/toxin/venom,
		/datum/reagent/toxin/carpotoxin
	)

/datum/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffff66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5.9

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.confused++
		H.drowsyness++

/datum/reagent/imidazoline
	name = "Imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.2

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561ec3"
	overdose = 10
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 6

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/internal/I in H.internal_organs)
			if(!BP_IS_ROBOTIC(I))
				if(I.organ_tag == BP_BRAIN)
					if(I.damage >= I.min_bruised_damage)
						continue
					H.confused++
					H.drowsyness++
				I.heal_damage(removed)

/datum/reagent/kompoton
	name = "Kompoton"
	description = "Used to completely regenerate internal organs and the nervous systems. Suffering guaranteed."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#d82e2e"
	overdose = 15
	scannable = 1
	flags = IGNORE_MOB_SIZE
	var/agony_amount = 1
	value = 6

/datum/reagent/kompoton/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/internal/I in H.internal_organs)
			if(!BP_IS_ROBOTIC(I))
				if(I.organ_tag == BP_BRAIN)
					if(I.damage >= I.max_damage)
						continue
					H.confused++
					H.drowsyness++
				I.heal_damage(removed*7)
				M.apply_effect(agony_amount, PAIN, 0)
				if(prob(5))
					M.custom_emote(2, "[pick("dry heaves!","twists and spasms erratically!","wails in agony!")]")
					to_chat(M, "<span class='danger'>You feel like your insides are disintegrating!</span>")
				for(var/obj/item/organ/external/E in H.organs)
					if(E.status & ORGAN_ARTERY_CUT)
						E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 3.6

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.disabilities = 0
	M.sdisabilities = 0

	if(needs_update && ishuman(M))
		M.dna.ResetUI()
		M.dna.ResetSE()
		domutcheck(M, null, MUTCHK_FORCED)

/datum/reagent/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 3.9

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 3.1

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				M.chem_doses[R.type] = max(M.chem_doses[R.type] - removed * 5, 0)

/datum/reagent/hyronalin
	name = "Hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.3

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.7

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 70 * removed, 0)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 2.5

/datum/reagent/spaceacillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.immunity = max(M.immunity - 0.1, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_COMMON)
	M.add_chemical_effect(CE_ANTIBIOTIC, 1)
	if(volume > 10)
		M.immunity = max(M.immunity - 0.3, 0)
		M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_ENGINEERED)
	if(M.chem_doses[type] > 15)
		M.immunity = max(M.immunity - 0.25, 0)

/datum/reagent/spaceacillin/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.immunity = max(M.immunity - 0.25, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_EXOTIC)
	if(prob(2))
		M.immunity_norm = max(M.immunity_norm - 1, 0)

/datum/reagent/sterilizine
	name = "Sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	touch_met = 5
	value = 2.2

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.germ_level < INFECTION_LEVEL_TWO) // rest and antibiotics is required to cure serious infections
		M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/leporazine
	name = "Leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	chilling_products = list(/datum/reagent/leporazine/cold)
	chilling_point = -10 CELSIUS
	chilling_message = "Takes on the consistency of slush."
	heating_products = list(/datum/reagent/leporazine/hot)
	heating_point = 110 CELSIUS
	heating_message = "starts swirling, glowing occasionally."
	value = 2

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/hot
	name = "Pyrogenic Leporazine"
	chilling_products = list(/datum/reagent/leporazine)
	chilling_point = 0 CELSIUS
	chilling_message = "Stops swirling and glowing."
	heating_products = null
	heating_point = null
	heating_message = null
	scannable = 1

/datum/reagent/leporazine/hot/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/cold
	name = "Cryogenic Leporazine"
	chilling_products = null
	chilling_point = null
	chilling_message = null
	heating_products = list(/datum/reagent/leporazine)
	heating_point = 100 CELSIUS
	heating_message = "Becomes clear and smooth."
	scannable = 1

/datum/reagent/leporazine/cold/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 290)
		M.bodytemperature = max(290, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#bf80bf"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ff80ff"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 1)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#ff80bf"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 3.5

/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 2)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination(200, 100)

/datum/reagent/nicotine
	name = "Nicotine"
	description = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	reagent_state = LIQUID
	color = "#efebaa"
	metabolism = REM * 0.002
	overdose = 6
	scannable = 1
	data = 0
	value = 2

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && M.chem_doses[type] >= 0.05 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
		data = world.time
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/datum/reagent/nicotine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/tobacco
	name = "Tobacco"
	description = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	reagent_state = SOLID
	color = "#684b3c"
	scannable = 1
	value = 3
	scent = "cigarette smoke"
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 4

	var/nicotine = REM * 0.2

/datum/reagent/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(/datum/reagent/nicotine, nicotine)

/datum/reagent/tobacco/fine
	name = "Fine Tobacco"
	taste_description = "fine tobacco"
	value = 5
	scent = "fine tobacco smoke"
	scent_descriptor = SCENT_DESC_FRAGRANCE

/datum/reagent/tobacco/bad
	name = "Terrible Tobacco"
	taste_description = "acrid smoke"
	value = 0
	scent = "acrid tobacco smoke"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR

/datum/reagent/tobacco/liquid
	name = "Nicotine Solution"
	description = "A diluted nicotine solution."
	reagent_state = LIQUID
	taste_mult = 0
	color = "#fcfcfc"
	nicotine = REM * 0.1
	scent = null
	scent_intensity = null
	scent_descriptor = null
	scent_range = null

/datum/reagent/menthol
	name = "Menthol"
	description = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#80af9c"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	data = 0

/datum/reagent/menthol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.35)
		data = world.time
		to_chat(M, "<span class='notice'>You feel faintly sore in the throat.</span>")

/datum/reagent/rezadone
	name = "Rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "sickness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(M.chem_doses[type] > 3 && ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			E.status |= ORGAN_DISFIGURED //currently only matters for the head, but might as well disfigure them all.
	if(M.chem_doses[type] > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/noexcutite
	name = "Noexcutite"
	description = "A thick, syrupy liquid that has a lethargic effect. Used to cure cases of jitteriness."
	taste_description = "numbing coldness"
	reagent_state = LIQUID
	color = "#bc018a"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/noexcutite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	if(alien != IS_DIONA)
		M.make_jittery(-50)

/datum/reagent/antidexafen
	name = "Antidexafen"
	description = "All-in-one cold medicine. Fever, cough, sneeze, safe for babies."
	taste_description = "cough syrup"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	scannable = 1
	metabolism = REM * 0.05
	flags = IGNORE_MOB_SIZE

/datum/reagent/antidexafen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	M.add_chemical_effect(CE_PAINKILLER, 15)
	M.add_chemical_effect(CE_ANTIVIRAL, 1)

/datum/reagent/antidexafen/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)

/datum/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.05
	value = 2

/datum/reagent/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(M.chem_doses[type] < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(30*volume, 60))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(M.chem_doses[type] < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*volume, 10))
	M.add_chemical_effect(CE_PULSE, 2)
	if(M.chem_doses[type] > 10)
		M.make_jittery(1)
	if(volume >= 5 && M.is_asystole())
		remove_self(5)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			heart.take_internal_damage(heart.max_damage * 0.15)

/datum/reagent/lactate
	name = "Lactate"
	description = "Lactate is produced by the body during strenuous exercise. It often correlates with elevated heart rate, shortness of breath, and general exhaustion."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#eeddcc"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	metabolism = REM

/datum/reagent/lactate/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_BREATHLOSS, 0.02 * volume)
	if(volume >= 5)
		M.add_chemical_effect(CE_PULSE, 1)
		M.add_chemical_effect(CE_SLOWDOWN, (volume/5) ** 2)
	else if(M.chem_doses[type] > 20) //after prolonged exertion
		M.make_jittery(10)

/datum/reagent/nanoblood
	name = "Nanoblood"
	description = "A stable hemoglobin-based nanoparticle oxygen carrier, used to rapidly replace lost blood. Toxic unless injected in small doses. Does not contain white blood cells."
	taste_description = "blood with bubbles"
	reagent_state = LIQUID
	color = "#c10158"
	scannable = 1
	overdose = 5
	metabolism = 1

/datum/reagent/nanoblood/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(!M.should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	if(M.regenerate_blood(4 * removed))
		M.immunity = max(M.immunity - 0.1, 0)
		if(M.chem_doses[type] > M.species.blood_volume/8) //half of blood was replaced with us, rip white bodies
			M.immunity = max(M.immunity - 0.5, 0)

// Sleeping agent, produced by breathing N2O.
/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide"
	description = "An ubiquitous sleeping agent also known as laughing gas."
	taste_description = "dental surgery"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	var/do_giggle = TRUE

/datum/reagent/nitrous_oxide/xenon
	name = "Xenon"
	description = "A nontoxic gas used as a general anaesthetic."
	do_giggle = FALSE
	taste_description = "nothing"
	color = COLOR_GRAY80

/datum/reagent/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/dosage = M.chem_doses[type]
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	if(do_giggle && prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)


	// Immunity-restoring reagent
/datum/reagent/immunobooster
	name = "Immunobooster"
	description = "A drug that helps restore the immune system. Will not replace a normal immunity."
	taste_description = "chalky"
	reagent_state = LIQUID
	color = "#ffc0cb"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	scannable = 1

/datum/reagent/immunobooster/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume < REAGENTS_OVERDOSE && !M.chem_effects[CE_ANTIVIRAL])
		M.immunity = min(M.immunity_norm * 0.5, removed + M.immunity) // Rapidly brings someone up to half immunity.
	if(M.chem_effects[CE_ANTIVIRAL]) //don't take with 'cillin
		M.add_chemical_effect(CE_TOXIN, 4) // as strong as taking vanilla 'toxin'


/datum/reagent/immunobooster/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.immunity -= 0.5 //inverse effects when abused


//Antag Agents
/datum/reagent/hypeross
	name = "Hypeross-7"
	description = "A complex, alien compound that stimulates rapid bone growth."
	taste_description = "spoiled milk"
	reagent_state = LIQUID
	color = "#990033"
	overdose = 5
	value = 50

/datum/reagent/hypeross/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(ishuman(M) && M.chem_doses[type] >= 2)
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		M.make_dizzy(10)
		M.heal_organ_damage(2 * removed, 0)
		M.add_chemical_effect(CE_PAINKILLER, 20)
		var/mob/living/carbon/human/H = M
		var/in_progress = 0
		var/fix_delay = 300
		for(var/obj/item/organ/external/E in H.organs)
			if((E.status & ORGAN_BROKEN || E.is_stump()) && in_progress == 0 && !(BP_IS_ROBOTIC(E)))
				in_progress = 1
				to_chat(H, "<span class='notice'>You feel the jarring sensation of invisible hands forcing your [E.name] back together.</span>")
				H.make_dizzy(10)
				sleep(fix_delay)
				if(E.status || E.is_stump())
					to_chat(H, "<span class='notice'><font size = [rand(1,3)]>POP!</font></span>")
					playsound(H.loc, "fracture", 30, 1, -2)
					if(E.is_stump() && (E.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
						E.droplimb(1,DROPLIMB_EDGE)
					else
						E.status &= ~ORGAN_BROKEN
				in_progress = 0

/datum/reagent/hypeross/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.take_organ_damage(volume/2, 0)
	M.add_chemical_effect(CE_SLOWDOWN, 2)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-2) //we're going to be awake for most of this
	M.make_jittery(3)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(prob(1) && !(BP_IS_ROBOTIC(E)))
				if(prob(75))
					var/S = new /obj/item/weapon/material/shard(material_key = MATERIAL_BONE_GENERIC)
					E.embed(S)
					H.visible_message(
						"<span class='danger'>A shard of bone breaks out of [H]'s [E.name]!</span>",
						"<span class='danger'>You feel something tearing out of your [E.name]!</span>"
						)
				else
					var/BS = new /obj/item/weapon/material/shard/shrapnel(material_key = MATERIAL_BONE_GENERIC)
					E.embed(BS, silent = 1)
					to_chat(H, "<span class='warning'>You feel something break loose inside your [E.name].</span>")

// Alcoholism's Drug Rework Below!


// Cannabis Products

/datum/reagent/thc
	name = "Tetrahydrocannabinol-7"
	description = "Tetrahydrocannabinol is one of the many active cannabinoids in Cannabis. THC-7 was bred into Cannabis roughly seventy years ago!"
	taste_description = "pungent skunk"
	reagent_state = LIQUID
	color = "#807653"
	overdose = 120 // If you are smoking that much pot you need to get a job buddy.
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.5
	scent = "skunky odor"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 8 // Good luck hiding it, buddy!
	flags = IGNORE_MOB_SIZE
	value = 3 // Selling Drugs on a SolGov space ship, huh? You know there are no nice prisons, right?

/datum/reagent/thc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 60) // Between Paracementol and Tramadol!

/datum/reagent/thc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>You're feeling a bit better after that hit...</span>")
	else
		M.add_chemical_effect(CE_MIND, 2)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(95))
				to_chat(M, "<span class='notice'>You feel calmed and held together better after that hit...</span>")
			else
				to_chat(M, "<span class='warning'>You feel a bit sick after that hit...</span>") // Space Weed is not your uncles stash, buddy!
				M.hallucination(100, 50)


/datum/reagent/hash
	name = "Hashish"
	description = "Hash is a refined product from Cannabis. It's incredibly concentrated! THC-7 Hash like this in particular is an acquired taste.."
	taste_description = "sickly skunk"
	reagent_state = LIQUID
	color = "#807653"
	overdose = 60 // Don't go smoking too much of that Solarian spice!
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.3 // Hash lasts a good sum longer!
	flags = IGNORE_MOB_SIZE
	scent = "overwhelming skunky odor"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 6 // Hash loses some of it's odor compared to flower. Perfect for smoking in a cave somewhere in Space-Afghanistan!
	value = 18 // It's worth it to process your THC into Hash! Too bad it's turbo-fucking-illegal in all those United Cities..

/datum/reagent/hash/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 120) // Stronger than Tramadol. Have fun, kids!

/datum/reagent/hash/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Hash just hits different...</span>")
	else
		M.add_chemical_effect(CE_MIND, 2)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(80))
				to_chat(M, "<span class='notice'>You're feeling much better after that hit...</span>")
			else
				to_chat(M, "<span class='warning'>OH SHIT BUDDY, YOU FUCKED UP NOW! EYE IN THE FUCKING SKY IS COMING!...</span>") // HAVE FUN ASSHOLE!
				M.hallucination(200, 100) // I HEARD YOU LIKE LSD SO WE MADE THE HASH STRONGER THAN LSD!


// [HARD DRUGS]

// Black Spice (Refined)
/datum/reagent/blackspice
	name = "Black Spice"
	description = "Produced from bioengineered opium poppy, Black-Spice is one of the cheapest hard-drug on the black-market! It's incredibly dangerous as both a stimulant and opiod!"
	taste_description = "oddly sweet dirt"
	reagent_state = LIQUID
	color = "#000000"
	overdose = 6 // You're doing bioengineered speedball. Don't fuck around with it!
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.1
	flags = IGNORE_MOB_SIZE
	value = 6 // Actually worth quite a bit! Sadly the plants don't produce much..

/datum/reagent/blackspice/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PAINKILLER, 300) // Makes Oxycodone look like fucking Baby Asprin! Too bad it'll rot you out from the inside..
	if(prob(5))
		M.emote(pick("tweaks", "blink_r", "shakes"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/blackspice/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.hallucination(100, 40)
	M.add_chemical_effect(CE_BREATHLOSS, 1) // Oh boy your lungs are gonna hate your ass!
	M.add_chemical_effect(CE_TOXIN, 2) // Also your organs are failing.


// Black Spice Unrefined

/datum/reagent/blackspiceraw
	name = "Black Poppy Oil"
	description = "Bioengineered Poppy oil used commonly in drug-production. Some cultures brew it to denature it's narcotic compounds into a medicinal tea! Still highly illegal despite it's relatively safe nature.."
	taste_description = "floral dirt"
	reagent_state = LIQUID
	color = "#000000"
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.1
	flags = IGNORE_MOB_SIZE
	value = 1 // It's worthless without being refined. You really wanna go to jail selling this illusive toast topping?

/datum/reagent/blackspiceraw/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PAINKILLER, 30) // Light painkiller.

/datum/reagent/creth
	name = "Creth"
	description = "Creth is a highly illegal chemical with massive boosts and terrible side effects."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = REM * 0.1
	overdose = 15
	value = 15

/datum/reagent/creth/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)
	M.druggy = max(M.druggy, 10)
	M.adjust_stamina(20)
	var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
	heart.take_internal_damage(0.05) // Yeah this is low, any higher and you die insanely fast.


/datum/reagent/creth/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_TOXIN, 3)
	M.add_chemical_effect(CE_PAINKILLER, 80)
	M.add_chemical_effect(CE_SPEEDBOOST, 5)
	M.add_chemical_effect(CE_PULSE, 2)

//Lean

/datum/reagent/tilt
	name = "Tilt"
	description = "A potent downer made from mixing cough medicine and Space-Up."
	taste_description = "purple sweetness"
	reagent_state = LIQUID
	color = "#800080"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 1.5

	glass_name = "tilt"
	glass_desc = "The best way there is to get tilted."

/datum/reagent/tilt/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 10
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	M.add_chemical_effect(M.add_chemical_effect(CE_SLOWDOWN, 1))
	M.slurring = max(M.slurring, 10)

	if(prob(90))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(70))
		M.confused = max(M.confused, 10)
	if(prob(10))
		M.emote("drool")
		M.apply_effect(STUTTER, 3)

/datum/reagent/tilt/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	if(prob(70))
		M.add_chemical_effect(CE_BREATHLOSS, 5)
	if(prob(10))
		M.Paralyse(20)
		M.Sleeping(30)
