% 21. Залишити у списку елементи, що входять у нього двічі.
:- initialization(main).

count_occurrences(_, [], 0).
count_occurrences(X, [Y|T], N) :-
    X =:= Y, !,
    count_occurrences(X, T, N1),
    N is N1 + 1.
count_occurrences(X, [_|T], N) :-
    count_occurrences(X, T, N).

keep_twice(List, Result) :-
    keep_twice(List, List, Result).

keep_twice([], _, []).
keep_twice([H|T], OriginalList, [H|ResultT]) :-
    count_occurrences(H, OriginalList, 2),
    !,
    keep_twice(T, OriginalList, ResultT).
keep_twice([_|T], OriginalList, ResultT) :-
    keep_twice(T, OriginalList, ResultT).

process_input :-
    writeln('Введіть список номерів'),
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
    maplist(number_string, Numbers, StringWords), % Якщо тут букви — він просто поверне false
    keep_twice(Numbers, Result),
    writeln('List after keeping elements that appear exactly twice:'),
    writeln(Result).

handle_error :-
    writeln('Error, please enter only integer nums separated by spaces'),
    process_input.

main :-
    process_input,
    halt.
