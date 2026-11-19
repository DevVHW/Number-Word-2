extends Node2D

@onready var neo : CharacterBody2D = $Neo

const SPAWN_NEO : Vector2 = Vector2(150, 430)
const PAREDE_ESQ_X : float = -20.0
const PAREDE_DIR_X : float = 1220.0
const LIMITE_QUEDA_Y : float = 700.0

const PATH_BG     : String = "res://assets/backgrounds/planicie_fracoes_bg.png"
const PATH_NEO    : String = "res://assets/sprites/neo_spritesheet.png"
const PATH_PAINEL : String = "res://assets/sprites/painel_interativo.png"
const PATH_PORTAL : String = "res://assets/sprites/portal_fase.png"


func _ready() -> void:
	get_tree().paused = false
	SignalBus.reiniciar_estado()
	_carregar_todos_visuais()
	_criar_paredes_laterais()
	var guia := preload("res://scripts/guia_tutorial.gd").new()
	guia.neo = neo
	add_child(guia)
	$Abismo.body_entered.connect(_on_abismo_body_entered)
	SignalBus.puzzle_resolvido.connect(_on_puzzle_resolvido)
	SignalBus.fase_concluida.connect(_on_fase_concluida)


func _carregar_todos_visuais() -> void:
	_aplicar_background()
	_aplicar_sprite_neo()
	_aplicar_sprite_painel()
	_aplicar_sprite_portal()
	$Ponte/Sprite2D.visible = false


func _aplicar_background() -> void:
	var tex : Texture2D = _carregar_textura(PATH_BG)
	if not tex:
		return
	var spr : Sprite2D = $ParallaxBackground/ParallaxLayer/Fundo
	spr.texture = tex
	var sx : float = 1280.0 / float(tex.get_width())
	var sy : float = 720.0  / float(tex.get_height())
	spr.scale = Vector2(max(sx, sy), max(sx, sy))


func _aplicar_sprite_neo() -> void:
	var tex : Texture2D = _carregar_textura(PATH_NEO)
	if not tex:
		return
	var spr : Sprite2D = $Neo/Sprite2D
	spr.texture = tex
	spr.hframes = 4
	spr.vframes = 2
	spr.frame   = 0
	var frame_h : float = float(tex.get_height()) / 2.0
	var escala  : float = 64.0 / frame_h
	spr.scale    = Vector2(escala, escala)
	spr.position = Vector2(0, -8)


func _aplicar_sprite_painel() -> void:
	var tex : Texture2D = _carregar_textura(PATH_PAINEL)
	if not tex:
		return
	var spr : Sprite2D = $PainelPuzzle/Sprite2D
	spr.texture  = tex
	spr.scale    = Vector2(56.0 / float(tex.get_width()), 80.0 / float(tex.get_height()))
	spr.position = Vector2(0, -40)


func _aplicar_sprite_portal() -> void:
	var tex : Texture2D = _carregar_textura(PATH_PORTAL)
	if not tex:
		return
	var spr : Sprite2D = $Portal/SpritePortal
	spr.texture = tex
	spr.scale   = Vector2(36.0 / float(tex.get_width()), 64.0 / float(tex.get_height()))
	spr.position = Vector2(0, -32)


func _carregar_textura(caminho: String) -> Texture2D:
	if not ResourceLoader.exists(caminho):
		return null
	return load(caminho) as Texture2D


func _on_abismo_body_entered(body: Node2D) -> void:
	if body == neo:
		_respawn()


func _respawn() -> void:
	neo.velocity = Vector2.ZERO
	neo.position = SPAWN_NEO
	SignalBus.neo_caiu.emit()


func _process(delta: float) -> void:
	if not SignalBus.fase_terminada:
		SignalBus.tempo_fase += delta
	# Rede de segurança: se Neo sair da área da fase por qualquer lado, volta ao início.
	if neo.global_position.y > LIMITE_QUEDA_Y:
		_respawn()


func _criar_paredes_laterais() -> void:
	# Bordas esquerda e direita da fase: Neo não consegue sair da tela.
	for x in [PAREDE_ESQ_X, PAREDE_DIR_X]:
		var parede := StaticBody2D.new()
		var forma := CollisionShape2D.new()
		var ret := RectangleShape2D.new()
		ret.size = Vector2(40, 1600)
		forma.shape = ret
		parede.position = Vector2(x, 0)
		parede.add_child(forma)
		add_child(parede)


func _on_puzzle_resolvido() -> void:
	# As frações aparecem sobre cada pedaço da ponte: 1/4 + 1/2 + 1/4.
	for nome in ["FragmentoA", "FragmentoB", "FragmentoC"]:
		var l : Label = get_node("Ponte/%s/Label" % nome)
		var r : ColorRect = get_node("Ponte/%s/ColorRect" % nome)
		l.position = Vector2((r.offset_left + r.offset_right) / 2.0 - 14.0, r.offset_top - 30.0)
		l.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
		l.add_theme_font_size_override("font_size", 20)
		l.add_theme_color_override("font_color", UiUtil.COR_TITULO)
		l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		l.add_theme_constant_override("outline_size", 5)
		l.visible = true


func _on_fase_concluida() -> void:
	pass
