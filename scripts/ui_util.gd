class_name UiUtil
extends RefCounted
## Funções auxiliares para montar a interface por código com um visual único.

const COR_FUNDO   : Color = Color(0.05, 0.12, 0.10, 0.92)
const COR_BORDA   : Color = Color(0.35, 0.95, 0.75, 1.0)
const COR_TITULO  : Color = Color(1.0, 0.92, 0.45, 1.0)
const COR_TEXTO   : Color = Color(0.92, 0.97, 0.95, 1.0)

const FONTE_TITULO : FontFile = preload("res://assets/fonts/CinzelDecorative-Bold.ttf")
const FONTE_SUBTIT : FontFile = preload("res://assets/fonts/Cinzel-Bold.ttf")
const FONTE_NEGRITO: FontFile = preload("res://assets/fonts/Nunito-Bold.ttf")


static func estilo_painel() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = COR_FUNDO
	s.border_color = COR_BORDA
	s.set_border_width_all(3)
	s.set_corner_radius_all(14)
	s.set_content_margin_all(26)
	s.shadow_color = Color(0, 0, 0, 0.5)
	s.shadow_size = 10
	return s


static func estilo_botao(cor: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = cor
	s.set_corner_radius_all(10)
	s.set_content_margin_all(10)
	s.border_color = Color(1, 1, 1, 0.25)
	s.set_border_width_all(2)
	return s


static func botao(texto: String, tamanho_fonte: int = 22, largura: float = 280.0) -> Button:
	var b := Button.new()
	b.text = texto
	b.custom_minimum_size = Vector2(largura, 56)
	b.add_theme_font_size_override("font_size", tamanho_fonte)
	b.add_theme_stylebox_override("normal", estilo_botao(Color(0.10, 0.35, 0.28)))
	b.add_theme_stylebox_override("hover", estilo_botao(Color(0.16, 0.52, 0.40)))
	b.add_theme_stylebox_override("pressed", estilo_botao(Color(0.08, 0.25, 0.20)))
	b.add_theme_stylebox_override("focus", estilo_botao(Color(0.16, 0.52, 0.40)))
	b.add_theme_color_override("font_color", COR_TEXTO)
	b.add_theme_font_override("font", FONTE_NEGRITO)
	b.focus_mode = Control.FOCUS_ALL
	return b


static func titulo(texto: String, tamanho: int = 40, cor: Color = COR_TITULO, decorativa: bool = true) -> Label:
	var l := label(texto, tamanho, cor)
	l.add_theme_font_override("font", FONTE_TITULO if decorativa else FONTE_SUBTIT)
	l.add_theme_constant_override("outline_size", 8)
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	return l


static func label(texto: String, tamanho: int = 18, cor: Color = COR_TEXTO, centralizado: bool = true) -> Label:
	var l := Label.new()
	l.text = texto
	l.add_theme_font_size_override("font_size", tamanho)
	l.add_theme_color_override("font_color", cor)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 4)
	if centralizado:
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l


static func texto_como_jogar() -> String:
	return """OBJETIVO
Reconstrua a ponte quebrada somando frações e leve o Neo até o portal.

CONTROLES
Setas esquerda/direita ou A / D — andar
Espaço, W ou seta para cima — pular
E — usar o painel de frações (chegue perto dele)
Esc ou P — pausar e abrir esta ajuda
Mouse — clicar nos botões

O DESAFIO
No painel, escolha 3 frações cuja soma seja exatamente 1 inteiro.
A barra mostra quanto a soma já vale. A ordem não importa.
Travou? Use o botão Dica.

LEMBRE
• Cair no abismo só leva o Neo de volta ao início. Não há game over.
• Colete os 3 Fragmentos de Conhecimento para ganhar a medalha de ouro."""
