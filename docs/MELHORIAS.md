# Registro de melhorias — Numbers World 2

Versão 1.0.0 · Mundo 1 — Planície das Frações

Este documento mostra o que mudou no jogo depois do protótipo da N2. As melhorias foram organizadas pelos pontos de atenção da aula e pelas limitações que o próprio README anterior apontava. Cada item traz o problema que o jogador enfrentava, o que foi feito e como verificar se o ajuste funcionou.

## 1. Tutorial e guia dentro do jogo

| Antes | Agora |
|---|---|
| Não havia tutorial. As instruções existiam só no README. | Uma caixa de tutorial ensina **uma ação por vez**, no momento em que ela é necessária: andar → pular → ir até o totem → apertar E. |
| O jogador não sabia o que fazer depois de cada etapa. | Um quadro de **Objetivo** fica sempre no canto superior direito e muda a cada etapa ("Encontre o totem das frações", "Some as frações até formar 1 inteiro", "Atravesse a ponte e entre no portal"). |
| Não havia ajuda consultável durante a partida. | O menu de pausa (Esc ou P) tem o botão **Como Jogar**, com objetivo, controles e regras. O menu inicial também tem essa opção. |

**Como testar:** uma pessoa que nunca jogou consegue abrir o painel e chegar ao portal sem ajuda da equipe?

## 2. Jornada intuitiva

| Onde o jogador travava | Ajuste |
|---|---|
| Apertava E longe do painel e nada acontecia. | Quando Neo está perto do totem, aparece **"[E] Usar painel"** piscando sobre ele. |
| Depois de abrir o painel, ficava preso nele. | Botão **Fechar (Esc)**: dá para sair e voltar depois. |
| Errava uma fração e não conseguia corrigir. | Botões **Desfazer** (remove a última) e **Limpar** (remove todas). |
| Não entendia por que a resposta estava errada. | O jogo mostra o resultado ("a soma deu 3/4 e ficou menor que 1") e uma **barra de soma** mostra quanto já foi preenchido e quanto falta. |
| Errava várias vezes seguidas sem avançar. | Botão **Dica** e dicas que ficam mais detalhadas a cada erro: "precisa dar 4/4" → "1/2 é o mesmo que 2/4" → "2/4 + 1/4 + 1/4 = 4/4". |
| Caía no abismo e não sabia por quê. | Aviso: "O abismo é fundo demais! Resolva o painel para unir a ponte." |
| O texto do painel dizia "na ordem correta", mas qualquer ordem era aceita. | O enunciado agora diz "A ordem não importa". |
| O HUD citava A/D, mas essas teclas não funcionavam. | **A/D** e **W** foram mapeadas. O HUD foi corrigido. |
| O jogo começava direto na fase, sem menu. | **Menu inicial** com Jogar, Como Jogar, Créditos e Sair. A vitória tem **Jogar Novamente** e **Voltar ao menu**. |

## 3. Fontes dos textos

- **Cinzel Decorative** nos títulos (menu, painel, vitória) e **Cinzel** nos subtítulos. As serifas clássicas lembram inscrições antigas e combinam com a ideia de um reino de lógica que foi corrompido.
- **Nunito** em todo o texto de leitura (tutorial, painel, HUD). É arredondada, amigável para o público do Ensino Médio e mantém as frações legíveis.
- Todos os textos ganharam **acentuação**, contorno escuro para ficar legíveis sobre o cenário colorido e caixas com fundo escuro.
- As fontes são livres (SIL Open Font License); as licenças estão em `assets/fonts/`.

## 4. História e envolvimento

- Nova **abertura narrativa** (4 telas, com texto aparecendo aos poucos e opção de pular com Esc), baseada na seção 11 do GDD:
  1. *Numbers World* era um reino de lógica pura.
  2. O *Caos Numérico* embaralhou os cálculos e partiu as pontes da Planície das Frações.
  3. *Neo*, um estudante puxado para esse mundo, precisa devolver o equilíbrio ao reino para voltar para casa.
  4. *A missão*: cada pedaço da ponte guarda uma fração, e só quem entende como elas se somam consegue uni-la.
- **Falas curtas** em balões: Neo comenta ao chegar, ao cair e ao ver a ponte pronta, e o totem dá a missão quando Neo se aproxima.
- O painel abre com a mensagem do totem ("O Caos Numérico partiu a ponte em pedaços!"), ligando o desafio à história.
- **Consequência visível:** as peças da ponte encaixam uma a uma, com som, e cada pedaço mostra sua fração (1/4, 1/2, 1/4), e o jogador vê que a soma virou o caminho.
- A vitória fecha a história ("a Planície das Frações voltou ao equilíbrio") e anuncia o próximo mundo ("o Caos Numérico ainda se esconde nos próximos mundos...").
- **Medalhas** dão função aos Fragmentos de Conhecimento: 3 fragmentos = ouro, 1 ou 2 = prata, nenhum = bronze. A tela também mostra o tempo e as tentativas erradas, o que incentiva jogar de novo.

