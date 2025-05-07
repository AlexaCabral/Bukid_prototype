extends Control


func _ready():
	%Play.pressed.connect(play)
	%Option.pressed.connect(option)
	%About.pressed.connect(about)
	%Exit.pressed.connect(exit)


func play():
	get_tree().change_scene_to_file('res://scenes/houses/inside_house.tscn')

func option():
	pass

func about():
	pass

func exit():
	get_tree().quit()
