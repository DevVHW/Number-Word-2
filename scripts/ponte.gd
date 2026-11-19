extends Node2D

@onready var fragmento_a : StaticBody2D = $FragmentoA
@onready var fragmento_b : StaticBody2D = $FragmentoB
@onready var fragmento_c : StaticBody2D = $FragmentoC

const POS_FINAL_A   : Vector2 = Vector2(0,   0)
const POS_FINAL_B   : Vector2 = Vector2(96,  0)
const POS_FINAL_C   : Vector2 = Vector2(288, 0)

const POS_INICIAL_A : Vector2 = Vector2(0,   40)
const POS_INICIAL_B : Vector2 = Vector2(96,  80)
const POS_INICIAL_C : Vector2 = Vector2(288, 40)

const DURACAO_ANIMACAO : float = 1.2


func _ready() -> void:
	fragmento_a.position = POS_INICIAL_A
	fragmento_b.position = POS_INICIAL_B
	fragmento_c.position = POS_INICIAL_C
	_definir_colisao(false)
	SignalBus.puzzle_resolvido.connect(_animar_ponte_unindo)


func _definir_colisao(ativo: bool) -> void:
	var modo : int = Node.PROCESS_MODE_INHERIT if ativo else Node.PROCESS_MODE_DISABLED
	for fragmento in [fragmento_a, fragmento_b, fragmento_c]:
		fragmento.set_deferred("process_mode", modo)


func _animar_ponte_unindo() -> void:
	var som := AudioStreamPlayer.new()
	som.stream = load("res://assets/audio/encaixe.wav")
	add_child(som)
	var pecas := [[fragmento_a, POS_FINAL_A], [fragmento_b, POS_FINAL_B], [fragmento_c, POS_FINAL_C]]
	for i in pecas.size():
		var peca : StaticBody2D = pecas[i][0]
		var tween : Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BACK)
		tween.tween_property(peca, "position", pecas[i][1], DURACAO_ANIMACAO / 2.0)
		await tween.finished
		som.pitch_scale = 1.0 + i * 0.15
		som.play()
		peca.modulate = Color(1.0, 0.95, 0.4)
		var brilho := create_tween()
		brilho.tween_property(peca, "scale", Vector2(1.08, 1.25), 0.08)
		brilho.tween_property(peca, "scale", Vector2.ONE, 0.12)
		await get_tree().create_timer(0.15).timeout
	_definir_colisao(true)
	SignalBus.ponte_montada.emit()