## 5. Efeitos sonoros

| Interação | Som |
|---|---|
| Clique em botões e frações, avanço da história | `clique.wav` (curto e agudo) |
| Resposta certa e chegada ao portal | `acerto.wav` (arpejo ascendente) |
| Resposta errada ou verificação incompleta | `erro.wav` (tom grave), acompanhado de um tremor do painel |
| Encaixe de cada peça da ponte | `encaixe.wav` (impacto grave, com tom subindo a cada peça) |
| Já existentes | música de fundo (agora em loop), passos, pulo e coleta de fragmento |

O **menu de pausa** tem controle de volume (0 a 100%). O aviso de barramento "SFX" inexistente, que aparecia no console, foi corrigido.

## 6. Feedback da professora

A devolutiva elogiou a ponte que se forma a partir da soma das frações e a consequência visível do acerto. Esses pontos foram mantidos e reforçados. A tabela mostra como cada recomendação foi atendida.

| Recomendação | Ajuste feito | Como verificar |
|---|---|---|
| Revisar a queda pela borda esquerda, que deixava Neo fora da tela sem retornar | Paredes invisíveis nas bordas esquerda e direita da fase. Como segurança extra, se Neo sair da área da fase por qualquer lado, volta ao ponto inicial. | Segurar ← no início: Neo para na borda e continua visível. |
| Alinhar os comandos do HUD com as teclas que funcionam | A/D e W foram mapeadas, e o HUD agora diz "Setas ou A/D: andar \| Espaço ou W: pular \| E: interagir \| Esc: pausa e ajuda". | Todas as teclas citadas no HUD funcionam. |
| Colocar um aviso de interação perto do totem | "[E] Usar painel" piscando sobre o totem quando Neo chega perto, e o tutorial também diz "Aperte E para usar o painel". | Chegar ao totem sem ler o README e abrir o painel. |
| Deixar claro desde o início que as três frações devem somar um inteiro | O enunciado do painel abre com "MISSÃO: escolha 3 frações que, somadas, formem 1 INTEIRO". Antes de qualquer clique, a barra mostra "Soma atual: 0 de 1 inteiro". | Abrir o painel e ler a missão antes de clicar. |
| Permitir que o jogador corrija uma escolha | **Desfazer** remove só a última fração e **Limpar** esvazia todos os espaços. | Escolher 1/4, apertar Desfazer e trocar por 1/2. |
| Permitir fechar a janela | Botão **Fechar (Esc)**: o jogador pode sair e voltar ao painel depois. | Abrir o painel e apertar Esc. |
| Trazer a história do GDD em uma fala curta do Neo ou em uma mensagem do totem | Fizemos as duas coisas. Neo fala ao chegar ("Onde eu estou?! A ponte está em pedaços..."), quando cai ("Não dá para pular isso...") e quando a ponte se forma ("A matemática virou caminho!"). O totem fala quando Neo se aproxima ("Some as frações até formar 1 inteiro e a ponte voltará a se unir") e o painel começa com a mensagem dele sobre o Caos Numérico. Além disso, há a abertura narrativa antes da fase. | Jogar a fase e observar os balões. |
| Música em loop | A música de fundo agora repete sem parar (antes tocava uma vez e acabava). | Ficar mais de 20 segundos na fase. |
| Som no encaixe das peças, para dar impacto ao momento em que a ponte se recompõe | As 3 peças agora sobem **uma de cada vez**. Cada encaixe tem um som de impacto (cada vez mais agudo) e um brilho, e em seguida cada peça mostra sua fração. | Resolver o puzzle e ouvir os 3 encaixes. |

## 7. Entrega técnica

- **Windows:** `NumberWorld2.exe` (arquivo único, sem instalação).
- **Web:** pasta `web/` exportada com a Godot 4.6.3, sem multithread, para funcionar em hospedagens simples como GitHub Pages e itch.io.
- Fluxo completo testado em execução automatizada: menu → Como Jogar → história → tutorial → coleta → pausa → erro no puzzle → dica → desfazer → acerto → encaixe da ponte → portal → vitória. A borda esquerda e a saída da área da fase também foram testadas.
