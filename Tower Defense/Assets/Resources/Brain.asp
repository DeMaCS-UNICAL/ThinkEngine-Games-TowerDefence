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
    enemy(ID, X, Y, Health, Type) :-
    
        enemySensors(_,objectIndex(ID),enemySensorData(health(Health))),
        enemySensors(_,objectIndex(ID),enemySensorData(type(Type))),
        enemySensors(_,objectIndex(ID),enemySensorData(x(X))),
        enemySensors(_,objectIndex(ID),enemySensorData(y(Y))).

    
        %enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(health(Health)))))),
        %enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(type(Type)))))),
        %enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(x(X)))))),
        %enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(y(Y)))))).

    node(ID, X, Y, TurretType) :-
    
        nodeSensor(_,objectIndex(ID),nodeSensorData(turretTypeName(TurretType))),
        nodeSensor(_,objectIndex(ID),nodeSensorData(x(X))),
        nodeSensor(_,objectIndex(ID),nodeSensorData(y(Y))).

    
       % nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensor(turretTypeName(TurretType)))))),
       % nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensor(x(X)))))),
       % nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensor(y(Y)))))).

    money(Value) :- player(gameMaster,objectIndex(X),playerStats(money(Value))).
    
    %player(gameMaster(playerStats(money(Value)))).

% Do not build if there is no enemy
:- #count{ID : enemy(ID, _, _, _, _)} = 0.

% List possible builds
possibleBuild(X, Y, standardTurret) :- node(_, X, Y, none), money >= Price, cost(standardTurret, Price), money(Money).
possibleBuild(X, Y, missileLauncher) :- node(_, X, Y, none), money >= Price, cost(missileLauncher, Price), money(Money).
possibleBuild(X, Y, laserBeamer) :- node(_, X, Y, none), money >= Price, cost(laserBeamer, Price), money(Money).

% List possible upgrades
possibleBuild(X, Y, standardTurretUpgraded) :- node(_, X, Y, standardTurret), money >= Price, cost(standardTurretUpgraded, Price), money(Money).
possibleBuild(X, Y, missileLauncherUpgraded) :- node(_, X, Y, missileLauncher), money >= Price, cost(missileLauncherUpgraded, Price), money(Money).
possibleBuild(X, Y, laserBeamerUpgraded) :- node(_, X, Y, laserBeamerUpgraded), money >= Price, cost(laserBeamerUpgraded, Price), money(Money).

% Generate all possible plans, excluding multiple builds in the same position
build(X, Y, Turret) | out(X, Y, Turret) :- possibleBuild(X, Y, Turret).
:- build(X, Y, TurretA), build(X, Y, TurretB), TurretA != TurretB.

% Ensure the total amount of money necessary doesn't exceed the player's actual money
expense(Money) :- build(_, _, Turret), cost(Turret, Money).
:- money(Amount), #sum{ Price : expense(Price) } = TotalToPay, Amount < TotalToPay.

% Maximize the expense
:~ money(Amount), #sum{ Price : expense(Price) } = TotalToPay, RemainingMoney = Amount - TotalToPay. [RemainingMoney@2]

:- #count{ID : node(ID, _, _, Turret), Turret != none} = Turrets, build(X, Y, _), end(EndX, EndY), not adjacent(X, Y, EndX, EndY), Turrets = 0.
nodePositionCoefficient(NodeX, NodeY, Value) :-
	node(_, NodeX, NodeY, _),
	#count{ X, Y : adjacent(NodeX, NodeY, X, Y), path(X, Y)} = Paths,
	#count{ X, Y : adjacent(NodeX, NodeY, X, Y), node(_, X, Y, Turret), Turret != none} = NotEmptyNodes,
	Value = Paths + NotEmptyNodes*2.
:~ nodePositionCoefficient(NodeX, NodeY, Value), build(NodeX, NodeY, _), AmountToPay = 16 - Value. [AmountToPay@1]

% Take only one action from the plan to put it in the actuator
action(X, Y, Turret) | out(X, Y, Turret) :- build(X, Y, Turret).
:- #count{X, Y, Turret : action(X, Y, Turret)} > 1.


setOnActuator(brainAct(brain,objectIndex(ID),aI(x(X)))):-objectIndex(brainAct,ID),build(X, _, _).
setOnActuator(brainAct(brain,objectIndex(ID),aI(y(Y)))):-objectIndex(brainAct,ID),build(_, Y, _).
setOnActuator(brainAct(brain,objectIndex(ID),aI(turretTypeName(T)))):-objectIndex(brainAct,ID),build(_, _, T).



% Costs
    cost(standardTurret, 100). 
    cost(standardTurretUpgraded, 60).
    cost(missileLauncher, 250).
    cost(missileLauncherUpgraded, 150).
    cost(laserBeamer, 350).
    cost(laserBeamerUpgraded, 250).