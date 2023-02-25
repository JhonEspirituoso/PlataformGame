extends KinematicBody2D
var velocity = Vector2()
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded
var health = 3
var hurted = false
var knockback_dir = 1
var knockback_int = 500

onready var raycasts = $raycasts

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	_get_input()
	
	velocity = move_and_slide(velocity)
	is_grounded = _check_is_ground()
	_set_animation()
	
func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	
	if move_direction !=0:
		$Texture.scale.x = move_direction
		knockback_dir = move_direction

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_grounded:
		velocity.y = jump_force / 2
		
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _set_animation():
	var anim = "Idle"
	
	if !is_grounded:
		anim = "jump"
	
	elif velocity.x != 0:
		anim = "run"
	
	if velocity.y > 0 and !is_grounded:
		anim = "fall"
		
	if hurted:
			anim = "hit"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)

func knockback():
	velocity.x = -knockback_dir * knockback_int
	velocity = move_and_slide(velocity)
	
func _on_Hurtbox_body_entered(body: Node) -> void:
	print("Funcionou")
	health -= 1
	hurted = true
	knockback()
	get_node("Hurtbox/Collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("Hurtbox/Collision").set_deferred("disabled", false)
	hurted = false
	if health < 1:
		queue_free()
		get_tree().reload_current_scene()
	
