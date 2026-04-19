extends Node

@warning_ignore_start("unused_signal")
signal camera_reset
signal camera_centered(node: Node3D)

signal planet_selected
signal satellite_selected(idx: int)

signal orbit_rotated(dir: Enums.RotateDirection)

@warning_ignore_restore("unused_signal")
