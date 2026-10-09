extends Label

func _ready() -> void:
	# Set a fixed size
	custom_minimum_size = Vector2(200, 50)
	
	# Clip extra text so the box never resizes
	text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	
	# Center align text within the fixed bounds
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
