% prolog_to_python.pl

% Traducción de la entrada completa
translate_input(Input, Output) :-
    translate_multiple(Input, Output).

% Traducción de una asignación
translate(assign(Var, Val), PythonCode) :-
    translate_expr(Val, ValCode),
    format(string(PythonCode), "~w = ~w", [Var, ValCode]).

% Traducción de operaciones aritméticas
translate_expr(add(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w + ~w", [ACode, BCode]).
translate_expr(sub(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w - ~w", [ACode, BCode]).
translate_expr(mul(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w * ~w", [ACode, BCode]).
translate_expr(div(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w / ~w", [ACode, BCode]).
translate_expr(lt(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w < ~w", [ACode, BCode]).
translate_expr(gt(A, B), PythonCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(PythonCode), "~w > ~w", [ACode, BCode]).
translate_expr(Value, PythonCode) :-
    format(string(PythonCode), "~w", [Value]).

% Traducción de un bucle for
translate(loop(Index, Start, End, Body), PythonCode) :-
    % Traducimos cada instrucción del cuerpo del bucle
    translate_body(Body, BodyCode),
    % Formamos el código del bucle
    format(string(PythonCode), "for ~w in range(~w, ~w):\n~w", [Index, Start, End, BodyCode]).

% Traducción de una declaración if
translate(if(Condition, ThenBody, ElseBody), PythonCode) :-
    translate_expr(Condition, ConditionCode),
    translate_body(ThenBody, ThenBodyCode),
    translate_body(ElseBody, ElseBodyCode),
    % Formamos el código de la declaración if
    format(string(PythonCode), "if ~w:\n~welse:\n~w", [ConditionCode, ThenBodyCode, ElseBodyCode]).

% Traducción de un bucle while
translate(while(Condition, Body), PythonCode) :-
    translate_expr(Condition, ConditionCode),
    translate_body(Body, BodyCode),
    % Formamos el código del bucle while
    format(string(PythonCode), "while ~w:\n~w", [ConditionCode, BodyCode]).

% Traducción de una función
translate(function(Name, Params, Body), PythonCode) :-
    atomic_list_concat(Params, ', ', ParamsString),
    translate_body(Body, BodyCode),
    % Formamos el código de la función
    format(string(PythonCode), "def ~w(~w):\n~w", [Name, ParamsString, BodyCode]).

% Traducción de una lista de instrucciones (cuerpo del bucle o cuerpos if)
translate_body([], "").

translate_body([Instruction|Rest], PythonCode) :-
    translate(Instruction, InstructionCode),
    % Traducimos el resto del cuerpo
    translate_body(Rest, RestCode),
    % Formamos el código del cuerpo con la indentación correcta
    split_string(InstructionCode, "\n", "", InstructionLines),
    maplist(indent, InstructionLines, IndentedLines),
    atomic_list_concat(IndentedLines, "\n", IndentedCode),
    string_concat(IndentedCode, "\n", InstructionWithNewline),
    string_concat(InstructionWithNewline, RestCode, PythonCode).

% Indentar una línea de código
indent(Line, IndentedLine) :-
    string_concat("    ", Line, IndentedLine).

% Caso base para multiples instrucciones
translate_multiple([], "").
translate_multiple([H|T], Result) :-
    translate(H, HCode),
    translate_multiple(T, TCode),
    format(string(Result), "~w\n~w", [HCode, TCode]).

% Traducción de return
translate(return(Val), PythonCode) :-
    translate_expr(Val, ValCode),
    format(string(PythonCode), "return ~w", [ValCode]).

% Diego Espejo - 28/05/2024