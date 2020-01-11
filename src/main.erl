-module(main).
-compile([export_all]).

main() ->
    lightsInit().

%%%%% PROCESY %%%%%

% pojedyńcze światło
light(State, LightsToRed) -> 
    receive
        red ->
            light(red, LightsToRed);
        green ->
            if 
                State == red ->
                    turnLights(red, LightsToRed);
                true -> ok
            end,
            light(green, LightsToRed);
        List ->
            light(State, List)
    end.


% kontroler zarządzający światłami, posiada dictionary {PID, NazwaŚwiatła}
statesController(ProcessDict) -> todo.




%%%%% FUNKCJE POMOCNICZE %%%%%


turnLights(_, []) -> ok;
turnLights(State, [PID | Rest]) -> 
    PID!State,
    turnLights(State, Rest).

lightsInit() ->
    % W - zachodnie swiatło
    % E - wschodnie
    % N - północne
    % S - poludniowe
    
    % R - skręt w prawo
    % L - lewo
    % S - prosto
    % C - pasy

    % spawnowanie każdego światła
    LightWR = spawn(main, light, [red, []]),
    LightWL = spawn(main, light, [red, []]),
    LightWS = spawn(main, light, [red, []]),
    LightWC = spawn(main, light, [red, []]),

    LightER = spawn(main, light, [red, []]),
    LightEL = spawn(main, light, [red, []]),
    LightES = spawn(main, light, [red, []]),
    LightEC = spawn(main, light, [red, []]),

    LightNR = spawn(main, light, [red, []]),
    LightNL = spawn(main, light, [red, []]),
    LightNS = spawn(main, light, [red, []]),
    LightNC = spawn(main, light, [red, []]),

    LightSR = spawn(main, light, [red, []]),
    LightSL = spawn(main, light, [red, []]),
    LightSS = spawn(main, light, [red, []]),
    LightSC = spawn(main, light, [red, []]),

    % wysyłanie zależnych swiateł
    LightWR![LightWC, LightSC, LightEL, LightNS],
    LightWL![LightWC, LightNC, LightNS, LightNL, LightSS, LightSL, LightES, LightER], 
    LightWS![LightWC, LightEC, LightNS, LightNL, LightSL, LightSS, LightSR, LightEL],
    LightWC![LightNL, LightNS, LightNR, LightNR, LightSL, LightES],

    LightER![LightEC, LightNC, LightWL, LightSS],
    LightEL![LightEC, LightSC, LightNL, LightNS, LightWS, LightWR, LightSS, LightSL],
    LightES![LightEC, LightWC, LightNL, LightNS, LightNR, LightWL, LightSL, LightSS],
    LightEC![LightEL, LightER, LightES, LightNL, LightWS, LightSR],

    LightNR![LightNC, LightWC, LightSL, LightES],
    LightNL![LightNC, LightEC, LightWL, LightWS, LightSS, LightSR, LightES, LightEL],
    LightNS![LightNC, LightSC, LightWL, LightWS, LightWR, LightSL, LightEL, LightES],
    LightNC![LightNL, LightNS, LightNS, LightWL, LightSS, LightER],

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

    % spawnowanie kontrolera świateł
    spawn(main, statesController, [ProcessDict]),
    ok.