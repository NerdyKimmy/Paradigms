% 59. Підрахувати кількість додатних чисел у списку та сформувати список з номерами позицій цих чисел.
:- initialization(main).

find_positives(List, Positions) :-
    find_positives(List, 0, Positions).

find_positives([], _, []).

find_positives([H|T], Index, [Index|PosT]) :-
    H > 0, !,  
    NextIndex is Index + 1,
    find_positives(T, NextIndex, PosT).

find_positives([_|T], Index, PosT) :-
    NextIndex is Index + 1,           
    find_positives(T, NextIndex, PosT).

process_input :-
    writeln('Enter a list of numbers separated by spaces:'),
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
    
    find_positives(Numbers, Positions),         
    length(Positions, Count),                  
    
    format('Count of positive numbers: ~w~n', [Count]),
    writeln('Positions of positive numbers (0-based indexing):'),
    writeln(Positions).

handle_error :-
    writeln('Error, please enter only integer nums separated by spaces'),
    process_input.

main :-
    process_input,
    halt.
