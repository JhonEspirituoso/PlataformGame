extends KinematicBody2D

export var speed = 64
export var health = 1
var velocity = Vector2()
var move_direction = -1
var gravity = 1200
var hitted = false

func _physics_process(delta):
	velocity.x = speed * move_direction
	velocity.y +=  gravity * delta
	
	velocity = move_and_slide(velocity)
	
	if move_direction == 1:
		$texture.flip_h = true
	else:
		$texture.flip_h = false
	_set_animation()

func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		$texture.flip_h != $texture.flip_h
		$ray_wall.scale.x *= -1
		move_direction *= -1
		$anim.play("run")

func _set_animation():
	var anim = "run"
	if $ray_wall.is_colliding():
		anim = "idle"
	elif velocity.x != 0:
		anim = "run"
	if hitted == true:
		anim = "hit"
		
	if $anim.assigned_animation != anim:
		$anim.play(anim)


func _on_Hitbox_body_entered(body):
	hitted = true
	health -= 1
	body .velocity.y -= 300
	yield(get_tree().create_timer(0.2),"timeout")
	hitted = false
	if health <1:
		queue_free()
		get_node("Hitbox/Collision").set_deferred("desabled", true)

