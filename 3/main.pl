% 2 (9 балів). Виявити продуктивні та непродуктивні стани скінченого автомату. 
:- initialization(main).

:- dynamic state/1.
:- dynamic final_state/1.
:- dynamic transition/3.

load_automaton(FileName) :-
    retractall(state(_)),
    retractall(final_state(_)),
    retractall(transition(_, _, _)),
    
    setup_call_cleanup(
        open(FileName, read, Stream),
        process_stream(Stream),
        close(Stream)
    ).

process_stream(Stream) :-
    read_line_to_string(Stream, StatesLine),
    split_string(StatesLine, " ", " \t\r\n", StatesStr),
    maplist(assert_state, StatesStr),
    
    read_line_to_string(Stream, FinalsLine),
    split_string(FinalsLine, " ", " \t\r\n", FinalsStr),
    maplist(assert_final, FinalsStr),
    
    read_transitions(Stream).

assert_state(S) :- atom_string(Atom, S), assertz(state(Atom)).
assert_final(S) :- atom_string(Atom, S), assertz(final_state(Atom)).

read_transitions(Stream) :-
    read_line_to_string(Stream, Line),
    (   Line == end_of_file
    ->  true
    ;   split_string(Line, " ", " \t\r\n", Parts),
        (   Parts = [S1, Sym, S2]
        ->  atom_string(A1, S1), 
            atom_string(ASym, Sym), 
            atom_string(A2, S2),
            assertz(transition(A1, ASym, A2))
        ;   true
        ),
        read_transitions(Stream)
    ).

is_productive(State) :-
    can_reach_final(State, []).

can_reach_final(State, _) :-
    final_state(State).

can_reach_final(State, Visited) :-
    transition(State, _, NextState),
    \+ member(NextState, Visited),
    can_reach_final(NextState, [State | Visited]).

is_unproductive(State) :-
    state(State),
    \+ is_productive(State).

analyze_automaton :-
    (setof(S, (state(S), is_productive(S)), Prod) -> true ; Prod = []),
    (setof(S, (state(S), is_unproductive(S)), Unprod) -> true ; Unprod = []),
    
    writeln('Результати аналізу автомата'),
    format('Продуктивні стани:   ~w~n', [Prod]),
    format('Непродуктивні стани: ~w~n', [Unprod]).

main :-
    current_prolog_flag(argv, Args),
    (   Args = [Arg | _] 
    -> 
        FileName = Arg
    ;
        writeln('Файл:'),
        read_line_to_string(user_input, Input),
        (   Input == ""
        ->  FileName = '1.txt' 
        ;   FileName = Input
        )
    ),

    (   exists_file(FileName)
    ->  load_automaton(FileName),
        analyze_automaton
    ;   format('Помилка: Файл "~w" не знайдено! ~n', [FileName])
    ),
    halt.
