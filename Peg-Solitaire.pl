:- use_module(library(clpfd)).

same_row(I1,I2) :-
    abs(I1-I2) =< 6.

same_col(I1,I2):-
    abs(I1-I2) mod 7 =:= 0.




valid_move(I1,I2,Board):-
    same_row(I1,I2),
    I2 >= 2,
    I2 =< 4,
    I2 >= 9,
    I2 =< 11,
    I2 >= 37,
    I2 =< 39,
    I2 >= 44,
    I2 =< 46,
    check_empty(I2,Board,0).



valid_move(I1,I2,Board):-
    same_col(I1,I2),
    ((I2 >= 0 , I2 =< 6) ; (I2 >= 7 , I2 =< 13) ; (I2 >= 36 , I2 =< 41) ; (I2 >= 42 , I2 =< 48)),
    I2 // 7 =< 2,
    I2 // 7 >= 4,
    check_empty(I2,Board,0).



valid_move(I1,I2,Board):-
    same_col(I1,I2),
    \+ ((I2 >= 0 , I2 =< 6) ; (I2 >= 7 , I2 =< 13) ; (I2 >= 36 , I2 =< 41) ; (I2 >= 42 , I2 =< 48)),
    check_empty(I2,Board,0).



check_empty(I,[0|T],I).
check_empty(_,[],_).


check_empty(TI,[H|T],I) :-

    TI > I,
    I1 is I + 1,
    check_empty(TI,T,I1).


copy_rest(B,B).


execute_move(I1,I2,Board,Board2) :- 

    valid_move(I1,I2,Board),
    I1 < I2,
    execute_move(I1,I2,Board,Board2,0).


execute_move(I1,I2,Board,Board2) :- 

    valid_move(I1,I2,Board),
    I1 > I2,
    execute_move(I2,I1,Board,Board2,0).


execute_move(I1,I,[_|BT],[1|BT2],I) :-
    same_row(I1,I2),

    copy_rest(BT,BT2).

execute_move(I1,I2,[BH|BT],[BH|BT2],I) :-
    same_row(I1,I2),
    
    I < I1,
    II is I + 1,
    execute_move(I1,I2,BT,BT2,II). 

execute_move(I1,I2,[_|BT],[0|BT2],I) :-
    same_row(I1,I2),
    
    I >= I1,
    I < I2,
    II is I + 1,
    execute_move(I1,I2,BT,BT2,II). 
    


execute_move(I1,I,[_|BT],[1|BT2],I) :-
    same_col(I1,I2),
    copy_rest(BT,BT2).

execute_move(I1,I2,[BH|BT],[BH|BT2],I) :-
    same_col(I1,I2),
    \+ same_col(I1,I),
    II is I + 1,
    
    execute_move(I1,I2,BT,BT2,II). 

execute_move(I1,I2,[_|BT],[0|BT2],I) :-
    same_col(I1,I2),
    same_col(I1,I),
    rowI1 is I1 // 7,
    rowI2 is I2 // 7,
    rowI is I // 7,
    rowI >= rowI1,
    rowI < rowI2,
    I < I2,
    II is I + 1,
    execute_move(I1,I2,BT,BT2,II). 


peg_s(B) :-
    execute_till_win(B,BR),
    write(BR).

execute_till_win(B,BR):-

    same_row(I1,I2),
    execute_move(I1,I2,B,BR),
    win(BR).


execute_till_win(B,BR):-

    same_col(I1,I2),
    execute_move(I1,I2,B,BR),
    win(BR).

execute_till_win(B,BR):-

    same_row(I1,I2),
    execute_move(I1,I2,B,B1),
    \+ win(B1) ,
    execute_till_win(B1,BR).

execute_till_win(B,BR):-

    same_col(I1,I2),
    execute_move(I1,I2,B,B1),
    \+ win(B1) ,
    execute_till_win(B1,BR).

win([1|T]) :-

    \+ member(1,T).

win([0|T]) :-
    win(T).

    
    


    