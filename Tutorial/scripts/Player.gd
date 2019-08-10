extends KinematicBody2D

var max_hspeed = 240

var hfriction = 60

var max_uspeed = 600
var max_dspeed = 480

var max_gravity = 1800

var bullet = true
var bullet_cooldown = 0.25
var bullet_cooldown_counter = 0

var tackle = false
var tackle_friction = 120

export var velocity = Vector2.ZERO
export var gravity = 0

const bullet_obj = preload("res://scenes/Bullet.tscn")

func _physics_process(delta):
	
	if !bullet:
		bullet_cooldown_counter += delta
		if bullet_cooldown_counter >= bullet_cooldown:
			bullet_cooldown_counter = 0
			bullet = true
	
	velocity.y += gravity * delta
	
	move_and_slide(velocity, Vector2.UP, true)
	
	if !tackle:
		
		var hsign = sign(velocity.x)
		velocity.x -= hsign * hfriction
		if sign(velocity.x) != hsign:
			velocity.x = 0
		
		if Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
			velocity.x = -max_hspeed
		
		if Input.is_action_pressed("right") && !Input.is_action_pressed("left"):
			velocity.x = max_hspeed
		
		if Input.is_action_pressed("jump") && gravity == 0:
			velocity.y = -max_uspeed
			gravity = max_gravity
		
		if is_on_floor() && velocity.y > 0:
			gravity = 0
			velocity.y = 0
		else:
			gravity = max_gravity
		
		velocity.y = min(velocity.y, max_dspeed)
		
		look_at(get_global_mouse_position())
		
		if Input.is_action_pressed("fire") && bullet:
			bullet = false
			var bullet_inst = bullet_obj.instance()
			bullet_inst.global_position = global_position
			bullet_inst.rotation = rotation
			$"../Bullets".add_child(bullet_inst)
			
			Sfx.play("sounds/bullet.wav")
		
		if Input.is_action_just_pressed("tackle") && !tackle:
			tackle = true
			$AnimationPlayer.play("tackle")
			Sfx.play("sounds/tackle.wav")
	
	if tackle:
		var new_speed = velocity.length() - tackle_friction
		if new_speed > 0:
			velocity = velocity.normalized() * new_speed
		else:
			velocity = Vector2.ZERO

func tack_start():
	gravity = 0
	velocity = 4 * max_hspeed * transform.x
	set_collision_mask_bit(1, false)
	$Camera2D.drag_margin_h_enabled = true
	$Camera2D.drag_margin_v_enabled = true

func tack_back():
	velocity = 4 * max_hspeed * -transform.x

func tack_end():
	gravity = max_gravity
	velocity = Vector2.ZERO
	tackle = false
	set_collision_mask_bit(1, true)
	$Camera2D.drag_margin_h_enabled = false
	$Camera2D.drag_margin_v_enabled = false
