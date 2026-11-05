extends Node2D

@onready var neo : CharacterBody2D = $Neo

const SPAWN_NEO : Vector2 = Vector2(150, 430)

const PATH_BG     : String = "res://assets/backgrounds/planicie_fracoes_bg.png"
const PATH_NEO    : String = "res://assets/sprites/neo_spritesheet.png"
const PATH_PAINEL : String = "res://assets/sprites/painel_interativo.png"
const PATH_PORTAL : String = "res://assets/sprites/portal_fase.png"


func _ready() -> void:
	_carregar_todos_visuais()
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
		neo.velocity = Vector2.ZERO
		neo.position = SPAWN_NEO


func _on_puzzle_resolvido() -> void:
	pass


func _on_fase_concluida() -> void:
	pass
