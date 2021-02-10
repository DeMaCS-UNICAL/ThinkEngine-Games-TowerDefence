%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly
setOnActuator(brainAct(level00,objectIndex(X),aI(x(V)))):-objectIndex(brainAct,X)
setOnActuator(brainAct(level00,objectIndex(X),aI(y(V)))):-objectIndex(brainAct,X)
setOnActuator(brainAct(level00,objectIndex(X),aI(turretTypeName(V)))):-objectIndex(brainAct,X)
%player(gameMaster,objectIndex(X),playerStats(money(V))).
%player(gameMaster,objectIndex(X),playerStats(lives(V))).
%nodeSensor(node,objectIndex(X),nodeSensorData(turretTypeName(V))).
%nodeSensor(node,objectIndex(X),nodeSensorData(x(V))).
%nodeSensor(node,objectIndex(X),nodeSensorData(y(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(health(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(type(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(x(V))).
%enemySensors(enemySimple,objectIndex(X),enemySensorData(y(V))).
