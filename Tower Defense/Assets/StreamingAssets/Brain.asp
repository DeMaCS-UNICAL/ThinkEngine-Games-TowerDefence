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