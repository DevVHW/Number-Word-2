extends Control
## Abertura narrativa: apresenta o mundo, o conflito e a missão do Neo.

const CENA_FASE : String = "res://scenes/PlanieDasFracoes.tscn"
const PATH_BG   : String = "res://assets/backgrounds/planicie_fracoes_bg.png"
const PATH_NEO  : String = "res://assets/sprites/neo_spritesheet-removebg-preview.png"
const PATH_MUSICA : String = "res://assets/audio/musica_loop.wav"
const PATH_CLIQUE : String = "res://assets/audio/clique.wav"

const CENAS : Array = [
	{ "titulo": "Numbers World", "texto": "Era uma vez um reino de lógica pura. Cada ponte, cada rio e cada caminho seguia as regras da matemática.", "escuro": 0.45 },
	{ "titulo": "O Caos Numérico", "texto": "Até que surgiu o Caos Numérico. Ele embaralhou os cálculos e partiu as pontes da Planície das Frações em pedaços.", "escuro": 0.75 },
	{ "titulo": "Neo", "texto": "Neo é um estudante que foi puxado para dentro deste mundo. Para voltar para casa, ele precisa devolver o equilíbrio ao reino.", "escuro": 0.55, "neo": true },
	{ "titulo": "A missão", "texto": "Cada pedaço da ponte guarda uma fração. Só quem entender como as frações se somam conseguirá unir a ponte de novo e chegar ao portal.", "escuro": 0.5, "neo": true },
]

var _indice : int = 0
var _escurecer : ColorRect
var _titulo : Label
var _texto : Label
var _neo : TextureRect
var _aviso : Label
var _clique : AudioStreamPlayer
var _tween : Tween


func _ready() -> void:
	var fundo := TextureRect.new()
	fundo.texture = load(PATH_BG)
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fundo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(fundo)

	_escurecer = ColorRect.new()
	_escurecer.color = Color(0, 0, 0, 0.5)
	_escurecer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_escurecer)

	# Recorte do primeiro quadro do sprite sheet do Neo (4 colunas x 4 linhas).
	var tex : Texture2D = load(PATH_NEO)
	var atlas := AtlasTexture.new()
	atlas.atlas = tex
	atlas.region = Rect2(0, 0, tex.get_width() / 4.0, tex.get_height() / 4.0)
	_neo = TextureRect.new()
	_neo.texture = atlas
	_neo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_neo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_neo.size = Vector2(220, 220)
	_neo.position = Vector2(530, 150)
	_neo.modulate.a = 0.0
	add_child(_neo)

	var caixa := VBoxContainer.new()
	caixa.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	caixa.offset_top = -300
	caixa.offset_bottom = -60
	caixa.offset_left = 140
	caixa.offset_right = -140
	caixa.add_theme_constant_override("separation", 18)
	add_child(caixa)

	_titulo = UiUtil.titulo("", 44)
	caixa.add_child(_titulo)
	_texto = UiUtil.label("", 26)
	caixa.add_child(_texto)

	_aviso = UiUtil.label("Enter, Espaço ou clique: continuar   •   Esc: pular história", 15, Color(0.8, 0.9, 0.85))
	_aviso.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_aviso.offset_top = -40
	_aviso.offset_bottom = -12
	add_child(_aviso)

	var musica := AudioStreamPlayer.new()
	musica.stream = load(PATH_MUSICA)
	musica.volume_db = -8.0
	add_child(musica)
	musica.play()
	_clique = AudioStreamPlayer.new()
	_clique.stream = load(PATH_CLIQUE)
	add_child(_clique)

	_mostrar_cena()


func _mostrar_cena() -> void:
	var c : Dictionary = CENAS[_indice]
	_titulo.text = c.titulo
	_texto.text = c.texto
	_texto.visible_ratio = 0.0
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true)
	_tween.tween_property(_texto, "visible_ratio", 1.0, c.texto.length() * 0.03)
	_tween.tween_property(_escurecer, "color:a", c.escuro, 0.8)
	_tween.tween_property(_neo, "modulate:a", 1.0 if c.get("neo", false) else 0.0, 0.8)


func _avancar() -> void:
	_clique.play()
	if _texto.visible_ratio < 1.0:
		_tween.kill()
		_texto.visible_ratio = 1.0
		return
	_indice += 1
	if _indice >= CENAS.size():
		_ir_para_fase()
	else:
		_mostrar_cena()


func _ir_para_fase() -> void:
	set_process_unhandled_input(false)
	get_tree().change_scene_to_file(CENA_FASE)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausar"):
		_ir_para_fase()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("pular") \
			or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_avancar()
		get_viewport().set_input_as_handled()
