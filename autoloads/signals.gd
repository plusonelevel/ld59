extends Node

@warning_ignore_start("unused_signal")
signal camera_reset
signal camera_centered(node: Node3D)

signal planet_selected(planet: Node3D)
signal satellite_selected(idx: int)

signal hack
signal ping
signal scan
signal beam

signal time_scale_set(scale: float)

@warning_ignore_restore("unused_signal")
