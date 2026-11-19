extends Area2D

@onready var sprite_portal   : Sprite2D    = $SpritePortal
@onready var canvas_parabens : CanvasLayer = $CanvasLayerParabens
@onready var painel_parabens : Control     = $CanvasLayerParabens/PainelParabens
@onready var botao_reiniciar : Button      = $CanvasLayerParabens/PainelParabens/VBox/BotaoReiniciar

var _ativo : bool = false
var _label_resumo : Label
var _som_vitoria : AudioStreamPlayer


func _ready() -> void:
	visible = false
	modulate.a = 0.0
	canvas_parabens.process_mode = Node.PROCESS_MODE_ALWAYS
	painel_parabens.process_mode = Node.PROCESS_MODE_ALWAYS
	painel_parabens.visible = false
	SignalBus.puzzle_resolvido.connect(_ativar_portal)
	body_entered.connect(_on_neo_entrou)
	botao_reiniciar.pressed.connect(_reiniciar_fase)
	_montar_extras()


func _montar_extras() -> void:
	painel_parabens.add_theme_stylebox_override("panel", UiUtil.estilo_painel())
	var vb : VBoxContainer = $CanvasLayerParabens/PainelParabens/VBox
	var trofeu : Label = vb.get_node("LabelTrofeu")
	trofeu.add_theme_font_override("font", UiUtil.FONTE_SUBTIT)
	trofeu.add_theme_font_size_override("font_size", 34)
	var parabens : Label = vb.get_node("LabelParabens")
	parabens.add_theme_font_override("font", UiUtil.FONTE_TITULO)
	parabens.add_theme_font_size_override("font_size", 30)
	parabens.add_theme_color_override("font_color", UiUtil.COR_TITULO)
	_label_resumo = UiUtil.label("", 16, UiUtil.COR_TEXTO)
	vb.add_child(_label_resumo)
	vb.move_child(_label_resumo, botao_reiniciar.get_index())
	var stl := UiUtil.botao("x")
	for estado in ["normal", "hover", "pressed", "focus"]:
		botao_reiniciar.add_theme_stylebox_override(estado, stl.get_theme_stylebox(estado))
	botao_reiniciar.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	stl.queue_free()
	var btn_menu := UiUtil.botao("Voltar ao menu", 18)
	btn_menu.custom_minimum_size.y = 52
	btn_menu.pressed.connect(_voltar_menu)
	vb.add_child(btn_menu)
	_som_vitoria = AudioStreamPlayer.new()
	_som_vitoria.stream = load("res://assets/audio/acerto.wav")
	_som_vitoria.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_som_vitoria)


func _voltar_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MenuPrincipal.tscn")


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
	SignalBus.fase_terminada = true
	get_tree().paused = true
	_preencher_resultado()
	painel_parabens.visible = true
	_som_vitoria.play()
	botao_reiniciar.call_deferred("grab_focus")
	SignalBus.fase_concluida.emit()


func _preencher_resultado() -> void:
	var frag : int = SignalBus.fragmentos_coletados
	var medalha : String
	var cor : Color
	if frag >= SignalBus.TOTAL_FRAGMENTOS:
		medalha = "Medalha de Ouro"
		cor = Color(1.0, 0.84, 0.2)
	elif frag >= 1:
		medalha = "Medalha de Prata"
		cor = Color(0.82, 0.86, 0.9)
	else:
		medalha = "Medalha de Bronze"
		cor = Color(0.85, 0.55, 0.3)
	$CanvasLayerParabens/PainelParabens/VBox/LabelTrofeu.text = medalha
	$CanvasLayerParabens/PainelParabens/VBox/LabelTrofeu.add_theme_color_override("font_color", cor)
	var seg : int = int(SignalBus.tempo_fase)
	var resumo := "Fragmentos: %d/%d   •   Tempo: %d:%02d   •   Tentativas erradas: %d" % [
		frag, SignalBus.TOTAL_FRAGMENTOS, seg / 60, seg % 60, SignalBus.tentativas_erradas]
	_label_resumo.text = resumo
	if frag < SignalBus.TOTAL_FRAGMENTOS:
		_label_resumo.text += "\nColete os %d fragmentos para conseguir o ouro!" % SignalBus.TOTAL_FRAGMENTOS


func _reiniciar_fase() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
