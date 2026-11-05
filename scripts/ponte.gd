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
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(fragmento_a, "position", POS_FINAL_A, DURACAO_ANIMACAO)
	tween.tween_property(fragmento_b, "position", POS_FINAL_B, DURACAO_ANIMACAO)
	tween.tween_property(fragmento_c, "position", POS_FINAL_C, DURACAO_ANIMACAO)
	await tween.finished
	_definir_colisao(true)
	for fragmento in [fragmento_a, fragmento_b, fragmento_c]:
		fragmento.modulate = Color(1.0, 0.95, 0.4)