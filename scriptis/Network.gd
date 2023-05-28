extends Node

@export var sync_position: Vector3:
	set(value):
		sync_position = value
		processed_position = false
@export var sync_moution_velocity: Vector3

@export var processed_position: bool
