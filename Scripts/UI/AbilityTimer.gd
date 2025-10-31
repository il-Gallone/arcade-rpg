extends TextureProgressBar


@export var abilIconBase: Resource
@export var abilIconAlt: Resource
@export var abilIconBasePrestA: Resource
@export var abilIconAltPrestA: Resource
@export var abilIconBasePrestB: Resource
@export var abilIconAltPrestB: Resource

enum abilType {PRIM, SCND, TERT, ULTI}

@export var ability: abilType
@export var playNum: int

func _ready() -> void:
	texture_over = abilIconBase
	max_value = dynamic_time()
			
func _process(_delta: float) -> void:
	max_value = dynamic_time()
	match ability:
		abilType.PRIM:
			value = GameManager.Players[playNum].primCD
			if GameManager.Players[playNum].primAbilAltMode == true:
				if GameManager.Players[playNum].level < 16:
					texture_over = abilIconAlt
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconAltPrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconAltPrestB
			else:
				if GameManager.Players[playNum].level < 16:
					texture_over = abilIconBase
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconBasePrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconBasePrestB
		abilType.SCND:
			value = GameManager.Players[playNum].scndCD
			if GameManager.Players[playNum].level <= 1:
				visible = false
			else:
				visible = true
			if GameManager.Players[playNum].scndAbilAltMode == true:
				if GameManager.Players[playNum].level < 17:
					texture_over = abilIconAlt
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconAltPrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconAltPrestB
			else:
				if GameManager.Players[playNum].level < 17:
					texture_over = abilIconBase
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconBasePrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconBasePrestB
		abilType.TERT:
			value = GameManager.Players[playNum].tertCD
			if GameManager.Players[playNum].level <= 2:
				visible = false
			else:
				visible = true
			if GameManager.Players[playNum].tertAbilAltMode == true:
				if GameManager.Players[playNum].level < 18:
					texture_over = abilIconAlt
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconAltPrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconAltPrestB
			else:
				if GameManager.Players[playNum].level < 18:
					texture_over = abilIconBase
				else:
					match  GameManager.Players[playNum].Prestige:
						PlayerController.PrestigeOption.PRESTA:
							texture_over = abilIconBasePrestA
						PlayerController.PrestigeOption.PRESTB:
							texture_over = abilIconBasePrestB
		abilType.ULTI:
			value = GameManager.Players[playNum].ultiCD
			if GameManager.Players[playNum].level <= 15:
				visible = false
			else:
				visible = true
			if GameManager.Players[playNum].ultiAbilAltMode == true:
				match  GameManager.Players[playNum].Prestige:
					PlayerController.PrestigeOption.PRESTA:
						texture_over = abilIconAltPrestA
					PlayerController.PrestigeOption.PRESTB:
						texture_over = abilIconAltPrestB
			else:
				match  GameManager.Players[playNum].Prestige:
					PlayerController.PrestigeOption.PRESTA:
						texture_over = abilIconBasePrestA
					PlayerController.PrestigeOption.PRESTB:
						texture_over = abilIconBasePrestB

func dynamic_time() -> float:
	match ability:
		abilType.PRIM:
			return GameManager.Players[playNum].primTime * GameManager.Players[playNum].buffStats.CDMult
		abilType.SCND:
			return GameManager.Players[playNum].scndTime * GameManager.Players[playNum].buffStats.CDMult
		abilType.TERT:
			return GameManager.Players[playNum].tertTime * GameManager.Players[playNum].buffStats.CDMult
		abilType.ULTI:
			return GameManager.Players[playNum].ultiTime * GameManager.Players[playNum].buffStats.CDMult
	return 0.0
