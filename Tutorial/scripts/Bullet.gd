extends Area2D

var destroyed = false
var speed = 180

var velocity = Vector2.ZERO

func _ready():
	velocity = speed * transform.x

func _physics_process(delta):
	
	if destroyed:
		$AnimatedSprite.modulate.a *= 0.8
		velocity *= 0.8
	if $AnimatedSprite.modulate.a < 0.01:
		queue_free()

	position += velocity * delta

func _on_Bullet_body_entered(body):
	match body.get_class():
		"TileMap":
			destroyed = true


func _on_Bullet_area_entered(area):
	if area.get_name().begins_with("Enemy"):
		if !area.destroyed:
			destroyed = true
			area.destroyed = true
