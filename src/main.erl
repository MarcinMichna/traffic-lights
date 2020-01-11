-module(main).
-compile([export_all]).


light(State, LightsToRed) -> 
    receive
        red ->
            if
                State == green ->
                    State = red,
                    turnLights(red, LightsToRed)
            end,
            light(State, LightsToRed);
        green ->
            if 
                State == red ->
                    State = green
            end,
            light(State, LightsToRed);
        List ->
            io:format("got List"),
            light(State, List)
    end.


turnLights(State, List) -> todo.

lightsInit() ->
    % W - zachodnie swiatło
    % E - wschodnie
    % N - północne
    % S - poludniowe
    
    % R - skręt w prawo
    % L - lewo
    % S - prosto
    % C - pasy

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

    LightWR![LightWC, LightSC, LightEL, LightNS],
    LightWL![], 
    LightWS![],
    LightWC![],

    LightER![LightEC, LightNC, LightWL, LightSS],
    LightEL![],
    LightES![],
    LightEC![],

    LightNR![LightNC, LightWC, LightSL, LightES],
    LightNL![],
    LightNS![],
    LightNC![],

    LightSR![LightSC, LightEC, LightWS, LightNL],
    LightSL![],
    LightSS![],
    LightSC![],

    ok.
