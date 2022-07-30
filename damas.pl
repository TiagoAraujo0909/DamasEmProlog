:-use_module(library(lists)).

%=============================================================================================
%"OBJETO" TABULEIRO

%Cria o modelo do tabuleiro
board(game_board(A,B,C,D,E,F,G,H)):-
  functor(A,l,8), 
  functor(B,l,8),
  functor(C,l,8),
  functor(D,l,8), 
  functor(E,l,8), 
  functor(F,l,8), 
  functor(G,l,8), 
  functor(H,l,8).

%Tabuleiro sem peças
empty_board(
      game_board(
           l(0, 1, 0, 1, 0, 1, 0, 1),
           l(1, 0, 1, 0, 1, 0, 1, 0),
           l(0, 1, 0, 1, 0, 1, 0, 1),
           l(1, 0, 1, 0, 1, 0, 1, 0),
           l(0, 1, 0, 1, 0, 1, 0, 1),
           l(1, 0, 1, 0, 1, 0, 1, 0),
           l(0, 1, 0, 1, 0, 1, 0, 1),
           l(1, 0, 1, 0, 1, 0, 1, 0)
          )).

%Cria o tabuleiro do jogo
board_initialize_game(game_board(A,B,C,D,E,F,G,H)):-
  board(game_board(A,B,C,D,E,F,G,H)),
  board_initialize_game_odd(A,b),
  board_initialize_game_even(B,b),
  board_initialize_game_odd(C,b),
  board_initialize_empty_even(D),
  board_initialize_empty_odd(E),
  board_initialize_game_even(F,w),
  board_initialize_game_odd(G,w),
  board_initialize_game_even(H,w).

%Inicializa cada linha com branco e preto alternadamente
board_initialize_empty_odd(A):-
  arg(1,A,0), arg(2,A,1),
  arg(3,A,0), arg(4,A,1),
  arg(5,A,0), arg(6,A,1),
  arg(7,A,0), arg(8,A,1).
board_initialize_empty_even(A):-
  arg(1,A,1), arg(2,A,0),
  arg(3,A,1), arg(4,A,0),
  arg(5,A,1), arg(6,A,0),
  arg(7,A,1), arg(8,A,0).

%"Coloca" as pecas do jogador e computador alternadamente
board_initialize_game_odd(Line,Player):-
  arg(1,Line,0), arg(2,Line,Player),
  arg(3,Line,0), arg(4,Line,Player),
  arg(5,Line,0), arg(6,Line,Player),
  arg(7,Line,0), arg(8,Line,Player).
board_initialize_game_even(Line,Player):-
  arg(1,Line,Player), arg(2,Line,0),
  arg(3,Line,Player), arg(4,Line,0),
  arg(5,Line,Player), arg(6,Line,0),
  arg(7,Line,Player), arg(8,Line,0).


%Imprime o tabuleiro para a consola linha a linha
board_print(game_board(A,B,C,D,E,F,G,H)):-
  tab(3),print(1), tab(2),print(2), tab(2),
  print(3), tab(2),print(4), tab(2),
  print(5), tab(2),print(6), tab(2),
  print(7), tab(2),print(8), tab(2), nl,
  print(1), tab(2),
  board_print_line(A),
  print(2), tab(2),
  board_print_line(B),
  print(3), tab(2),
  board_print_line(C),
  print(4), tab(2),
  board_print_line(D),
  print(5), tab(2),
  board_print_line(E),
  print(6), tab(2),
  board_print_line(F),
  print(7), tab(2),
  board_print_line(G),
  print(8), tab(2),
  board_print_line(H).

%Imprime cada elemento de uma linha
board_print_line(Line):-
  board_print_line_element(Line,1),
  board_print_line_element(Line,2),
  board_print_line_element(Line,3),
  board_print_line_element(Line,4),
  board_print_line_element(Line,5),
  board_print_line_element(Line,6),
  board_print_line_element(Line,7),
  board_print_line_element(Line,8),
  nl.

