/* 29. Розбити заданий список на кілька списків, записуючи у перший список значення, які менші за 1!, у другий
– які менші за 2! та не потрапили до попереднього списку, у третій – які менші за 3! та не потрапили до
двох попередніх списків, у четвертий – які менші за 4! та не потрапили до попередніх списків і т.д. */
:- initialization(main).

split_by_factorials(List, Result) :-
    split_by_factorials(List, 1, 1, Result).

split_by_factorials([], _, _, []).
split_by_factorials(List, N, Fact, [Less|RestResult]) :-
    List \= [],
    split_less_greater(List, Fact, Less, Greater), 
    NextN is N + 1,
    NextFact is Fact * NextN, 
    split_by_factorials(Greater, NextN, NextFact, RestResult).

split_less_greater([], _, [], []).

split_less_greater([H|T], Limit, [H|LessT], Greater) :-
    H < Limit, !,                                
    split_less_greater(T, Limit, LessT, Greater).

split_less_greater([H|T], Limit, Less, [H|GreaterT]) :-
                                                
    split_less_greater(T, Limit, Less, GreaterT).

process_input :-
    writeln('Введіть список цілих чисел через пробіл:'),
    read_line_to_string(user_input, Input),
    (   Input == end_of_file
    ->  halt
    ;
        (   catch(process_numbers(Input), _, fail)
        ->  true
        ;   handle_error
        )
    ).

process_numbers(Input) :-
    split_string(Input, " ", " ", StringWords),
    maplist(number_string, Numbers, StringWords),  
    
    split_by_factorials(Numbers, Result),
    
    writeln('Результат розбиття списку за факторіалами:'),
    writeln(Result).

handle_error :-
    writeln('Помилка, будь ласка, введіть тільки цілі числа через пробіл.'),
    process_input.

main :-
    process_input,
    halt.
