-module(main).
-compile([export_all]).

main() ->
    print({clear}),
    {ok, Term} = io:read(   " a. Randomowa zmiana świateł na zielone co 2 sec.
 b. Wspisywanie zmienianych swiatel 
 c. Zmienianie najdluzej niezmienianych swiatel co 2 sec
    Wybór: "),
    A = atom_to_list(Term),
    printInit(),
    lightsInit(A).

%%%%% PROCESY %%%%%

% pojedyńcze światło
light(State, ControllerPID, LightsToRed) -> 
    receive
        red ->
            ControllerPID!{self(),red},
            light(red, ControllerPID, LightsToRed);
        green ->
            turnLights(red, LightsToRed),
            ControllerPID!{self(),green},
            light(green, ControllerPID, LightsToRed);
        change ->
            if 
                State == red ->
                    turnLights(red, LightsToRed),
                    ControllerPID!{self(),green},
                    light(green, ControllerPID, LightsToRed);
                true -> 

                    ControllerPID!{self(),red},
                    light(red, ControllerPID, LightsToRed)
            end;
        List ->
            light(State, ControllerPID, List)
    end.

% kontroler zarządzający światłami, posiada dictionary {PID, NazwaŚwiatła}
statesController(ProcessDict) ->
    receive
        {processDict, Dict} ->
            statesController(Dict);
        {PID, State} ->
            printLight(State, dict:fetch(PID, ProcessDict)),
            statesController(ProcessDict)
    end.

%%%%% FUNKCJE POMOCNICZE %%%%%

turnLights(_, []) -> ok;
turnLights(State, [PID | Rest]) -> 
    PID!State,
    turnLights(State, Rest).

lightsInit(A) ->
    % spawnowanie kontrolera świateł
    Controller = spawn(main, statesController, [[]]),
    
    % W - zachodnie swiatło
    % E - wschodnie
    % N - północne
    % S - poludniowe
    
    % R - skręt w prawo
    % L - lewo
    % S - prosto
    % C - pasy

    % spawnowanie każdego światła
    LightWR = spawn(main, light, [red, Controller, []]),
    LightWL = spawn(main, light, [red, Controller, []]),
    LightWS = spawn(main, light, [red, Controller, []]),
    LightWC = spawn(main, light, [red, Controller, []]),

    LightER = spawn(main, light, [red, Controller, []]),
    LightEL = spawn(main, light, [red, Controller, []]),
    LightES = spawn(main, light, [red, Controller, []]),
    LightEC = spawn(main, light, [red, Controller, []]),

    LightNR = spawn(main, light, [red, Controller, []]),
    LightNL = spawn(main, light, [red, Controller, []]),
    LightNS = spawn(main, light, [red, Controller, []]),
    LightNC = spawn(main, light, [red, Controller, []]),

    LightSR = spawn(main, light, [red, Controller, []]),
    LightSL = spawn(main, light, [red, Controller, []]),
    LightSS = spawn(main, light, [red, Controller, []]),
    LightSC = spawn(main, light, [red, Controller, []]),

    % wysyłanie zależnych swiateł
    LightWR![LightWC, LightSC, LightEL, LightNS],
    LightWL![LightWC, LightNC, LightNS, LightNL, LightSS, LightSL, LightES, LightER], 
    LightWS![LightWC, LightEC, LightNS, LightNL, LightSL, LightSS, LightSR, LightEL],
    LightWC![LightWL, LightWS, LightWR, LightNR, LightSL, LightES],

    LightER![LightEC, LightNC, LightWL, LightSS],
    LightEL![LightEC, LightSC, LightNL, LightNS, LightWS, LightWR, LightSS, LightSL],
    LightES![LightEC, LightWC, LightNL, LightNS, LightNR, LightWL, LightSL, LightSS],
    LightEC![LightEL, LightER, LightES, LightNL, LightWS, LightSR],

    LightNR![LightNC, LightWC, LightSL, LightES],
    LightNL![LightNC, LightEC, LightWL, LightWS, LightSS, LightSR, LightES, LightEL],
    LightNS![LightNC, LightSC, LightWL, LightWS, LightWR, LightSL, LightEL, LightES],
    LightNC![LightNL, LightNS, LightNR, LightWL, LightSS, LightER],

    LightSR![LightSC, LightEC, LightWS, LightNL],
    LightSL![LightSC, LightWC, LightNS, LightNR, LightWL, LightWS, LightES, LightEL],
    LightSS![LightSC, LightNC, LightNL, LightWL, LightWS, LightES, LightER, LightEL],
    LightSC![LightNS, LightWR, LightSS, LightSR, LightSL, LightEL],

    %tworzenie dictionary świateł
    ProcessList = [
    {LightWR, "LightWR"}, {LightWL, "LightWL"}, {LightWS, "LightWS"}, {LightWC, "LightWC"},
    {LightER, "LightER"}, {LightEL, "LightEL"}, {LightES, "LightES"}, {LightEC, "LightEC"},
    {LightNR, "LightNR"}, {LightNL, "LightNL"}, {LightNS, "LightNS"}, {LightNC, "LightNC"},
    {LightSR, "LightSR"}, {LightSL, "LightSL"}, {LightSS, "LightSS"}, {LightSC, "LightSC"}],
    ProcessDict = dict:from_list(ProcessList),
    Controller!{processDict, ProcessDict},
    
    if 
        A == "a" -> 
            lightUserInputRandom(ProcessList);
        A == "b" ->
            lightUserInput(ProcessList);
        true -> 
            LightsChangeList = [
                {LightEC, 0},{LightEL, 0},{LightWC, 0},{LightWL, 0}, 
                {LightSS, 0},{LightES, 0},{LightNL, 0},{LightER, 0},
                {LightSR, 0},{LightNS, 0},{LightNR, 0},{LightSC, 0},
                {LightNC, 0},{LightWS, 0},{LightWR, 0},{LightSL, 0}
            ],
        lightSequence(LightsChangeList)
    end,
    ok.

% opcja a.
lightUserInputRandom(ProcessList) ->
    timer:sleep(timer:seconds(2)),
    R = rand:uniform(16),
    element(1,lists:nth(R,ProcessList))!green,
    print({gotoxy,1,23}),
    lightUserInputRandom(ProcessList).

% opcja b.
lightUserInput(ProcessList) ->
    print({gotoxy,1,23}),
    {ok, Term} = io:read(""),
    print({printxy, 1, 23, "                 "}),
    search(ProcessList, string:uppercase(atom_to_list(Term)))!green,
    lightUserInput(ProcessList).

search([], _) -> ok;
search([H|T], Val) ->
    A = string:uppercase(element(2, H)),
    if 
        A == Val ->
            element(1, H);
        true -> 
            search(T, Val)
    end.

% opcja c.

% LightsChange - zliczanie cykli od zmiany świateł
% CurrentStates - aktualne stany świateł
lightSequence(LightsChange) -> 
    
    % szukanie najdłużej niezmienianych świateł
    Max = findMaxinList(LightsChange),

    % zwiększenie liczników zmiany świateł o 1
    LightsChange1 = increaseStates(LightsChange, []),

    % ustawianie nowego koloru światła
    setNewState(Max),

    % zerowanie zmienionego światła w liczniku
    LightsChange2 = decreaseChangedState(Max, LightsChange1, []),

    timer:sleep(timer:seconds(2)),
    lightSequence(LightsChange2).

increaseStates([], Result) -> Result;
increaseStates([X | Rest], Result) ->
    increaseStates(Rest, Result ++ [{element(1, X), element(2, X) + 1}]).

findMaxinList([X | Rest]) ->
    Max = findMax(X ,Rest),
    List = maxList(Max, [X] ++ Rest, []),
    lists:nth(rand:uniform(length(List)), List).

maxList(_, [], Res) -> Res;
maxList(Max, [X | Rest], Result) ->
    if 
        element(2, Max) == element(2, X) -> maxList(Max, Rest, Result ++ [X]);
        true -> maxList(Max, Rest, Result)
    end.

findMax(Current, []) -> Current;
findMax(Current, [X | Rest]) -> 
    if 
        element(2, Current) < element(2, X) -> findMax(X, Rest);
        true -> findMax(Current, Rest)
    end.

decreaseChangedState(Max, [X | Rest], Result) ->
    Key = element(1, Max),
    if 
        Key == element(1, X) -> Result ++ [{Key, 0}] ++ Rest;
        true -> decreaseChangedState(Max, Rest, Result ++ [X])
    end.
    
setNewState(Max) ->
    element(1, Max)! change.

%%%%% GUI %%%%%
print({gotoxy,X,Y}) ->
    io:format("\e[~p;~pH", [Y,X]);
print({printxy,X,Y,Msg}) ->
    io:format("\e[~p;~pH~s", [Y,X,Msg]);   
print({clear}) ->
    io:format("\e[2J", []);
print({tlo}) ->
    print({printxy, 2,4,1.2343}),  
    io:format("", [])  .
   
printxy({X,Y,Msg}) ->
    io:format("\e[~p;~pH~p~n", [Y,X,Msg]).    

printHorizontalRoad(X, Y, N) ->
    print({printxy, X, Y, lists:duplicate(N, "-")}).

printVerticalRoad(_, _, 0) -> ok;
printVerticalRoad(X, Y, N) when N > 0 -> 
    print({printxy, X, Y, "|"}),
    printVerticalRoad(X, Y - 1, N - 1).

printLight(State, "LightWR") -> printState(State, 34, 15);
printLight(State, "LightWL") -> printState(State, 34, 13);
printLight(State, "LightWS") -> printState(State, 34, 14);
printLight(State, "LightWC") -> 
    printState(State, 32, 8),
    printState(State, 32, 16);
printLight(State, "LightER") -> printState(State, 46, 9);
printLight(State, "LightEL") -> printState(State, 46, 11);
printLight(State, "LightES") -> printState(State, 46, 10);
printLight(State, "LightEC") -> 
    printState(State, 48, 8),
    printState(State, 48, 16);
printLight(State, "LightNR") -> printState(State, 36, 8);
printLight(State, "LightNL") -> printState(State, 38, 8);
printLight(State, "LightNS") -> printState(State, 37, 8);
printLight(State, "LightNC") -> 
    printState(State, 35, 7),
    printState(State, 45, 7);
printLight(State, "LightSR") -> printState(State, 44, 16);
printLight(State, "LightSL") -> printState(State, 42, 16);
printLight(State, "LightSS") -> printState(State, 43, 16);
printLight(State, "LightSC") -> 
    printState(State, 35, 17),
    printState(State, 45, 17).

printState(State, X, Y) ->
    if 
        State == red ->
            print({printxy, X, Y, "X"});
        true -> 
            print({printxy, X, Y, "O"})
    end,
    print({gotoxy,1,23}).

printInit()->
    print({clear}),
    printHorizontalRoad(0, 8, 35),
    printHorizontalRoad(0, 16, 35),
    printHorizontalRoad(45, 8, 35),
    printHorizontalRoad(45, 16, 35),
    printVerticalRoad(35, 8, 8),
    printVerticalRoad(45, 8, 8),
    printVerticalRoad(35, 23, 8),
    printVerticalRoad(45, 23, 8),
    printLight(red, "LightWR"),
    printLight(red, "LightWL"),
    printLight(red, "LightWS"),
    printLight(red, "LightWC"),
    printLight(red, "LightER"),
    printLight(red, "LightEL"),
    printLight(red, "LightES"),
    printLight(red, "LightEC"),
    printLight(red, "LightNR"),
    printLight(red, "LightNL"),
    printLight(red, "LightNS"),
    printLight(red, "LightNC"),
    printLight(red, "LightSR"),
    printLight(red, "LightSL"),
    printLight(red, "LightSS"),
    printLight(red, "LightSC"),
    print({gotoxy,1,23}).
