@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("InteractiveSceneChanger", "res://addons/interactive_scene_changer/InteractiveSceneChanger.gd")

func _exit_tree():
	remove_autoload_singleton("InteractiveSceneChanger")
