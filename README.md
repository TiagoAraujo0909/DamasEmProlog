JOGO DE DAMAS:

O jogo de damas pratica-se entre dois jogadores, num tabuleiro quadrado 8x8, de 64 casas alternadamente claras e escuras, dispondo de 12 peças brancas e 12 pretas. O objetivo é capturar ou imobilizar as peças do adversário. O jogador que conseguir capturar todas as peças do inimigo ganha a partida.
As peças de ambos os jogadores são todas colocadas nos quadrados da mesma cor e apenas se podem mover na diagonal (esquerda ou direita) em direção ao lado do seu adversário, à exceção das damas (que são as peças promovidas quando atingem a borda do lado contrário) que se podem mover nas diagonais de qualquer sentido.
As capturas ocorrem quando há uma peça do adversário entre a peça do jogador e um quadrado vazio. Quando estas condições se verificam o jogador tem como obrigação de fazer a captura. As capturas podem ser sucessivas, podendo haver várias feitas pela mesma peça numa só jogada.

===

O JOGO:
Jogado exclusivamente na consola, basta carregar o ficheiro damas.pl para o seu interpretador de Prolog, por exemplo SWI-Prolog (o que usamos, pessoalmente) ou YAP e correr o comando main. .

O jogo imprime 2 tabelas. Isto porque a primeira corresponde ao estado inicial do jogo e a segunda à jogada do computador. De notar também que é dado o output da jogada que o computador fez e a avaliação dessa mesma jogada (mais sobre isto à frente) por razões de clareza. As suas peças vão representadas por V (dama W) e as do seu adversário por O (dama Q). Os underscores representam os quadrados onde é possível jogar e as caixas pretas os restantes.
De seguida será apresentada uma lista das suas jogadas possíveis. A consola ficará à espera da sua escolha (apenas funcionam as que aparecem na lista). Para isso, basta ver as coordenadas (x,y) da peça de quer mover e para onde a quer mover. Para escolher a jogada, necessita de dar como input o numero da jogada seguida de ponto. Por exemplo, queremos escolher a jogada 3, (4,3) -> (3,4), teremos de escrever então 3.

O jogo corre assim sucessivamente até o terminar.

===

IA

Dada uma lista de jogadas possíveis, podíamos ser tentados a escrever a nossa IA para simplesmente fazer a melhor jogada dessa lista. Se assim fosse, a melhor jogada seria sempre capturar a peça do jogador seguida por promover uma peça a dama e finalmente fazer um movimento normal. Essa IA seria competente, mas pouco eficiente porque realizaria capturas que não fariam muito sentido.
Sendo assim, em vezes de apenas considerar cada jogada, também tem de considerar o efeito que essa jogada pode ter futuramente. Essencialmente, a IA pensa no que o jogador poderá fazer dependendo do que ela decidir cada uma das jogadas.
Para isso, decidimos implementar um algoritmo de minimax com alfa-beta pruning.
