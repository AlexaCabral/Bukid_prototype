extends CharacterBody2D


var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 200
var player_alive = true

var attack_ip = false

const speed = 100
var current_direction = "none"

func _ready():
	$AnimatedSprite2D.play("idle_front")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false
		health = 0

func player_movement(delta):
	if attack_ip:
		velocity = Vector2.ZERO
		return
	
	if Input.is_action_pressed("walk_right"):
		current_direction = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("walk_left"):
		current_direction = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("walk_down"):
		current_direction = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("walk_up"):
		current_direction = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_direction
	
	if dir == "right":
		$AnimatedSprite2D.flip_h = false
		if movement == 1:
			$AnimatedSprite2D.play("walk_side")
		elif movement == 0:
			if not attack_ip:
				$AnimatedSprite2D.play("idle_side")
				
	if dir == "left":
		$AnimatedSprite2D.flip_h = true
		if movement == 1:
			$AnimatedSprite2D.play("walk_side")
		elif movement == 0:
			if not attack_ip:
				$AnimatedSprite2D.play("idle_side")
	
	if dir == "down":
		if movement == 1:
			$AnimatedSprite2D.play("walk_front")
		elif movement == 0:
			if not attack_ip:
				$AnimatedSprite2D.play("idle_front")

	if dir == "up":
		if movement == 1:
			$AnimatedSprite2D.play("walk_back")
		elif movement == 0:
			if not attack_ip:
				$AnimatedSprite2D.play("idle_back")


func player():
	pass


func _on_hit_box_body_entered(body):
	if body.has_method("enemy"):
		print("HELLOO")
		enemy_inattack_range = true

func _on_hit_box_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 10
		enemy_attack_cooldown = false
		$AttackCooldown.start()
		print("Player health = ", health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_direction
	
	if Input.is_action_just_pressed("attack") and not attack_ip:
		global.player_current_attack = true
		attack_ip = true
		velocity = Vector2.ZERO
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
			$DealAttackTimer.start()
		
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
			$DealAttackTimer.start()
		
		if dir == "down":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_front")
			$DealAttackTimer.start()
		
		if dir == "up":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_back")
			$DealAttackTimer.start()


func _on_deal_attack_timer_timeout() -> void:
	$DealAttackTimer.stop()
	global.player_current_attack = false
	attack_ip = false
