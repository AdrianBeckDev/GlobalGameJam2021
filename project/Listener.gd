extends Listener


func _process(_delta):
	self.global_transform.basis = get_viewport().get_camera().global_transform.basis
