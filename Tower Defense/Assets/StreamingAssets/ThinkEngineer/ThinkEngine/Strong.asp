% ===== Input Transforming ===== %
enemy(Index,ID, X, Y, Health, Type) :-
    enemy_Health(sensors,objectIndex(Index),ID,Health),
    enemy_Type(sensors,objectIndex(Index),ID,Type),
    enemy_X(sensors,objectIndex(Index),ID,X),
    enemy_Y(sensors,objectIndex(Index),ID,Y).

node(Index,ID, X, Y, TurretType) :-
    nodes_TurretTypeName(sensors,objectIndex(Index),ID,TurretType),
    nodes_X(sensors,objectIndex(Index),ID,X),
    nodes_Y(sensors,objectIndex(Index),ID,Y).

money(Value) :- player_MoneyInstance(gameMaster,objectIndex(Index),Value).

% === No enemies → no build ===
:- #count{ID : enemy(_,ID, _, _, _, _)} = 0.

% ============================================================
% STATIC MAP BASED HEURISTICS (A + C, deboli)
% ============================================================

% A) nodo deve toccare il path (almeno un adiacente che è path)
closeToPath(X,Y) :-
    node(_,_,X,Y,_),
    #count { PX,PY : adjacent(X,Y,PX,PY), path(PX,PY) } > 0.

% C) nodo deve essere raggiungibile dal path tramite adjacent/4
reachableFromPath(X,Y) :- path(X,Y).
reachableFromPath(X2,Y2) :-
    reachableFromPath(X1,Y1),
    adjacent(X1,Y1,X2,Y2).

% ============================================================
% POSSIBLE BUILDS (runtime + static)
% ============================================================

possibleBuild(X, Y, standardTurret) :-
    node(_,_, X, Y, "none"),
    Money >= Price,
    cost(standardTurret, Price),
    money(Money).

possibleBuild(X, Y, missileLauncher) :-
    node(_,_, X, Y, "none"),
    Money >= Price,
    cost(missileLauncher, Price),
    money(Money).

possibleBuild(X, Y, laserBeamer) :-
    node(_,_, X, Y, "none"),
    Money >= Price,
    cost(laserBeamer, Price),
    money(Money).

% upgrades
possibleBuild(X, Y, standardTurretUpgraded) :-
    node(_,_, X, Y, standardTurret),
    Money >= Price,
    cost(standardTurretUpgraded, Price),
    money(Money).

possibleBuild(X, Y, missileLauncherUpgraded) :-
    node(_,_, X, Y, missileLauncher),
    Money >= Price,
    cost(missileLauncherUpgraded, Price),
    money(Money).

possibleBuild(X, Y, laserBeamerUpgraded) :-
    node(_,_, X, Y, laserBeamerUpgraded),
    Money >= Price,
    cost(laserBeamerUpgraded, Price),
    money(Money).

% ============================================================
% BUILD PLANNING
% ============================================================

build(X, Y, Turret) | out(X, Y, Turret) :- possibleBuild(X, Y, Turret).
:- build(X, Y, TurretA), build(X, Y, TurretB), TurretA != TurretB.

% budget constraint
expense(Money) :- build(_, _, Turret), cost(Turret, Money).
:- money(Amount), #sum{ Price : expense(Price) } = TotalToPay, Amount < TotalToPay.

% maximize expense (livello di priorità 2)
:~ money(Amount), #sum{ Price : expense(Price) } = TotalToPay,
   RemainingMoney = Amount - TotalToPay.
   [RemainingMoney@2,Amount,TotalToPay]

% ============================================================
% HEURISTICHE STATICHE A + C (deboli, su build)
% ============================================================

% penalizza build lontani dal path
:~ build(X,Y,_), not closeToPath(X,Y).      [5@1,X,Y]

% penalizza build su nodi non raggiungibili topologicamente dal path
:~ build(X,Y,_), not reachableFromPath(X,Y). [3@1,X,Y]

% ============================================================
% POSITION HEURISTIC (già tua)
% ============================================================

:- #count{Index,ID : node(Index,ID, _, _, Turret), Turret != none} = Turrets,
   build(X, Y, _),
   end(EndX, EndY),
   not adjacent(X, Y, EndX, EndY),
   Turrets < 2.

nodePositionCoefficient(NodeX, NodeY, Value) :-
    node(_,_, NodeX, NodeY, _),
    #count{ X, Y : adjacent(NodeX, NodeY, X, Y), path(X, Y)} = Paths,
    #count{ X, Y : adjacent(NodeX, NodeY, X, Y),
                    node(_,_, X, Y, Turret), Turret != none} = NotEmptyNodes,
    Value = Paths + NotEmptyNodes*2.

:~ nodePositionCoefficient(NodeX, NodeY, Value),
   build(NodeX, NodeY, _),
   AmountToPay = 16 - Value.
   [AmountToPay@1,NodeX,NodeY,Value,AmountToPay]

% ============================================================
% ACTION → ACTUATOR
% ============================================================

action(X, Y, Turret) | out(X, Y, Turret) :- build(X, Y, Turret).
:- #count{X, Y, Turret : action(X, Y, Turret)} > 1.

setOnActuator(actuator_X(brain,objectIndex(Index),X)) :-
    objectIndex(actuator, Index),
    build(X, _, _).

setOnActuator(actuator_Y(brain,objectIndex(Index),Y)) :-
    objectIndex(actuator, Index),
    build(_, Y, _).

setOnActuator(actuator_TurretTypeName(brain,objectIndex(Index),Turret)) :-
    objectIndex(actuator, Index),
    build(_, _, Turret).