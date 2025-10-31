extends EnemyBase

@export var enemyProj: Resource
@export var desiredRange = 300.0

var projCD = 0.0
@export var projTime = 5.0


func _unique_process(delta):
	if target != null:
		projCD -= delta
		if target_distance > desiredRange:
			target_pos = target.position
		elif target_distance < desiredRange/2:
			target_pos = (position - target.position).normalized()*desiredRange
		else:
			target_pos = (target.position - position).rotated(PI/2)
			if projCD <= 0:
				projCD = projTime * buffStats.CDMult
				var proj = enemyProj.instantiate()
				proj.position = position + (target.position - position).normalized() * 50
				proj.rotation = position.angle_to_point(target.position)
				proj.projLvl = 1.0
				proj.damageMult = buffStats.damageMult
				get_tree().root.add_child(proj)
			
