# InteractiveSceneChanger, use as AutoLoaded script: MIT License
# @author Vladimir Petrenko
extends Node

signal progress_changed(progress)
signal load_done

var _load_screen_path: String = "res://addons/interactive_scene_changer/LoadScreen.tscn"
var _load_screen = load(_load_screen_path)
var _load_scene_resource: PackedScene
var _scene_path: String
var _progress: Array = []

var _start_time: int

var change_scene_immediately = true
var use_sub_threads: bool = true

func load_scene(scene_path: String, load_screen_path: String = "") -> void:
	_scene_path = scene_path
	if load_screen_path != null && load_screen_path.length() > 0 &&  load_screen_path != _load_screen_path:
		_load_screen_path = load_screen_path
		_load_screen = load(_load_screen_path)
	assert(get_tree().change_scene_to_packed(_load_screen) == OK)

func start_load() -> void:
	var state =  ResourceLoader.load_threaded_request(_scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)

func _process(_delta: float):
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0, 2: # THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			return
		1: # THREAD_LOAD_IN_PROGRESS
			_update_progress()
		3: # THREAD_LOAD_LOADED
			_load_scene_resource = ResourceLoader.load_threaded_get(_scene_path)
			emit_signal("progress_changed", 1.0)
			emit_signal("load_done")
			if change_scene_immediately:
				change_scene()

func change_scene() -> void:
	assert(get_tree().change_scene_to_packed(_load_scene_resource) == OK)

func _update_progress():
	emit_signal("progress_changed", _progress[0])
