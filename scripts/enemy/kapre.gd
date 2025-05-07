extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null

var player_inattack_range = false
var can_take_damage = true
var health = 300
var enemy_alive = true

func _physics_process(delta):
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		
		
		if player.position.x < position.x:
			$AnimatedSprite2D.play("walk_left")
		else:
			$AnimatedSprite2D.play("walk_right")
			
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false


func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_range = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_range = false

func deal_with_damage():
	if player_inattack_range and global.player_current_attack:
		if can_take_damage:
			health -= 20
			can_take_damage = false
			print("Enemy health = ", health)
			$TakeDamageCooldown.start()
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	$TakeDamageCooldown.stop()
	can_take_damage = true
