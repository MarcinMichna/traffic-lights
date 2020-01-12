-module(panel).
-compile([export_all]).


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

printLight(State, "LightWR") -> printState(State, 34, 13);
printLight(State, "LightWL") -> printState(State, 34, 15);
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
printLight(State, "LightSR") -> printState(State, 42, 16);
printLight(State, "LightSL") -> printState(State, 44, 16);
printLight(State, "LightSS") -> printState(State, 43, 16);
printLight(State, "LightSC") -> 
    printState(State, 35, 17),
    printState(State, 45, 17).

printState(State, X, Y) ->
    if 
        State == red ->
            print({printxy, X, Y, "R"});
        true -> 
            print({printxy, X, Y, "G"})
    end.

main()->
    print({clear}),
    printHorizontalRoad(0, 8, 35),
    printHorizontalRoad(0, 16, 35),
    printHorizontalRoad(45, 8, 35),
    printHorizontalRoad(45, 16, 35),
    printVerticalRoad(35, 8, 8),
    printVerticalRoad(45, 8, 8),
    printVerticalRoad(35, 23, 8),
    printVerticalRoad(45, 23, 8),
    % DEBUG
    % printLight(red, "LightWR"),
    % printLight(red, "LightWL"),
    % printLight(red, "LightWS"),
    % printLight(red, "LightWC"),
    % printLight(red, "LightER"),
    % printLight(red, "LightEL"),
    % printLight(red, "LightES"),
    % printLight(red, "LightEC"),
    % printLight(red, "LightNR"),
    % printLight(red, "LightNL"),
    % printLight(red, "LightNS"),
    % printLight(red, "LightNC"),
    % printLight(red, "LightSR"),
    % printLight(red, "LightSL"),
    % printLight(red, "LightSS"),
    % printLight(red, "LightSC"),
    print({gotoxy,1,23}).  
  
   
