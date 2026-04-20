extends Node

@warning_ignore_start("unused_signal")
signal camera_reset
signal camera_centered(node: Node3D)

signal planet_discovered(planet: Planet)
signal planet_beamed(planet: Planet)
signal planet_unlocked(planet: Planet)
signal planet_selected(planet: Planet)

signal satellite_activated(sat: Satellite)
signal satellite_selected(idx: int)

signal hack
signal ping
signal scan
signal beam
signal soothe

signal time_scale_set(scale: float)

signal timer_expired
signal mother_soothed

@warning_ignore_restore("unused_signal")
