# InteractiveSceneChanger, example : MIT License
# @author Vladimir Petrenko
extends Node3D

@export var to_scene: String # FILE
@export var obj_path: NodePath
@export var obj_count: int = 0 # (int, 0, 100000)

@onready var _button: Button = $CanvasLayer/Button

func _ready() -> void:
	assert(_button.connect("pressed", _on_button_pressed) == OK)

func _on_button_pressed() -> void:
	InteractiveSceneChanger.load_scene(to_scene)