%Atomos
%Underscore
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == 1, !,
  format('~c',[95]),
  tab(2).
%Espaco onde nao se joga
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == 0, !,
  format('~c',[9922]),
  tab(2).
%Peca computador - O 
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == w, !,
  format('~c',[79]),  
  tab(2).
%Peca jogador - V
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == b, !,
  format('~c',[86]),  
  tab(2).
%Dama computador - Q
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == wq, !,
  format('~c',[81]),  
  tab(2).
%Dama jogador - W
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  E == bq, !,
  format('~c',[87]),  
  tab(2).
board_print_line_element(Line,Index):-
  arg(Index,Line,E),
  print(E),
  tab(2).

%==============================================================================================================
%MUDANCAS NO TABULEIRO

%Retorna o elemento de uma dada posicao do tabuleiro
pos(Board, X, Y, E):-
  arg(Y,Board,T),
  arg(X,T,E).

%Retorna um novo tabuleiro com as devidas alteracoes
replace(Board, X, Y, Element, New_Board):-
  functor(New_Board,game_board,8),
  replace_in_board(Board,X,Y,Element,New_Board,1).

%Troca elementos no tabuleiro
replace_in_board(_,_,_,_,_,Iterator):- Iterator > 8, !.
replace_in_board(Board, X, Y, Element, New_Board, Iterator):-
  Iterator == Y, !,
  arg(Y,Board,Line),
  functor(New_Line,l,8),
  replace_in_line(Line, X, Element, New_Line, 1),
  arg(Iterator,New_Board,New_Line),
  Iterator_Next is Iterator + 1,
  replace_in_board(Board, X, Y, Element, New_Board, Iterator_Next).
replace_in_board(Board, X, Y, Element, New_Board, Iterator):-
  arg(Iterator,Board,Line),
  arg(Iterator,New_Board,Line),
  Iterator_Next is Iterator + 1,
  replace_in_board(Board, X, Y, Element, New_Board, Iterator_Next).

%Troca elementos na linha
replace_in_line(_,_,_,_, Iterator):- Iterator > 8, !.
replace_in_line(Line, X, Element, New_Line, Iterator):-
  Iterator == X, !,
  arg(X,New_Line,Element),
  Iterator_Next is Iterator + 1,
  replace_in_line(Line, X, Element, New_Line, Iterator_Next).
replace_in_line(Line, X, Element, New_Line, Iterator):-
  arg(Iterator,Line,Old),
  arg(Iterator,New_Line,Old),
  Iterator_Next is Iterator + 1,
  replace_in_line(Line, X, Element, New_Line, Iterator_Next).

%Retira um elemento do tabuleiro
remove_from_board(Board,X,Y,New_Board):-
  empty_board(Empty_Board),
  pos(Empty_Board,X,Y,Place),
  replace(Board,X,Y,Place,New_Board).

%Movimento de pecas
move(Board,Xi,Yi,Xf,Yf,New_Board):-
  pos(Board,Xi,Yi,Piece),
  remove_from_board(Board,Xi,Yi,Temp_Board),
  promote(Yf,Piece,Piece2),
  replace(Temp_Board,Xf,Yf,Piece2,New_Board).

%Promove peca normal a dama
promote(1,w,wq):- !.
promote(8,b,bq):- !.
promote(_,Piece,Piece).

%Verifica se um quadrado esta ocupado ou nao
is_occupied(Board,X,Y):-
  pos(Board,X,Y,Element),
  \+number(Element).

%Verifica se a peca naquela posicao pertence ao adversario
is_enemy(Board,X,Y,Player):-
  pos(Board,X,Y,Piece),
  next_player(Player,N),
  player_piece(N,Piece), !.

%==============================================================================================================
%CAPTURAS

