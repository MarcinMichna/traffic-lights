# Traffic Lights simulation

Simulation is written in Erlang, every light works on his own process. <br>
Main task is to control and synchronize those processes.


Simulation modes:<br>
a) randomly changing lights<br>
b) writing which lights to change <br>
 <p> Pattern: <br>
     lightXY <br>
     X - {W - west, E - east, N - north, S- south}
     Y - {S - going Straight, L - left, R - right, C - crossing}</p>
c) changing longest not changes lights<br>

To choose option write letter and dot in menu. For example a. or b.<br>

Example: <br>
O - green<br>
X - red<br>
![](demo.png)
