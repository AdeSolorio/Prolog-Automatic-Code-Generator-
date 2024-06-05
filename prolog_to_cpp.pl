% prolog_to_cpp.pl

% Traducción de la entrada completa
translate_input(Input, Output) :-
    translate_multiple(Input, Output).

% Traducción de una asignación
translate(assign(Var, Val), CppCode) :-
    translate_expr(Val, ValCode),
    format(string(CppCode), "~w = ~w;", [Var, ValCode]).

% Traducción de operaciones aritméticas
translate_expr(add(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w + ~w", [ACode, BCode]).
translate_expr(sub(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w - ~w", [ACode, BCode]).
translate_expr(mul(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w * ~w", [ACode, BCode]).
translate_expr(div(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w / ~w", [ACode, BCode]).
translate_expr(lt(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w < ~w", [ACode, BCode]).
translate_expr(gt(A, B), CppCode) :-
    translate_expr(A, ACode),
    translate_expr(B, BCode),
    format(string(CppCode), "~w > ~w", [ACode, BCode]).
translate_expr(Value, CppCode) :-
    format(string(CppCode), "~w", [Value]).

% Traducción de un bucle for
translate(loop(Index, Start, End, Body), CppCode) :-
    % Traducimos cada instrucción del cuerpo del bucle
    translate_body(Body, BodyCode),
    % Formamos el código del bucle for
    format(string(CppCode), "for (int ~w = ~w; ~w < ~w; ~w++) {\n~w\n}", [Index, Start, Index, End, Index, BodyCode]).

% Traducción de una declaración if
translate(if(Condition, ThenBody, ElseBody), CppCode) :-
    translate_expr(Condition, ConditionCode),
    translate_body(ThenBody, ThenBodyCode),
    translate_body(ElseBody, ElseBodyCode),
    % Formamos el código de la declaración if
    format(string(CppCode), "if (~w) {\n~w\n} else {\n~w\n}", [ConditionCode, ThenBodyCode, ElseBodyCode]).

% Traducción de un bucle while
translate(while(Condition, Body), CppCode) :-
    translate_expr(Condition, ConditionCode),
    translate_body(Body, BodyCode),
    % Formamos el código del bucle while
    format(string(CppCode), "while (~w) {\n~w\n}", [ConditionCode, BodyCode]).

% Traducción de una función
translate(function(Name, Params, Body), CppCode) :-
    atomic_list_concat(Params, ', ', ParamsString),
    translate_body(Body, BodyCode),
    % Asumimos retorno de tipo 'void' para simplicidad
    format(string(CppCode), "void ~w(~w) {\n~w\n}", [Name, ParamsString, BodyCode]).

% Traducción de una lista de instrucciones (cuerpo del bucle, cuerpos if, o cuerpos de función)
translate_body([], "").

translate_body([Instruction|Rest], CppCode) :-
    translate(Instruction, InstructionCode),
    % Traducimos el resto del cuerpo
    translate_body(Rest, RestCode),
    % Formamos el código del cuerpo con la indentación correcta
    split_string(InstructionCode, "\n", "", InstructionLines),
    maplist(indent, InstructionLines, IndentedLines),
    atomic_list_concat(IndentedLines, "\n", IndentedCode),
    string_concat(IndentedCode, "\n", InstructionWithNewline),
    string_concat(InstructionWithNewline, RestCode, CppCode).

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
translate(return(Val), CppCode) :-
    translate_expr(Val, ValCode),
    format(string(CppCode), "return ~w;", [ValCode]).

% Diego Espejo - 28/05/2024