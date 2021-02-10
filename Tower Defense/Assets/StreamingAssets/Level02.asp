%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly
%enemySensors(enemySimple,objectIndex(X),enemySensorData(health(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(type(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(x(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(y(V))).
%nodeSensor(node1,objectIndex(X),nodeSensor(turretTypeName(V))).
%nodeSensor(node1,objectIndex(X),nodeSensor(x(V))).
%nodeSensor(node1,objectIndex(X),nodeSensor(y(V))).
%player(gameMaster,objectIndex(X),playerStats(money(V))).
%player(gameMaster,objectIndex(X),playerStats(lives(V))).

% ===== Input Transforming ===== %
    node(ID, X, Y, TurretType) :-
    
        nodeSensor(_,objectIndex(ID),nodeSensorData(turretTypeName(TurretType))),
        nodeSensor(_,objectIndex(ID),nodeSensorData(x(X))),
        nodeSensor(_,objectIndex(ID),nodeSensorData(y(Y))).

    budget(Value) :- player(gameMaster,objectIndex(X),playerStats(money(Value))).

% ===== List possible builds ===== %
possibleBuild(X, Y, standardTurret) :- node(_, X, Y, none), Value >= Price, cost(standardTurret, Price), budget(Value).
possibleBuild(X, Y, missileLauncher) :- node(_, X, Y, none), Value >= Price, cost(missileLauncher, Price), budget(Value).
possibleBuild(X, Y, laserBeamer) :- node(_, X, Y, none), Value >= Price, cost(laserBeamer, Price), budget(Value).

% ===== List possible upgrades ===== %
possibleBuild(X, Y, standardTurretUpgraded) :- node(_, X, Y, standardTurret), Value >= Price, cost(standardTurretUpgraded, Price), budget(Value).
possibleBuild(X, Y, missileLauncherUpgraded) :- node(_, X, Y, missileLauncher), Value >= Price, cost(missileLauncherUpgraded, Price), budget(Value).
possibleBuild(X, Y, laserBeamerUpgraded) :- node(_, X, Y, laserBeamerUpgraded), Value >= Price, cost(laserBeamerUpgraded, Price), budget(Value).

% ===== Guess phase===== %
{build(X, Y, Turret) : possibleBuild(X, Y, Turret)}=1.

% ===== Do not exceed budget ===== %
expense(Money) :- build(_, _, Turret), cost(Turret, Money).
:- expense(Money), budget(Value), Value < Money.

% ===== Don’t be stingy! =====%
:~ expense(Money), budget(Value), RemainingMoney = Value - Money. [RemainingMoney@2]

% ===== Which is the best position to place the turret? ===== %
nodePositionCoefficient(NodeX, NodeY, Value) :- build(NodeX, NodeY, _),#count{ X, Y : adjacent(NodeX, NodeY, X, Y), path(X, Y)} = Paths, #count{ X, Y : adjacent(NodeX, NodeY, X, Y), node(_, X, Y, Turret), Turret != none} = NotEmpty,	Value = Paths - NotEmpty.
:~ nodePositionCoefficient(NodeX, NodeY, Value), Cost=8-Value. [Cost@1]
:~ node(ID,X,Y,_),build(X,Y,_). [ID]

% ===== Set actuator literals ===== %

setOnActuator(brainAct(level00,objectIndex(ID),aI(x(X)))):-objectIndex(brainAct,ID),build(X, _, _).
setOnActuator(brainAct(level00,objectIndex(ID),aI(y(Y)))):-objectIndex(brainAct,ID),build(_, Y, _).
setOnActuator(brainAct(level00,objectIndex(ID),aI(turretTypeName(T)))):-objectIndex(brainAct,ID),build(_, _, T).


% cost
    cost(standardTurret, 100). 
    cost(standardTurretUpgraded, 60).
    cost(missileLauncher, 250).
    cost(missileLauncherUpgraded, 150).
    cost(laserBeamer, 350).
    cost(laserBeamerUpgraded, 250).
% Paths
	path(1,2).
	path(2,2).
	path(3,2).
	path(4,2).
	path(5,2).
	path(6,1).
	path(6,2).
	path(7,1).
	path(8,1).

% Others
	start(1,1). end(8,2).


% Adjacents
	adjacent(0,0,0,1).
	adjacent(0,0,1,0).
	adjacent(0,0,1,1).
	adjacent(0,1,0,0).
	adjacent(0,1,0,2).
	adjacent(0,1,1,0).
	adjacent(0,1,1,1).
	adjacent(0,1,1,2).
	adjacent(0,2,0,1).
	adjacent(0,2,0,3).
	adjacent(0,2,1,1).
	adjacent(0,2,1,2).
	adjacent(0,2,1,3).
	adjacent(0,3,0,2).
	adjacent(0,3,1,2).
	adjacent(0,3,1,3).
	adjacent(1,0,1,1).
	adjacent(1,0,2,0).
	adjacent(1,0,2,1).
	adjacent(1,1,1,0).
	adjacent(1,1,1,2).
	adjacent(1,1,2,0).
	adjacent(1,1,2,1).
	adjacent(1,1,2,2).
	adjacent(1,2,1,1).
	adjacent(1,2,1,3).
	adjacent(1,2,2,1).
	adjacent(1,2,2,2).
	adjacent(1,2,2,3).
	adjacent(1,3,1,2).
	adjacent(1,3,2,2).
	adjacent(1,3,2,3).
	adjacent(2,0,1,0).
	adjacent(2,0,1,1).
	adjacent(2,0,2,1).
	adjacent(2,0,3,0).
	adjacent(2,0,3,1).
	adjacent(2,1,1,0).
	adjacent(2,1,1,1).
	adjacent(2,1,1,2).
	adjacent(2,1,2,0).
	adjacent(2,1,2,2).
	adjacent(2,1,3,0).
	adjacent(2,1,3,1).
	adjacent(2,1,3,2).
	adjacent(2,2,1,1).
	adjacent(2,2,1,2).
	adjacent(2,2,1,3).
	adjacent(2,2,2,1).
	adjacent(2,2,2,3).
	adjacent(2,2,3,1).
	adjacent(2,2,3,2).
	adjacent(2,2,3,3).
	adjacent(2,3,1,2).
	adjacent(2,3,1,3).
	adjacent(2,3,2,2).
	adjacent(2,3,3,2).
	adjacent(2,3,3,3).
	adjacent(3,0,2,0).
	adjacent(3,0,2,1).
	adjacent(3,0,3,1).
	adjacent(3,0,4,0).
	adjacent(3,0,4,1).
	adjacent(3,1,2,0).
	adjacent(3,1,2,1).
	adjacent(3,1,2,2).
	adjacent(3,1,3,0).
	adjacent(3,1,3,2).
	adjacent(3,1,4,0).
	adjacent(3,1,4,1).
	adjacent(3,1,4,2).
	adjacent(3,2,2,1).
	adjacent(3,2,2,2).
	adjacent(3,2,2,3).
	adjacent(3,2,3,1).
	adjacent(3,2,3,3).
	adjacent(3,2,4,1).
	adjacent(3,2,4,2).
	adjacent(3,2,4,3).
	adjacent(3,3,2,2).
	adjacent(3,3,2,3).
	adjacent(3,3,3,2).
	adjacent(3,3,4,2).
	adjacent(3,3,4,3).
	adjacent(4,0,3,0).
	adjacent(4,0,3,1).
	adjacent(4,0,4,1).
	adjacent(4,0,5,0).
	adjacent(4,0,5,1).
	adjacent(4,1,3,0).
	adjacent(4,1,3,1).
	adjacent(4,1,3,2).
	adjacent(4,1,4,0).
	adjacent(4,1,4,2).
	adjacent(4,1,5,0).
	adjacent(4,1,5,1).
	adjacent(4,1,5,2).
	adjacent(4,2,3,1).
	adjacent(4,2,3,2).
	adjacent(4,2,3,3).
	adjacent(4,2,4,1).
	adjacent(4,2,4,3).
	adjacent(4,2,5,1).
	adjacent(4,2,5,2).
	adjacent(4,2,5,3).
	adjacent(4,3,3,2).
	adjacent(4,3,3,3).
	adjacent(4,3,4,2).
	adjacent(4,3,5,2).
	adjacent(4,3,5,3).
	adjacent(5,0,4,0).
	adjacent(5,0,4,1).
	adjacent(5,0,5,1).
	adjacent(5,0,6,0).
	adjacent(5,0,6,1).
	adjacent(5,1,4,0).
	adjacent(5,1,4,1).
	adjacent(5,1,4,2).
	adjacent(5,1,5,0).
	adjacent(5,1,5,2).
	adjacent(5,1,6,0).
	adjacent(5,1,6,1).
	adjacent(5,1,6,2).
	adjacent(5,2,4,1).
	adjacent(5,2,4,2).
	adjacent(5,2,4,3).
	adjacent(5,2,5,1).
	adjacent(5,2,5,3).
	adjacent(5,2,6,1).
	adjacent(5,2,6,2).
	adjacent(5,2,6,3).
	adjacent(5,3,4,2).
	adjacent(5,3,4,3).
	adjacent(5,3,5,2).
	adjacent(5,3,6,2).
	adjacent(5,3,6,3).
	adjacent(6,0,5,0).
	adjacent(6,0,5,1).
	adjacent(6,0,6,1).
	adjacent(6,0,7,0).
	adjacent(6,0,7,1).
	adjacent(6,1,5,0).
	adjacent(6,1,5,1).
	adjacent(6,1,5,2).
	adjacent(6,1,6,0).
	adjacent(6,1,6,2).
	adjacent(6,1,7,0).
	adjacent(6,1,7,1).
	adjacent(6,1,7,2).
	adjacent(6,2,5,1).
	adjacent(6,2,5,2).
	adjacent(6,2,5,3).
	adjacent(6,2,6,1).
	adjacent(6,2,6,3).
	adjacent(6,2,7,1).
	adjacent(6,2,7,2).
	adjacent(6,2,7,3).
	adjacent(6,3,5,2).
	adjacent(6,3,5,3).
	adjacent(6,3,6,2).
	adjacent(6,3,7,2).
	adjacent(6,3,7,3).
	adjacent(7,0,6,0).
	adjacent(7,0,6,1).
	adjacent(7,0,7,1).
	adjacent(7,0,8,0).
	adjacent(7,0,8,1).
	adjacent(7,1,6,0).
	adjacent(7,1,6,1).
	adjacent(7,1,6,2).
	adjacent(7,1,7,0).
	adjacent(7,1,7,2).
	adjacent(7,1,8,0).
	adjacent(7,1,8,1).
	adjacent(7,1,8,2).
	adjacent(7,2,6,1).
	adjacent(7,2,6,2).
	adjacent(7,2,6,3).
	adjacent(7,2,7,1).
	adjacent(7,2,7,3).
	adjacent(7,2,8,1).
	adjacent(7,2,8,2).
	adjacent(7,2,8,3).
	adjacent(7,3,6,2).
	adjacent(7,3,6,3).
	adjacent(7,3,7,2).
	adjacent(7,3,8,2).
	adjacent(7,3,8,3).
	adjacent(8,0,7,0).
	adjacent(8,0,7,1).
	adjacent(8,0,8,1).
	adjacent(8,0,9,0).
	adjacent(8,0,9,1).
	adjacent(8,1,7,0).
	adjacent(8,1,7,1).
	adjacent(8,1,7,2).
	adjacent(8,1,8,0).
	adjacent(8,1,8,2).
	adjacent(8,1,9,0).
	adjacent(8,1,9,1).
	adjacent(8,1,9,2).
	adjacent(8,2,7,1).
	adjacent(8,2,7,2).
	adjacent(8,2,7,3).
	adjacent(8,2,8,1).
	adjacent(8,2,8,3).
	adjacent(8,2,9,1).
	adjacent(8,2,9,2).
	adjacent(8,2,9,3).
	adjacent(8,3,7,2).
	adjacent(8,3,7,3).
	adjacent(8,3,8,2).
	adjacent(8,3,9,2).
	adjacent(8,3,9,3).
	adjacent(9,0,8,0).
	adjacent(9,0,8,1).
	adjacent(9,0,9,1).
	adjacent(9,1,8,0).
	adjacent(9,1,8,1).
	adjacent(9,1,8,2).
	adjacent(9,1,9,0).
	adjacent(9,1,9,2).
	adjacent(9,2,8,1).
	adjacent(9,2,8,2).
	adjacent(9,2,8,3).
	adjacent(9,2,9,1).
	adjacent(9,2,9,3).
	adjacent(9,3,8,2).
	adjacent(9,3,8,3).
	adjacent(9,3,9,2).
