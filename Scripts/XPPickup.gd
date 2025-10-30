extends PickupBase

var expValue = 5.0

func _ready() -> void:
	scale *= 1.0 + expValue/100.0

func player_pickup():
	target.expCount += expValue * target.buffStats.expMult
	queue_free()
