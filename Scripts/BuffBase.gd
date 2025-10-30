class_name BuffBase
extends Node

@export var timeLeft = 5.0
@export var damagePS = 2.0
@export var speedMod = 0.0
@export var damageMod = 0.0
@export var defenseMod = 0.0
@export var CDMod = 0.0
@export var expMod = 0.0

@export var Debuff = true

var modLvl = 1.0

@export var BuffID: String

var firstApp = true

func _ready() -> void:
	timeLeft *=  0.75 + 0.25 * modLvl
	damagePS *= 0.75 + 0.25 * modLvl
	speedMod *= 0.75 + 0.25 * modLvl
	damageMod *= 0.75 + 0.25 * modLvl
	defenseMod *= 0.75 + 0.25 * modLvl
	CDMod *= 0.75 + 0.25 * modLvl
	expMod *= 0.75 + 0.25 * modLvl

func apply_buff(delta: float, afflicted):
	if firstApp:
		firstApp = false
		if afflicted.buffs.size() > 0:
			for i in afflicted.buffs.size():
				if afflicted.buffs[i].BuffID == BuffID:
					afflicted.buffs[i].timeLeft += timeLeft
					timeLeft = 0
					queue_free()
				elif afflicted.buffs[i].BuffID == "Strong" + BuffID:
					afflicted.buffs[i].timeLeft += timeLeft/2
					timeLeft = 0
					queue_free()
				elif "Strong" + afflicted.buffs[i].BuffID == BuffID:
					afflicted.buffs[i].strengthen_buff(timeLeft, afflicted)
					timeLeft = 0
					queue_free()
		if timeLeft != 0:
			afflicted.buffStats.speedMult += speedMod
			afflicted.buffStats.damageMult += damageMod
			afflicted.buffStats.defenseMult += defenseMod
			afflicted.buffStats.CDMult += CDMod
			afflicted.buffStats.expMult += expMod
			afflicted.buffs.append(self)
	else:
		if timeLeft < delta:
			delta = timeLeft
			timeLeft = 0
			afflicted.buffStats.speedMult -= speedMod
			afflicted.buffStats.damageMult -= damageMod
			afflicted.buffStats.defenseMult -= defenseMod
			afflicted.buffStats.CDMult -= CDMod
			afflicted.buffStats.expMult -= expMod
		else:
			timeLeft -= delta
		if damagePS != 0:
			afflicted.damaged(damagePS * delta)
		
func strengthen_buff (timeAdded: float, afflicted) -> void:
	BuffID = "Strong" + BuffID
	timeLeft /= 2
	timeLeft += timeAdded
	damagePS *= 2
	speedMod *= 2
	damageMod *= 2
	defenseMod *= 2
	CDMod *= 2
	expMod *= 2
	afflicted.buffStats.speedMult += speedMod/2
	afflicted.buffStats.damageMult += damageMod/2
	afflicted.buffStats.defenseMult += defenseMod/2
	afflicted.buffStats.CDMult += CDMod/2
	afflicted.buffStats.expMult += expMod/2
