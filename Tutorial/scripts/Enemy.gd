extends Area2D

var destroyed = false
var scale_down = false
var scale_up = false
var destruction_started = true

var start_postion = Vector2.ZERO

func _ready():
	start_postion = position
	
func _physics_process(delta):
	position = start_postion + $Path2D/PathFollow2D.position
	$Path2D/PathFollow2D.unit_offset += delta / $Path2D.curve.get_point_count()

func _process(delta):
	if destroyed:
		if destruction_started:
			destruction_started = false
			Globals.score += 5
			Sfx.play("sounds/enemy.ogg")
		scale_down = true
		
	if scale_down:
		scale *= 0.8
		
		if scale.x <= 0.1:
			scale_down = false
			scale_up = true
	
	if scale_up:
		scale *= 1.8
	
	if scale.x >= 1.5:
		$AnimatedSprite.modulate.a *= 0.5
	
	if $AnimatedSprite.modulate.a <= 0.01:
		queue_free()

func _on_Enemy_body_entered(body):
	if body.get_name() == "Player":
		if body.tackle:
			if !destroyed:
				destroyed = true
		elif !destroyed:
			get_tree().reload_current_scene()
