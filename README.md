# Numbers World 2 — Protótipo "Planície das Frações"

Jogo de plataforma 2D educativo, feito na **Godot Engine**, em que o jogador controla o personagem **Neo** e usa **soma de frações** para reconstruir uma ponte quebrada e chegar ao portal da próxima fase.

Esta versão é um **protótipo jogável com uma única fase**: a *Planície das Frações*, agora com menu inicial, abertura narrativa, tutorial dentro do jogo, menu de pausa com volume, sons de acerto/erro e novas fontes. As mudanças desta versão estão em [`docs/MELHORIAS.md`](docs/MELHORIAS.md).

| | |
|---|---|
| **Equipe** | Guilherme Vieira Wesolowski, João Henrique Ramos de Souza, José Antonio Voss e Victhor Hugo Wandersee Rodrigues Philippe |
| **Curso / Disciplina** | Engenharia de Software — PAC Extensionista (Centro Universitário Católica de Santa Catarina, Joinville) |
| **Professor** | Diego Sauter Possamai |
| **GDD (Game Design Document)** | [`docs/GDD_Numbers_World_2_Final.pdf`](docs/GDD_Numbers_World_2_Final.pdf) |
| **Documento Complementar (GDD × implementado, assets, sons, animações)** | [`docs/Documento_Complementar_Prototipo_N3.pdf`](docs/Documento_Complementar_Prototipo_N3.pdf) |
| **Executável (Windows) e versão Web** | [Releases do repositório](https://github.com/DevVHW/Number-Word-2/releases) |

---

## Sumário

1. [Requisitos](#1-requisitos)
2. [Baixar o projeto](#2-baixar-o-projeto)
3. [Instalação e configuração do ambiente](#3-instalação-e-configuração-do-ambiente)
4. [Como executar o jogo](#4-como-executar-o-jogo)
5. [Como jogar](#5-como-jogar)
6. [Objetivo, regras e progressão](#6-objetivo-regras-e-progressão)
7. [Passo a passo da fase](#7-passo-a-passo-da-fase)
8. [Limitações conhecidas e funcionalidades não implementadas](#8-limitações-conhecidas-e-funcionalidades-não-implementadas)
9. [Relação com o GDD](#9-relação-com-o-gdd)
10. [Problemas comuns](#10-problemas-comuns)
11. [Estrutura do projeto](#11-estrutura-do-projeto)

---

## 1. Requisitos

| Item | Requisito |
|---|---|
| **Para jogar com o executável** | **Windows 10/11 (64 bits)**. Não é preciso instalar a Godot. |
| **Para abrir o código-fonte** | **Godot 4.6.x** (o executável foi gerado com a 4.6.3), versão *Standard* (GDScript). **Não** é necessária a versão ".NET / C#". |
| **Sistema operacional (código-fonte)** | Windows, macOS ou Linux — qualquer um que rode a Godot 4.6. |
| **Placa de vídeo** | Compatível com OpenGL 3.3 (o projeto usa o renderizador **GL Compatibility**, que roda em computadores simples). |
| **Git** | Opcional, só para clonar o repositório pelo terminal. |
| **Periféricos** | Teclado e mouse. |
| **Outras dependências** | Nenhuma. Não há bibliotecas, plugins nem gerenciadores de pacotes para instalar. |

> O projeto foi criado na Godot 4.6. Versões anteriores (4.5 ou menos) podem recusar abrir o projeto ou exibir avisos.

---

## 2. Baixar o projeto

**Opção A — Só quero jogar (Windows): baixar o executável**

1. Abra a página de [**Releases**](https://github.com/DevVHW/Number-Word-2/releases) do repositório.
2. Baixe o arquivo **`NumberWorld2.exe`** (≈ 107 MB). É um arquivo único, com todos os recursos embutidos.
3. Siga a [Opção A da seção 4](#opção-a--executável-windows-mais-rápido).

> O executável fica em *Releases*, e não dentro do código, porque o GitHub não aceita arquivos acima de 100 MB em commits normais.

**Opção B — Clonar o código-fonte com Git**

```bash
git clone https://github.com/DevVHW/Number-Word-2.git
cd Number-Word-2
```

**Opção C — Baixar o código-fonte em ZIP (sem Git)**

1. Na página do repositório, clique em **Code → Download ZIP**.
2. **Extraia** o ZIP em uma pasta (não abra o projeto de dentro do ZIP).

Ao final, a pasta deve conter o arquivo **`project.godot`** na raiz, junto com `assets/`, `scenes/`, `scripts/` e `docs/`.

---

## 3. Instalação e configuração do ambiente

> **Só é necessário para abrir o código-fonte.** Para jogar com o `.exe`, pule para a seção 4.

1. Acesse **https://godotengine.org/download** e baixe a **Godot 4.6.x (Standard)** para o seu sistema.
2. Instale/extraia:
   - **Windows:** extraia o `.zip`; o executável da Godot roda direto, sem instalador.
   - **macOS:** abra o `.zip`/`.dmg` e arraste o app **Godot** para a pasta Aplicativos. Na primeira vez, clique com o botão direito → **Abrir**.
   - **Linux:** extraia e execute o binário (se necessário: `chmod +x Godot_v4.6-stable_linux.x86_64`).
3. Nenhuma outra configuração é necessária: o projeto já define resolução (1280×720), renderizador e teclas.

---

## 4. Como executar o jogo

### Opção A — Executável (Windows, mais rápido)

1. Salve o `NumberWorld2.exe` em qualquer pasta (por exemplo, a Área de Trabalho).
2. Dê dois cliques no arquivo. O jogo abre em uma janela, sem instalação.
3. Se o Windows mostrar **"O Windows protegeu seu computador"** (o arquivo não é assinado digitalmente), clique em **Mais informações → Executar assim mesmo**. Se o antivírus bloquear, libere o arquivo.
4. Para sair, feche a janela.

### Opção B — Pelo editor da Godot (Windows, macOS e Linux)

1. Abra a Godot 4.6. No **Gerenciador de Projetos**, clique em **Importar** (*Import*).
2. Clique em **Procurar** (*Browse*), selecione o arquivo **`project.godot`** da pasta do projeto e clique em **Abrir**; depois em **Importar e Editar**.
3. Aguarde a primeira abertura: a Godot importa imagens e sons automaticamente (de alguns segundos a um minuto). É normal.
4. Clique em **▶ Executar Projeto** (canto superior direito) ou aperte **F5**. O menu inicial (`scenes/MenuPrincipal.tscn`) já está configurado como cena de abertura.
5. Para fechar, feche a janela do jogo ou aperte **F8** no editor.

### Opção C — Pelo terminal (opcional)

Na pasta do projeto, com a Godot acessível:

```bash
godot --path .
```

(Substitua `godot` pelo caminho completo do executável baixado, se necessário.)

---

## 5. Como jogar

### Iniciando a partida

O jogo abre no **menu inicial** (Jogar, Como Jogar, Créditos e Sair). Ao clicar em **Jogar**, uma abertura curta conta a história: o Caos Numérico partiu as pontes da Planície das Frações e Neo precisa reconstruí-las. Aperte **Enter/Espaço** ou clique para avançar, ou **Esc** para pular a história.

### Controles

| Tecla | Ação |
|---|---|
| **← / →** ou **A / D** | Andar para a esquerda / direita |
| **Espaço**, **W** ou **↑** | Pular (só funciona com Neo no chão) |
| **E** | Usar o painel de frações (aparece "[E] Usar painel" quando Neo está perto) |
| **Esc** ou **P** | Pausar (continuar, ajuda, volume, reiniciar, voltar ao menu). No painel, fecha o puzzle |
| **Mouse** | Clicar nos botões dos menus e do painel |

### Tutorial e tela do jogo (HUD)

- **Tutorial contextual:** a caixa na parte de baixo ensina uma ação por vez (andar, pular, ir até o totem, apertar E) e muda conforme o jogador avança.
- **Objetivo (canto superior direito):** mostra sempre o que fazer agora.
- **Canto superior esquerdo:** lembrete dos controles e contador **"Fragmentos de Conhecimento: N/3"**.
- **Falas curtas** em balões: Neo e o totem comentam a história nos momentos-chave (chegada, aproximação do totem, queda e ponte pronta).
- **Avisos rápidos** no centro da tela confirmam conquistas (fragmento coletado, ponte restaurada) e explicam a queda no abismo.

---

## 6. Objetivo, regras e progressão

### Objetivo

Atravessar o abismo que separa as duas plataformas e chegar ao **portal "PRÓXIMA FASE"**. Para isso, é preciso **reconstruir a ponte** resolvendo o puzzle de frações do painel interativo.

### Regras básicas

- Neo anda e pula pelas plataformas. **Não há inimigos nem limite de tempo.**
- No centro da fase há um **abismo**: se Neo cair, **volta ao ponto inicial** (plataforma esquerda). Não há perda de vida nem "game over". As bordas da fase têm paredes invisíveis, então Neo não sai da tela.
- O **painel interativo** (totem) fica na plataforma da esquerda. Ao apertar **E** perto dele, o puzzle abre e **o jogo pausa**.
- O puzzle tem **3 espaços** (`[ ] + [ ] + [ ] = ?`) e **3 botões de fração**: `1/4`, `1/2` e `1/4`.
  - Cada clique em um botão **preenche o próximo espaço vazio**. O mesmo botão pode ser clicado mais de uma vez.
  - Uma **barra de soma** mostra quanto a soma parcial já vale e quanto falta para 1 inteiro.
  - **Desfazer** remove a última fração, **Limpar** esvazia os espaços, **Dica** mostra uma pista e **Fechar (Esc)** volta ao jogo sem resolver.
  - Ao clicar em **Verificar soma**, o jogo soma as três frações. **A soma precisa ser exatamente 1 (um inteiro).** A ordem não importa.
- **Resposta errada:** som de erro, o painel treme, aparece o resultado obtido (ex.: "a soma deu 3/4 e ficou menor que 1") e, em seguida, uma dica. As dicas ficam mais detalhadas a cada erro. Dá para tentar quantas vezes quiser.
- **Resposta certa:** som de acerto e a explicação "2/4 + 1/4 + 1/4 = 4/4 = 1 inteiro".

### Progressão, vitória e derrota

| Situação | O que acontece |
|---|---|
| Puzzle correto | Som de acerto, o painel fecha, **os 3 pedaços da ponte encaixam um a um, com som,** mostrando `1/4`, `1/2` e `1/4` e **o portal aparece** na plataforma da direita |
| Neo entra no portal | **Vitória:** tela com medalha, fragmentos, tempo e tentativas erradas, e os botões **Jogar Novamente** e **Voltar ao menu** |
| Cair no abismo | Neo reaparece no início, sem punição |

Não existe condição de derrota: o jogador só avança ou tenta de novo.

### Fragmentos de Conhecimento (coletáveis)

Há **3 fragmentos** flutuantes na fase. Basta encostar para coletar: toca um som e o contador do HUD aumenta. Eles são opcionais para vencer, mas definem a **medalha**: 3 fragmentos = ouro, 1 ou 2 = prata, nenhum = bronze. Um deles fica no alto (exige pulo) e outro na plataforma da direita (só alcançável depois de montar a ponte).

---

## 7. Passo a passo da fase

1. No menu, clique em **Jogar** e leia (ou pule com **Esc**) a abertura da história.
2. Siga a caixa de tutorial: ande com **→/D**, pule com **Espaço/W** e colete os fragmentos.
3. Pare em frente ao totem até aparecer **[E] Usar painel** e aperte **E**.
4. Preencha **1/4 + 1/2 + 1/4** (qualquer ordem) e clique em **Verificar soma**.
5. Atravesse a ponte e entre no **portal**. A tela de vitória mostra a medalha; **Jogar Novamente** reinicia e **Voltar ao menu** retorna ao início.

---

## 8. Limitações conhecidas e funcionalidades não implementadas

**Limitações da versão atual**

- Existe **apenas 1 fase e 1 puzzle** (`1/4 + 1/2 + 1/4 = 1`). O portal "Próxima Fase" leva à tela de vitória, pois ainda não há segunda fase.
- O volume é ajustado no menu de pausa e não fica salvo entre sessões.
- O executável é para **Windows (64 bits)**; há também a versão **Web** (abre no navegador). macOS e Linux precisam do projeto na Godot 4.6.x.
- Não há vidas, salvamento de progresso nem suporte a gamepad ou toque (não testados).

**Planejado e ainda não implementado**

- Novas fases e novos puzzles (subtração, equivalência, comparação, porcentagens, números negativos).
- Inimigos (*Bug Numérico*, *Sentinela de Equação*) e o chefe *Caos Numérico*.
- Música adaptativa e animações Run, Attack, Hurt e Win do Neo.

---

## 9. Relação com o GDD

O GDD descreve o jogo completo (vários mundos, inimigos, chefe final). Esta versão implementa apenas o **Mundo 1 — Planície das Frações**, como protótipo. A comparação detalhada está no Documento Complementar (link no topo deste arquivo).

**Previsto no GDD e ainda não implementado:** Mundo 2 (Vale das Porcentagens), Mundo 3 (Caverna dos Números Negativos) e chefe final "Caos Numérico"; inimigos *Bug Numérico* e *Sentinela de Equação* (com IA por máquina de estados); medalhas e pontuação; dificuldade dinâmica; *Guia de Conhecimento* dentro do jogo; música adaptativa; sons de erro e de acerto do puzzle; animações Run, Attack, Hurt e Win do Neo (o sprite sheet já tem os quadros, mas eles não estão conectados).

**Onde o GDD diverge do protótipo atual** (vale o que está descrito neste README):

| Tema | GDD | Protótipo atual |
|---|---|---|
| Teclas de movimento | "WASD" / "seta ou A/D" | Setas ou **A/D** para andar; **Espaço/W/↑** para pular |
| Fragmentos | Necessários para acessar o puzzle ou a saída da fase | **Opcionais**: definem a medalha (ouro, prata ou bronze) |
| Símbolos "+" e "=" | Neo os coleta antes de resolver | Não existem; o painel já traz a equação |
| Som de acerto do puzzle | Listado como `sucesso.wav` | Implementado como `acerto.wav` (e `erro.wav` para resposta errada) |

---

## 10. Problemas comuns

| Problema | Solução |
|---|---|
| Windows bloqueia o `.exe` | Clique em **Mais informações → Executar assim mesmo** (o arquivo não é assinado). |
| A Godot avisa que o projeto é de outra versão | Use a Godot **4.6.x**. |
| Erros de arquivo ou imagem não encontrada na primeira abertura | Aguarde a importação terminar (barra no canto inferior direito) e rode de novo. Se persistir, feche e reabra o projeto. |
| Não há som | Verifique o volume do computador; o áudio toca pela janela do jogo. |
| Apertei **E** e nada aconteceu | Chegue mais perto do painel: Neo precisa estar dentro da área dele. |
| O jogo "travou" depois de abrir o painel | É a pausa do puzzle; resolva-o ou aperte **Esc** / **Fechar** para voltar. |
| A versão Web não abre clicando no `index.html` | Navegadores bloqueiam arquivos locais: rode um servidor (ex.: `python -m http.server` na pasta) ou use a versão publicada. |

---

## 11. Estrutura do projeto

```
.
├── README.md                # Este guia
├── docs/
│   ├── GDD_Numbers_World_2_Final.pdf                # Game Design Document
│   └── Documento_Complementar_Prototipo_N3.pdf      # GDD × implementado, assets, sons, animações
├── project.godot            # Configuração da Godot (cena inicial, resolução, teclas)
├── icon.svg                 # Ícone do projeto
├── assets/
│   ├── audio/               # Música (loop), pulo, passos, coleta, acerto, erro, clique e encaixe (.wav)
│   ├── backgrounds/         # Fundo da Planície das Frações
│   ├── fonts/               # Cinzel Decorative, Cinzel e Nunito (licença OFL)
│   ├── sprites/             # Neo, painel, portal, ponte e fragmento
│   └── tema.tres            # Tema global (fonte Nunito)
├── scenes/
│   ├── MenuPrincipal.tscn      # Menu inicial (cena de abertura do jogo)
│   ├── Intro.tscn              # Abertura com a história
│   ├── PlanieDasFracoes.tscn   # A fase jogável
│   └── Fragmento.tscn          # Coletável "Fragmento de Conhecimento"
└── scripts/
    ├── neo_player.gd        # Movimento, pulo, animação e interação do Neo
    ├── painel_puzzle.gd     # Lógica do puzzle de frações
    ├── ponte.gd             # Animação de união da ponte
    ├── portal_fase.gd       # Portal e tela de vitória
    ├── fragmento.gd         # Coletável
    ├── hud.gd               # Contador de fragmentos
    ├── cena_principal.gd    # Configuração da cena, respawn e cronômetro
    ├── menu_principal.gd    # Menu inicial, Como Jogar e Créditos
    ├── intro.gd             # Abertura narrativa
    ├── guia_tutorial.gd     # Tutorial contextual e objetivo na tela
    ├── menu_pausa.gd        # Menu de pausa com volume (autoload "Pausa")
    ├── ui_util.gd           # Estilos, fontes e textos compartilhados
    └── signal_bus.gd        # Sinais e estado globais (autoload "SignalBus")
```

---

## Créditos

- **Desenvolvimento:** Guilherme Vieira Wesolowski, João Henrique Ramos de Souza, José Antonio Voss e Victhor Hugo Wandersee Rodrigues Philippe.
- **Orientação:** Prof. Diego Sauter Possamai — Engenharia de Software, Católica de Santa Catarina (Joinville).
- **Engine:** [Godot Engine](https://godotengine.org/) 4.6.
- **Assets** (cenário, sprites e áudios): listados e descritos nas seções 3 a 7 do Documento Complementar. Sons de acerto, erro, clique e encaixe gerados pela equipe.
- **Fontes:** [Cinzel e Cinzel Decorative](https://github.com/NDISCOVER/Cinzel) e [Nunito](https://github.com/googlefonts/nunito), sob a SIL Open Font License 1.1 (licenças em `assets/fonts/`).
