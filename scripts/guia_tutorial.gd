extends CanvasLayer
## Tutorial contextual: ensina uma ação por vez, no momento em que ela é necessária,
## e mantém o objetivo atual sempre visível no canto da tela.

enum Etapa { ANDAR, PULAR, IR_AO_PAINEL, ABRIR_PAINEL, RESOLVER, ATRAVESSAR, FIM }

var neo : CharacterBody2D
var _etapa : int = Etapa.ANDAR
var _x_inicial : float = 0.0

var _caixa_dica : PanelContainer
var _label_dica : Label
var _label_objetivo : Label
var _label_aviso : Label
var _tween_aviso : Tween
var _falou_totem : bool = false
var _falou_queda : bool = false


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_montar()
	SignalBus.neo_perto_painel.connect(_on_perto_painel)
	SignalBus.abrir_painel_puzzle.connect(_on_painel_aberto)
	SignalBus.puzzle_resolvido.connect(_on_resolvido)
	SignalBus.neo_caiu.connect(_on_caiu)
	SignalBus.fragmento_coletado.connect(_on_fragmento)
	SignalBus.ponte_montada.connect(_on_ponte_montada)
	await get_tree().process_frame
	if neo:
		_x_inicial = neo.global_position.x
	_ir_para(Etapa.ANDAR)
	falar(neo, "Onde eu estou?! A ponte está em pedaços... preciso achar um jeito de atravessar.", 4.5)


func _montar() -> void:
	# Objetivo fixo (canto superior direito)
	var obj_painel := PanelContainer.new()
	var s := UiUtil.estilo_painel()
	s.set_content_margin_all(12)
	s.set_border_width_all(2)
	obj_painel.add_theme_stylebox_override("panel", s)
	obj_painel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	obj_painel.offset_left = -420
	obj_painel.offset_right = -16
	obj_painel.offset_top = 16
	add_child(obj_painel)
	var v := VBoxContainer.new()
	obj_painel.add_child(v)
	v.add_child(UiUtil.titulo("Objetivo", 16, UiUtil.COR_BORDA, false))
	_label_objetivo = UiUtil.label("", 17, UiUtil.COR_TEXTO, false)
	v.add_child(_label_objetivo)

	# Dica contextual (parte de baixo)
	_caixa_dica = PanelContainer.new()
	_caixa_dica.add_theme_stylebox_override("panel", UiUtil.estilo_painel())
	_caixa_dica.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_caixa_dica.offset_left = -330
	_caixa_dica.offset_right = 330
	_caixa_dica.offset_top = -130
	_caixa_dica.offset_bottom = -24
	add_child(_caixa_dica)
	_label_dica = UiUtil.label("", 22)
	_label_dica.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	_caixa_dica.add_child(_label_dica)

	# Aviso rápido (centro da tela)
	_label_aviso = UiUtil.label("", 26, UiUtil.COR_TITULO)
	_label_aviso.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	_label_aviso.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_label_aviso.offset_left = -400
	_label_aviso.offset_right = 400
	_label_aviso.offset_top = 150
	_label_aviso.modulate.a = 0.0
	add_child(_label_aviso)


func _process(_delta: float) -> void:
	# Não compete com o painel do puzzle nem com a tela de vitória.
	visible = not (SignalBus.puzzle_aberto or SignalBus.fase_terminada)
	if neo == null:
		return
	var balao := neo.get_node_or_null("Balao") as Control
	if balao:
		_posicionar_balao(balao)
	match _etapa:
		Etapa.ANDAR:
			if absf(neo.global_position.x - _x_inicial) > 60.0:
				_ir_para(Etapa.PULAR)
		Etapa.PULAR:
			if not neo.is_on_floor() and neo.velocity.y < 0.0:
				_mostrar_aviso("Muito bem!")
				_ir_para(Etapa.IR_AO_PAINEL)


func _ir_para(etapa: int) -> void:
	_etapa = etapa
	match etapa:
		Etapa.ANDAR:
			_set_objetivo("Explore a Planície das Frações.")
			_set_dica("Use as SETAS ou A / D para andar.")
		Etapa.PULAR:
			_set_dica("Aperte ESPAÇO ou W para pular.")
		Etapa.IR_AO_PAINEL:
			_set_objetivo("A ponte está quebrada. Encontre o totem das frações.")
			_set_dica("Ande até o totem brilhante à direita.\nPule para pegar o Fragmento no alto!")
		Etapa.ABRIR_PAINEL:
			_set_dica("Aperte E para usar o painel.")
		Etapa.RESOLVER:
			_set_objetivo("Some as frações até formar 1 inteiro.")
			_set_dica("")
		Etapa.ATRAVESSAR:
			_set_objetivo("Atravesse a ponte e entre no portal.")
			_set_dica("A ponte se uniu! Atravesse para a direita\ne entre no portal.")
		Etapa.FIM:
			_set_dica("")


