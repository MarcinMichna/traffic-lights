-module(panel).
-compile([export_all]).


print({gotoxy,X,Y}) ->
   io:format("\e[~p;~pH",[Y,X]);
print({printxy,X,Y,Msg}) ->
   io:format("\e[~p;~pH~s",[Y,X,Msg]);   
print({clear}) ->
   io:format("\e[2J",[]);
print({tlo}) ->
  print({printxy,2,4,1.2343}),  
  io:format("",[])  .
   
printxy({X,Y,Msg}) ->
   io:format("\e[~p;~pH~p~n",[Y,X,Msg]).    
main()->
  print({clear}),
  print({printxy,40,4, "Skrzyzowanie"}),
  print({printxy,5,10, "|"}),
  print({gotoxy,1,25}).  
  
   
      