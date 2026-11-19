extends Control
## Menu inicial: Jogar, Como Jogar, Créditos e Sair.

const CENA_FASE   : String = "res://scenes/Intro.tscn"
const PATH_BG     : String = "res://assets/backgrounds/planicie_fracoes_bg.png"
const PATH_MUSICA : String = "res://assets/audio/musica_loop.wav"
const PATH_CLIQUE : String = "res://assets/audio/clique.wav"

var _painel_principal : VBoxContainer
var _painel_info      : PanelContainer
var _label_info       : Label
var _titulo_info      : Label
var _som_clique       : AudioStreamPlayer


func _ready() -> void:
	get_tree().paused = false
	_montar_fundo()
	_montar_menu()
	_montar_painel_info()
	_montar_audio()


func _montar_fundo() -> void:
	var fundo := TextureRect.new()
	fundo.texture = load(PATH_BG)
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fundo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(fundo)
	var escurecer := ColorRect.new()
	escurecer.color = Color(0, 0.05, 0.04, 0.55)
	escurecer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(escurecer)


func _montar_menu() -> void:
	var centro := CenterContainer.new()
	centro.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(centro)

	_painel_principal = VBoxContainer.new()
	_painel_principal.add_theme_constant_override("separation", 16)
	centro.add_child(_painel_principal)

	var titulo := UiUtil.titulo("Numbers World 2", 68)
	_painel_principal.add_child(titulo)
	_painel_principal.add_child(UiUtil.titulo("Mundo 1 · Planície das Frações", 26, UiUtil.COR_BORDA, false))
	var desc := UiUtil.label("Ajude o Neo a reconstruir a ponte usando soma de frações.", 20)
	desc.custom_minimum_size = Vector2(700, 0)
	_painel_principal.add_child(desc)

	var espaco := Control.new()
	espaco.custom_minimum_size = Vector2(0, 18)
	_painel_principal.add_child(espaco)

	var botoes := [
		["Jogar", _on_jogar],
		["Como Jogar", _on_como_jogar],
		["Créditos", _on_creditos],
		["Sair", _on_sair],
	]
	var primeiro : Button = null
	for item in botoes:
		var b := UiUtil.botao(item[0])
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pressed.connect(item[1])
		_painel_principal.add_child(b)
		if primeiro == null:
			primeiro = b
	# No navegador não existe "Sair": o botão é ocultado.
	if OS.has_feature("web"):
		_painel_principal.get_child(_painel_principal.get_child_count() - 1).visible = false
	primeiro.call_deferred("grab_focus")

	var rodape := UiUtil.label("Enter/Espaço para escolher  •  Setas para navegar", 14, Color(0.8, 0.85, 0.85))
	_painel_principal.add_child(rodape)


func _montar_painel_info() -> void:
	var centro := CenterContainer.new()
	centro.set_anchors_preset(Control.PRESET_FULL_RECT)
	centro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(centro)

	_painel_info = PanelContainer.new()
	_painel_info.add_theme_stylebox_override("panel", UiUtil.estilo_painel())
	_painel_info.custom_minimum_size = Vector2(800, 0)
	_painel_info.visible = false
	centro.add_child(_painel_info)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	_painel_info.add_child(vbox)

	_titulo_info = UiUtil.titulo("", 30, UiUtil.COR_TITULO, false)
	vbox.add_child(_titulo_info)
	_label_info = UiUtil.label("", 18, UiUtil.COR_TEXTO, false)
	_label_info.custom_minimum_size = Vector2(740, 0)
	vbox.add_child(_label_info)

	var voltar := UiUtil.botao("Voltar", 20, 200)
	voltar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	voltar.pressed.connect(_fechar_info)
	vbox.add_child(voltar)


func _montar_audio() -> void:
	var musica := AudioStreamPlayer.new()
	musica.stream = load(PATH_MUSICA)
	musica.volume_db = -6.0
	add_child(musica)
	musica.play()
	_som_clique = AudioStreamPlayer.new()
	_som_clique.stream = load(PATH_CLIQUE)
	add_child(_som_clique)


func _mostrar_info(titulo: String, texto: String) -> void:
	_som_clique.play()
	_titulo_info.text = titulo
	_label_info.text = texto
	_painel_principal.visible = false
	_painel_info.visible = true
	_painel_info.get_child(0).get_child(2).call_deferred("grab_focus")


func _fechar_info() -> void:
	_som_clique.play()
	_painel_info.visible = false
	_painel_principal.visible = true
	_painel_principal.get_child(4).call_deferred("grab_focus")


func _unhandled_input(event: InputEvent) -> void:
	if _painel_info.visible and event.is_action_pressed("pausar"):
		_fechar_info()
		get_viewport().set_input_as_handled()


func _on_jogar() -> void:
	_som_clique.play()
	SignalBus.reiniciar_estado()
	get_tree().change_scene_to_file(CENA_FASE)


func _on_como_jogar() -> void:
	_mostrar_info("Como Jogar", UiUtil.texto_como_jogar())


func _on_creditos() -> void:
	_mostrar_info("Créditos", """Numbers World 2 — Planície das Frações
Jogo educativo de matemática para o Ensino Médio

Equipe
Guilherme Vieira Wesolowski
João Henrique Ramos de Souza
José Antonio Voss
Victhor Hugo Wandersee Rodrigues Philippe

Orientação: Prof. Diego Sauter Possamai
Engenharia de Software — PAC Extensionista
Católica de Santa Catarina — Joinville

Feito com Godot Engine 4.6""")


func _on_sair() -> void:
	get_tree().quit()
