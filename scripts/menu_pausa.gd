extends CanvasLayer
## Menu de pausa global (autoload "Pausa"). Abre com Esc ou P durante a fase.

const CENA_MENU : String = "res://scenes/MenuPrincipal.tscn"

var _fundo       : ColorRect
var _painel      : PanelContainer
var _ajuda       : Label
var _slider_vol  : HSlider
var _label_vol   : Label
var _btn_continuar : Button


func _ready() -> void:
	layer = 50
	process_mode = Node.PROCESS_MODE_ALWAYS
	_montar()
	_definir_visivel(false)


func _montar() -> void:
	_fundo = ColorRect.new()
	_fundo.color = Color(0, 0, 0, 0.6)
	_fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_fundo)

	var centro := CenterContainer.new()
	centro.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fundo.add_child(centro)

	_painel = PanelContainer.new()
	_painel.add_theme_stylebox_override("panel", UiUtil.estilo_painel())
	_painel.custom_minimum_size = Vector2(520, 0)
	centro.add_child(_painel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	_painel.add_child(vbox)

	vbox.add_child(UiUtil.titulo("Pausa", 38))

	_btn_continuar = UiUtil.botao("Continuar")
	_btn_continuar.pressed.connect(fechar)
	vbox.add_child(_btn_continuar)

	var btn_ajuda := UiUtil.botao("Como Jogar")
	btn_ajuda.pressed.connect(func(): _ajuda.visible = not _ajuda.visible)
	vbox.add_child(btn_ajuda)

	_ajuda = UiUtil.label(UiUtil.texto_como_jogar(), 14, UiUtil.COR_TEXTO, false)
	_ajuda.custom_minimum_size = Vector2(600, 0)
	_ajuda.visible = false
	vbox.add_child(_ajuda)

	_label_vol = UiUtil.label("Volume: 100%", 18)
	vbox.add_child(_label_vol)
	_slider_vol = HSlider.new()
	_slider_vol.min_value = 0
	_slider_vol.max_value = 100
	_slider_vol.step = 5
	_slider_vol.value = 100
	_slider_vol.custom_minimum_size = Vector2(0, 28)
	_slider_vol.value_changed.connect(_on_volume)
	vbox.add_child(_slider_vol)

	var btn_reiniciar := UiUtil.botao("Reiniciar fase")
	btn_reiniciar.pressed.connect(_reiniciar)
	vbox.add_child(btn_reiniciar)

	var btn_menu := UiUtil.botao("Voltar ao menu")
	btn_menu.pressed.connect(_voltar_menu)
	vbox.add_child(btn_menu)


func _on_volume(valor: float) -> void:
	_label_vol.text = "Volume: %d%%" % int(valor)
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, valor <= 0.0)
	AudioServer.set_bus_volume_db(bus, linear_to_db(max(valor, 1.0) / 100.0))


func _na_fase() -> bool:
	var cena := get_tree().current_scene
	return cena != null and cena.name == "PlanieDasFracoes"


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("pausar"):
		return
	if _fundo.visible:
		fechar()
		get_viewport().set_input_as_handled()
	elif _na_fase() and not SignalBus.puzzle_aberto and not SignalBus.fase_terminada and not get_tree().paused:
		abrir()
		get_viewport().set_input_as_handled()


func abrir() -> void:
	_definir_visivel(true)
	get_tree().paused = true
	_btn_continuar.call_deferred("grab_focus")


func fechar() -> void:
	_definir_visivel(false)
	get_tree().paused = false


func _definir_visivel(v: bool) -> void:
	_fundo.visible = v
	if not v and _ajuda:
		_ajuda.visible = false


func _reiniciar() -> void:
	fechar()
	SignalBus.reiniciar_estado()
	get_tree().reload_current_scene()


func _voltar_menu() -> void:
	fechar()
	get_tree().change_scene_to_file(CENA_MENU)
