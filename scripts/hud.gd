extends CanvasLayer

@onready var label_fragmentos : Label = $MarginContainer/VBox/LabelFragmentos


func _ready() -> void:
	label_fragmentos.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	label_fragmentos.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	label_fragmentos.add_theme_constant_override("outline_size", 5)
	SignalBus.fragmento_coletado.connect(_on_fragmento_coletado)
	_atualizar_label()


func _on_fragmento_coletado() -> void:
	_atualizar_label()
	var t := create_tween()
	t.tween_property(label_fragmentos, "scale", Vector2(1.15, 1.15), 0.1)
	t.tween_property(label_fragmentos, "scale", Vector2.ONE, 0.15)


func _atualizar_label() -> void:
	label_fragmentos.text = "Fragmentos de Conhecimento: %d/%d" % [SignalBus.fragmentos_coletados, SignalBus.TOTAL_FRAGMENTOS]