%Computador - tenta capturar esquerda
next_eat_move(Board,w,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y > 2,
  X1 is X - 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X - 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Computador - tenta capturar direita
next_eat_move(Board,w,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y > 2,
  X1 is X + 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X + 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Jogador - tenta capturar esquerda
next_eat_move(Board,b,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y < 7,
  X1 is X - 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X - 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Jogador - tenta capturar direita
next_eat_move(Board,b,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y < 7,
  X1 is X + 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X + 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama computador - tenta capturar frente/esquerda
next_eat_move(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y > 2,
  X1 is X - 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X - 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama computador - tenta capturar frente/direita
next_eat_move(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y > 2,
  X1 is X + 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X + 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama computador - tenta capturar tras/esquerda
next_eat_move(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y < 7,
  X1 is X - 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X - 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama computador - tenta capturar tras/direita
next_eat_move(Board,wq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y < 7,
  X1 is X + 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,white),
  X2 is X + 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama jogador - tenta capturar frente/esquerda
next_eat_move(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y < 7,
  X1 is X - 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X - 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama jogador - tenta capturar frente/direita
next_eat_move(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y < 7,
  X1 is X + 1, Y1 is Y + 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X + 2, Y2 is Y + 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama jogador - tenta capturar tras/esquerda
next_eat_move(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X > 2, Y > 2,
  X1 is X - 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X - 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%Dama jogador - tenta capturar tras/direita
next_eat_move(Board,bq,X,Y,e(X,Y,X2,Y2,New_Board)):-
  X < 7, Y > 2,
  X1 is X + 1, Y1 is Y - 1,
  is_enemy(Board,X1,Y1,black),
  X2 is X + 2, Y2 is Y - 2,
  \+is_occupied(Board,X2,Y2),
  move(Board,X,Y,X2,Y2,Temp_Board),
  remove_from_board(Temp_Board,X1,Y1,New_Board).

%==============================================================================================================
%MOVIMENTOS SEM CAPTURA

%Computador - tenta mover para esquerda
next_move(Board,w,X,Y,m(X,Y,X1,Y1,New_Board)):-
  X > 1, Y > 1,
  X1 is X - 1, Y1 is Y - 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Computador - tenta mover para direita
next_move(Board,w,X,Y,m(X,Y,X1,Y1,New_Board)):-
  X < 8, Y > 1,
  X1 is X + 1, Y1 is Y - 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Jogador - tenta mover para esquerda
next_move(Board,b,X,Y,m(X,Y,X1,Y1,New_Board)):-
  X > 1, Y < 8, 
  X1 is X - 1, Y1 is Y + 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Jogador - tenta mover para direita
next_move(Board,b,X,Y,m(X,Y,X1,Y1,New_Board)):-
  X < 8, Y < 8,
  X1 is X + 1, Y1 is Y + 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Dama qualquer - tenta mover para cima/esquerda
next_move(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
  queen(Piece),
  X > 1, Y > 1,
  X1 is X - 1, Y1 is Y - 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Dama qualquer - tenta mover para cima/direita
next_move(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
  queen(Piece),
  X < 8, Y > 1,
  X1 is X + 1, Y1 is Y - 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Dama qualquer - tenta mover para baixo/esquerda
next_move(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
  queen(Piece),
  X > 1, Y < 8,
  X1 is X - 1, Y1 is Y + 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Dama qualquer - tenta mover para baixo/direita
next_move(Board,Piece,X,Y,m(X,Y,X1,Y1,New_Board)):-
  queen(Piece),
  X < 8, Y < 8,
  X1 is X + 1, Y1 is Y + 1,
  \+is_occupied(Board,X1,Y1),
  move(Board,X,Y,X1,Y1,New_Board).

%Damas
queen(wq).
queen(bq).

%==============================================================================================================
%LISTAS DE JOGADAS

%Retorna uma lista de todas as jogadas possiveis
list_available_moves(Board,Player,Moves):-
  list_all_positions(Board,Player,Positions),
  list_available_moves_aux(Board,Positions,Moves), 
  Moves \= [].

list_available_moves_aux(Board,Positions,Moves):-
  list_all_eat_moves(Board,Positions,Moves),
  Moves \= [], !.
list_available_moves_aux(Board,Positions,Moves):-
  list_all_moves(Board,Positions,Moves).

%Retorna uma lista com todas as capturas possiveis
list_all_eat_moves(_,[],[]):- !.
list_all_eat_moves(Board,[p(E,X,Y)|Positions],Moves):-
  bagof(M,chain_eat(Board,p(E,X,Y),M),Move), !,
  list_all_eat_moves(Board,Positions,Move2),
  append(Move,Move2,Move3), % can be removed in order to have a list of possible moves for a piece
  remove_empty(Move3,Moves).
list_all_eat_moves(Board,[_|Positions],Moves):-
  list_all_eat_moves(Board,Positions,Moves).

%Retorna uma lista com todas as jogadas possiveis para todas as pecas
list_all_moves(_,[],[]):- !.
list_all_moves(Board,[p(E,X,Y)|Positions],Moves):-
  bagof(M,next_move(Board,E,X,Y,M),Move), !,
  list_all_moves(Board,Positions,Move2),
  append(Move,Move2,Moves). % can be removed, and we have a list of moves for each piece.
list_all_moves(Board,[_|Positions],Moves):-
  list_all_moves(Board,Positions,Moves).

%Retorna uma lista de todas as pecas do jogador
list_all_positions(Board,Player,Positions):-
  bagof(Pos, list_all_positions_aux(Board,Player,Pos), Positions).

list_all_positions_aux(Board,Player,p(E,X,Y)):-
  member(X,[1,2,3,4,5,6,7,8]),
  member(Y,[1,2,3,4,5,6,7,8]),
  pos(Board,X,Y,E),
  player_piece(Player,E).

%Capturar varias pecas em sucessao
chain_eat(Board,p(E,X,Y),[e(X,Y,X1,Y1,Board2)|Moves]):-
  next_eat_move(Board,E,X,Y,e(X,Y,X1,Y1,Board2)),
  pos(Board2,X1,Y1,E1),
  chain_eat(Board2,p(E1,X1,Y1),Moves).
chain_eat(Board,p(E,X,Y),[]):-
  \+next_eat_move(Board,E,X,Y,_).

remove_empty([],[]):- !.
remove_empty([[]|L],L1):- !, remove_empty(L,L1).
remove_empty([X|L],[X|L1]):- remove_empty(L,L1).

%Proxima jogada pertence a
next_player(white,black).
next_player(black,white).

%Pecas em jogo
%Computador normal
player_piece(white,w).
%Computador dama
player_piece(white,wq).
%Jogador normal
player_piece(black,b).
%Jogador dama
player_piece(black,bq).

%==============================================================================================================
%AVALIAR ESTADO DO JOGO

% board_weight(+Piece,+X,+Y,-W).
board_weight(w,_,1,5).
board_weight(w,_,2,3).
board_weight(w,_,3,2).
board_weight(w,_,6,2).
board_weight(w,_,7,3).
board_weight(w,_,8,5).
board_weight(w,_,_,1).
board_weight(b,_,1,5).
board_weight(b,_,2,3).
board_weight(b,_,3,2).
board_weight(b,_,6,2).
board_weight(b,_,7,3).
board_weight(b,_,8,5).
board_weight(b,_,_,1).
board_weight(_,_,_,1).

evaluate_board(Board, 200, _):-
    \+list_available_moves(Board,black,_),
    list_available_moves(Board,white,_), !.
evaluate_board(Board, -200, _):-
    \+list_available_moves(Board,white,_),
    list_available_moves(Board,black,_), !.

evaluate_board(_, 0, Iterator) :-  Iterator > 8, !.

evaluate_board(Board, Eval, Iterator) :- 
    arg(Iterator, Board, Line), !,
    evaluate_line(Line, LineEval, Iterator, 1),
    IteratorNext is Iterator + 1,
    evaluate_board(Board, RemainingEval, IteratorNext),
    Eval is LineEval + RemainingEval.

evaluate_line(_, 0, _, Column) :- Column > 8, !.
evaluate_line(Line, Eval, Row, Column) :-
  arg(Column, Line, Piece), !,
  piece_value(Piece, PieceValue),
  board_weight(Piece,Column,Row,W),
  IteratorNext is Column + 1,
  evaluate_line(Line, RemainingEval, Row, IteratorNext),
  Eval is RemainingEval + PieceValue * W.

%==============================================================================================================
%ALGORITMO MINIMAX

minimax(Player, Board, NextMove, Eval, Depth) :-
  Depth < 5,
  NewDepth is Depth + 1,
  next_player(Player, OtherPlayer),
  list_available_moves(Board, OtherPlayer, Moves),
  best(OtherPlayer, Moves, NextMove, Eval, NewDepth), !.
minimax(_, Board, _, Eval, _) :-
  evaluate_board(Board, Eval, 1), !.

best(Player, [Move], Move, Eval, Depth) :-
  move_board(Move, Board),
  minimax(Player, Board, _, Eval, Depth), !.
best(Player, [Move|Moves], BestMove, BestEval, Depth) :-
  dechain(Move, Move1),
  move_board(Move1, Board),
  minimax(Player, Board, _, Eval, Depth),
  best(Player, Moves, BestMove1, BestEval1, Depth),
  better_of(Player, Move1, Eval, BestMove1, BestEval1, BestMove, BestEval).

dechain([Move],Move).
dechain([_|Moves],Last) :- last(Moves, Last).
dechain(Move, Move).

maximizing(white).
minimizing(black).

move_board(m(_,_,_,_, Board), Board).
move_board(e(_,_,_,_, Board), Board).
%move_board([e(_,_,_,_, Board)], Board).
better_of(Player, Move1, Eval1, _, Eval2, Move1, Eval1) :-
  maximizing(Player),
  Eval1 >= Eval2, !.
better_of(Player, _, Eval1, Move2, Eval2, Move2, Eval2) :-
  maximizing(Player),
  Eval2 >= Eval1, !.

better_of(Player, Move1, Eval1, _, Eval2, Move1, Eval1) :-
  minimizing(Player),
  Eval1 =< Eval2, !.
better_of(Player, _, Eval1, Move2, Eval2, Move2, Eval2) :-
  minimizing(Player),
  Eval2 =< Eval1, !.
  
piece_value(1, 0).
piece_value(0, 0).
piece_value(w, 1).
piece_value(b, -1).
piece_value(wq, 5).
piece_value(bq, -5).

%==============================================================================================================
%ALPHA BETA PRUNING

alphabeta(Player, Alpha, Beta, Board, NextMove, Eval, Depth) :-
  Depth < 30,
  NewDepth is Depth + 1,
  list_available_moves(Board, Player, Moves),
  bounded_best(Player, Alpha, Beta, Moves, NextMove, Eval, NewDepth), !.
alphabeta(_, _, _, Board, _, Eval, _) :-
  evaluate_board(Board, Eval, 1), !.

bounded_best(Player, Alpha, Beta, [Move|Moves], BestMove, BestEval, Depth) :-
  dechain(Move, Move1),
  move_board(Move1, Board),
  next_player(Player, NextPlayer),
  alphabeta(NextPlayer, Alpha, Beta, Board, _, Eval, Depth),
  good_enough(Player, Moves, Alpha, Beta, Move1, Eval, BestMove, BestEval, Depth).

good_enough(_, [], _, _, Move, Eval, Move, Eval, _) :- !.
good_enough(Player, _, Alpha, _, Move, Eval, Move, Eval, _) :-
  minimizing(Player), Eval > Alpha, !.
good_enough(Player, _, _, Beta, Move, Eval, Move, Eval, _) :-
  maximizing(Player), Eval < Beta, !.
good_enough(Player, Moves, Alpha, Beta, Move, Eval, BestMove, BestEval, Depth) :-
  new_bounds(Player, Alpha, Beta, Eval, NewAlpha, NewBeta),
  bounded_best(Player, NewAlpha, NewBeta, Moves, Move1, Eval1, Depth),
  better_of(Player, Move, Eval, Move1, Eval1, BestMove, BestEval).

new_bounds(Player, Alpha, Beta, Eval, Eval, Beta) :-
  minimizing(Player), Eval > Alpha, !.
new_bounds(Player, Alpha, Beta, Eval, Alpha, Eval) :-
  maximizing(Player), Eval < Beta, !.

%==============================================================================================================
%PRINTS

print_possible_moves(_, []) :- !,  nl.
print_possible_moves(Num, [m(X1,Y1,X2,Y2,_)|Moves]) :- !, 
  write(Num), write(': ('), write(X1), write(','), write(Y1),
  write(') -> ('),
  write(X2), write(','), write(Y2), write(')'), nl,
  NextNum is Num + 1,
  print_possible_moves(NextNum, Moves).
print_possible_moves(Num, [Chain|Moves]) :- !, 
  write(Num), write(': '),
  print_chain_moves(Chain),
  NextNum is Num + 1,
  print_possible_moves(NextNum, Moves).

print_chain_moves([e(X1,Y1,X2,Y2,_)]) :- !, 
  write('('), write(X1), write(','), write(Y1),
  write(') -> ('),
  write(X2), write(','), write(Y2), write(')'), nl.
print_chain_moves([e(X1,Y1,X2,Y2,_)|Chain]) :- !, 
  write('('), write(X1), write(','), write(Y1),
  write(') -> ('),
  write(X2), write(','), write(Y2), write(') -> '),
  print_chain_moves(Chain).

print_move(m(X1, Y1, X2, Y2, _)) :- !, 
  write('('), write(X1), write(','), write(Y1),
  write(') -> ('),
  write(X2), write(','), write(Y2), write(')'), nl.
print_move(e(X1, Y1, X2, Y2, _)) :- !, 
  write('('), write(X1), write(','), write(Y1),
  write(') -> ('),
  write(X2), write(','), write(Y2), write(')'), nl.

%==============================================================================================================
%MAIN

main :-
  abolish(current/2),
  board_initialize_game(Board),
  assert(current(white, Board)),
  write('\nDAMAS PROLOG!'), nl,
  write('\n    As suas pecas sao os V (no topo do tabuleiro) e as do adversario os O (no fundo)\n
    Estas tornam-se em W e Q quando sao damas\n
    Utilize as jogadas que lhe sao apresentadas com o numero da jogada seguida de um ponto (i.e: 3.)\n\n'),
  play.

play:-
    current(Player, Board),
    board_print(Board),
    make_play(Player, Board).

%Jogada do computador
make_play(white, Board) :-
    alphabeta(white, -1000, 1000, Board, NextMove, Eval, 0),
    nonvar(NextMove), !,
    write('A vez do Computador.'), nl,
    write('Avaliacao da jogada: '), write(Eval), nl,
    print_move(NextMove),                                    
    move_board(NextMove, NewBoard),
    abolish(current/2),
    assert(current(black, NewBoard)),
    play.
make_play(white, Board):-
    list_available_moves(Board, black, _), !,
    write('Parabens! Ganhaste o jogo.'),nl.
make_play(white,_):-
    write('Empate.'),nl.

%Jogada do jogador
make_play(black,Board) :-
    list_available_moves(Board, black, Moves), !,
    write('A tua vez de jogar.'), nl,
    print_possible_moves(1, Moves),
    repeat, % Keep asking the user for a valid option
    read(Option),
    nth1(Option, Moves, Move), !,
    dechain(Move,Move1),
    move_board(Move1,NewBoard),
    abolish(current/2),
    assert(current(white,NewBoard)),
    play.
make_play(black,Board) :-
    list_available_moves(Board, white, _), !,
    write('Perdeste! Tenta de novo.'),nl.
make_play(black,_):-
    write('Empate.'), nl.