func _set_objetivo(t: String) -> void:
	_label_objetivo.text = t


func _set_dica(t: String) -> void:
	_label_dica.text = t
	_caixa_dica.visible = t != ""
	if t != "":
		_caixa_dica.modulate.a = 0.0
		create_tween().tween_property(_caixa_dica, "modulate:a", 1.0, 0.35)


func _mostrar_aviso(t: String) -> void:
	_label_aviso.text = t
	if _tween_aviso:
		_tween_aviso.kill()
	_tween_aviso = create_tween()
	_tween_aviso.tween_property(_label_aviso, "modulate:a", 1.0, 0.2)
	_tween_aviso.tween_interval(1.6)
	_tween_aviso.tween_property(_label_aviso, "modulate:a", 0.0, 0.5)


func _on_perto_painel(perto: bool) -> void:
	if perto and not _falou_totem:
		_falou_totem = true
		falar(_totem(), "Totem: \"Some as frações até formar 1 inteiro e a ponte voltará a se unir.\"", 4.5, -140.0)
	if perto and _etapa in [Etapa.ANDAR, Etapa.PULAR, Etapa.IR_AO_PAINEL]:
		_ir_para(Etapa.ABRIR_PAINEL)
	elif not perto and _etapa == Etapa.ABRIR_PAINEL:
		_set_dica("Volte até o totem e aperte E.")


func _on_painel_aberto() -> void:
	if _etapa < Etapa.ATRAVESSAR:
		_ir_para(Etapa.RESOLVER)


func _on_resolvido() -> void:
	_mostrar_aviso("A ponte foi restaurada!")
	_ir_para(Etapa.ATRAVESSAR)


func _on_caiu() -> void:
	if not _falou_queda:
		_falou_queda = true
		falar(neo, "Ufa! Não dá para pular isso... preciso de outro caminho.", 3.0)
	if _etapa < Etapa.ATRAVESSAR:
		_mostrar_aviso("O abismo é fundo demais! Resolva o painel para unir a ponte.")
	else:
		_mostrar_aviso("Opa! Tente de novo, a ponte está logo ali.")


func _on_fragmento() -> void:
	_mostrar_aviso("Fragmento de Conhecimento! (%d/%d)" % [SignalBus.fragmentos_coletados, SignalBus.TOTAL_FRAGMENTOS])


# ---------- Falas curtas (balões no cenário) ----------

func falar(alvo: Node2D, texto: String, duracao: float = 3.5, altura: float = -95.0) -> void:
	if alvo == null:
		return
	var antigo := alvo.get_node_or_null("Balao")
	if antigo:
		antigo.queue_free()
	var balao := PanelContainer.new()
	balao.name = "Balao"
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.97, 0.98, 0.95, 0.96)
	s.border_color = Color(0.1, 0.3, 0.25)
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	s.set_content_margin_all(8)
	balao.add_theme_stylebox_override("panel", s)
	var l := Label.new()
	l.text = texto
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(240, 0)
	l.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	l.add_theme_font_size_override("font_size", 14)
	l.add_theme_color_override("font_color", Color(0.08, 0.15, 0.13))
	balao.add_child(l)
	balao.z_index = 50
	balao.process_mode = Node.PROCESS_MODE_ALWAYS
	alvo.add_child(balao)
	balao.reset_size()
	balao.set_meta("altura", altura)
	_posicionar_balao(balao)
	balao.modulate.a = 0.0
	var t := balao.create_tween()
	t.tween_property(balao, "modulate:a", 1.0, 0.25)
	t.tween_interval(duracao)
	t.tween_property(balao, "modulate:a", 0.0, 0.4)
	t.tween_callback(balao.queue_free)


func _posicionar_balao(balao: Control) -> void:
	# Centraliza sobre o personagem, mas mantém o balão inteiro dentro da tela.
	var alvo := balao.get_parent() as Node2D
	var altura : float = balao.get_meta("altura", -95.0)
	balao.position = Vector2(-balao.size.x / 2.0, altura - balao.size.y)
	var gx : float = alvo.global_position.x + balao.position.x
	var largura_tela : float = get_viewport().get_visible_rect().size.x
	balao.position.x += clampf(gx, 8.0, largura_tela - balao.size.x - 8.0) - gx


func _totem() -> Node2D:
	return get_parent().get_node_or_null("PainelPuzzle")


func _on_ponte_montada() -> void:
	falar(neo, "Deu certo! 1/4 + 1/2 + 1/4 = 1. A matemática virou caminho!", 3.5)
