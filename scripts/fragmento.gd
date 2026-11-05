class_name Fragmento extends Area2D

@onready var audio_coleta: AudioStreamPlayer2D = $AudioColeta
@onready var sprite: Sprite2D = $Sprite2D

var _base_y: float = 0.0
var _tempo: float = 0.0


func _ready() -> void:
	_base_y = position.y
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	_tempo += delta * 2.5
	position.y = _base_y + sin(_tempo) * 5.0


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Neo":
		SignalBus.fragmento_coletado.emit()
		
		set_deferred("monitoring", false)
		sprite.visible = false
		audio_coleta.play()
		
		await get_tree().create_timer(1.0, false).timeout
		queue_free()
