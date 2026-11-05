extends Area2D

@onready var sprite_portal   : Sprite2D    = $SpritePortal
@onready var canvas_parabens : CanvasLayer = $CanvasLayerParabens
@onready var painel_parabens : Control     = $CanvasLayerParabens/PainelParabens
@onready var botao_reiniciar : Button      = $CanvasLayerParabens/PainelParabens/VBox/BotaoReiniciar

var _ativo : bool = false


func _ready() -> void:
	visible = false
	modulate.a = 0.0
	canvas_parabens.process_mode = Node.PROCESS_MODE_ALWAYS
	painel_parabens.process_mode = Node.PROCESS_MODE_ALWAYS
	painel_parabens.visible = false
	SignalBus.puzzle_resolvido.connect(_ativar_portal)
	body_entered.connect(_on_neo_entrou)
	botao_reiniciar.pressed.connect(_reiniciar_fase)


func _ativar_portal() -> void:
	visible = true
	_ativo  = true
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.8)
	tween.tween_property(sprite_portal, "scale", sprite_portal.scale * 1.1, 0.4)
	await tween.finished
	_iniciar_pulso()


func _iniciar_pulso() -> void:
	var base : Vector2 = sprite_portal.scale
	var tween : Tween = create_tween()
	tween.set_loops()
	tween.tween_property(sprite_portal, "scale", base * 1.12, 0.5)
	tween.tween_property(sprite_portal, "scale", base, 0.5)


func _on_neo_entrou(body: Node2D) -> void:
	if not _ativo:
		return
	if not body.is_class("CharacterBody2D"):
		return
	_ativo = false
	get_tree().paused = true
	painel_parabens.visible = true
	SignalBus.fase_concluida.emit()


func _reiniciar_fase() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
