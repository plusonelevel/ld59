extends Control

func init(sat: Satellite):
	name = sat.name
	$Locked.hide()
	$Unlocked.show()
	if sat.activated:
		$Unlocked/Online.show()
		$Unlocked/Offline.hide()
	else:
		$Unlocked/Online.hide()
		$Unlocked/Offline.show()
