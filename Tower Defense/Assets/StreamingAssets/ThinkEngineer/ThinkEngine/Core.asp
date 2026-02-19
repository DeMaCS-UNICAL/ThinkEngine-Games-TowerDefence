% ===== Input Transforming ===== %
%    enemy(ID, X, Y, Health, Type) :-
%        enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(health(Health)))))),
%        enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(type(Type)))))),
%        enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(x(X)))))),
%        enemies(sensors(sensorsDataListsManager(enemies(ID,enemySensorData(y(Y)))))).
	enemy(Index,ID, X, Y, Health, Type) :-
		enemy_Health(sensors,objectIndex(Index),ID,Health),
		enemy_Type(sensors,objectIndex(Index),ID,Type),
		enemy_X(sensors,objectIndex(Index),ID,X),
		enemy_Y(sensors,objectIndex(Index),ID,Y).

%    node(ID, X, Y, TurretType) :-
%        nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensorData(turretTypeName(TurretType)))))),
%        nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensorData(x(X)))))),
%        nodes(sensors(sensorsDataListsManager(nodes(ID,nodeSensorData(y(Y)))))).
	node(Index,ID, X, Y, TurretType) :-
		nodes_TurretTypeName(sensors,objectIndex(Index),ID,TurretType),
		nodes_X(sensors,objectIndex(Index),ID,X),
		nodes_Y(sensors,objectIndex(Index),ID,Y).

    money(Value) :- player_MoneyInstance(gameMaster,objectIndex(Index),Value).

% Do not build if there is no enemy
:- #count{ID : enemy(_,ID, _, _, _, _)} = 0.

% List possible builds
possibleBuild(X, Y, standardTurret) :- node(_,_, X, Y, "none"), Money >= Price, cost(standardTurret, Price), money(Money).
possibleBuild(X, Y, missileLauncher) :- node(_,_, X, Y, "none"), Money >= Price, cost(missileLauncher, Price), money(Money).
possibleBuild(X, Y, laserBeamer) :- node(_,_, X, Y, "none"), Money >= Price, cost(laserBeamer, Price), money(Money).

% List possible upgrades
possibleBuild(X, Y, standardTurretUpgraded) :- node(_,_, X, Y, standardTurret), Money >= Price, cost(standardTurretUpgraded, Price), money(Money).
possibleBuild(X, Y, missileLauncherUpgraded) :- node(_,_, X, Y, missileLauncher), Money >= Price, cost(missileLauncherUpgraded, Price), money(Money).
possibleBuild(X, Y, laserBeamerUpgraded) :- node(_,_, X, Y, laserBeamerUpgraded), Money >= Price, cost(laserBeamerUpgraded, Price), money(Money).

% Generate all possible plans, excluding multiple builds in the same position
build(X, Y, Turret) | out(X, Y, Turret) :- possibleBuild(X, Y, Turret).
:- build(X, Y, TurretA), build(X, Y, TurretB), TurretA != TurretB.

% Ensure the total amount of money necessary doesn't exceed the player's actual money
expense(Money) :- build(_, _, Turret), cost(Turret, Money).
:- money(Amount), #sum{ Price : expense(Price) } = TotalToPay, Amount < TotalToPay.

% Maximize the expense
:~ money(Amount), #sum{ Price : expense(Price) } = TotalToPay, RemainingMoney = Amount - TotalToPay. [RemainingMoney@2,Amount,TotalToPay]

%nodePositionCoefficient(NodeX, NodeY, Value) :-
%   node(_, NodeX, NodeY, _),
%   #count{ X, Y : adjacent(NodeX, NodeY, X, Y), path(X, Y)} = Paths,
%	#count{ X, Y : adjacent(NodeX, NodeY, X, Y), node(_, X, Y, Turret), Turret != none} = NotEmptyNodes,
%	Value = Paths + NotEmptyNodes.
% :~ nodePositionCoefficient(NodeX, NodeY, Value), build(NodeX, NodeY, _), AmountToPay = 8 - Value. [AmountToPay@1]

:- #count{Index,ID : node(Index,ID, _, _, Turret), Turret != none} = Turrets, build(X, Y, _), end(EndX, EndY), not adjacent(X, Y, EndX, EndY), Turrets < 2.
nodePositionCoefficient(NodeX, NodeY, Value) :-
	node(_,_, NodeX, NodeY, _),
	#count{ X, Y : adjacent(NodeX, NodeY, X, Y), path(X, Y)} = Paths,
	#count{ X, Y : adjacent(NodeX, NodeY, X, Y), node(_,_, X, Y, Turret), Turret != none} = NotEmptyNodes,
	Value = Paths + NotEmptyNodes*2.
:~ nodePositionCoefficient(NodeX, NodeY, Value), build(NodeX, NodeY, _), AmountToPay = 16 - Value. [AmountToPay@1,NodeX,NodeY,Value,AmountToPay]

% Take only one action from the plan to put it in the actuator
action(X, Y, Turret) | out(X, Y, Turret) :- build(X, Y, Turret).
:- #count{X, Y, Turret : action(X, Y, Turret)} > 1.

%setOnActuator(actuator(brain(aI(x(X))))):- build(X, _, _).
%setOnActuator(actuator(brain(aI(y(Y))))):- build(_, Y, _).
%setOnActuator(actuator(brain(aI(turretTypeName(Turret))))):- build(_, _, Turret).

setOnActuator(actuator_X(brain,objectIndex(Index),X)) :-objectIndex(actuator, Index), build(X, _, _).
setOnActuator(actuator_Y(brain,objectIndex(Index),Y)) :-objectIndex(actuator, Index), build(_, Y, _).
setOnActuator(actuator_TurretTypeName(brain,objectIndex(Index),Turret)) :-objectIndex(actuator, Index), build(_, _, Turret).





