%For runtime instantiated GameObject, only the prefab mapping is provided. Use that one substituting the gameobject name accordingly.
 %Sensors.
%enemy_Health(sensors,objectIndex(Index),Index1,Value).
%enemy_Type(sensors,objectIndex(Index),Index1,Value).
%enemy_X(sensors,objectIndex(Index),Index1,Value).
%enemy_Y(sensors,objectIndex(Index),Index1,Value).
%player_MoneyInstance(gameMaster,objectIndex(Index),Value).
%gameMasterSensor_LivesInstance(gameMaster,objectIndex(Index),Value).
%nodes_TurretTypeName(sensors,objectIndex(Index),Index1,Value).
%nodes_X(sensors,objectIndex(Index),Index1,Value).
%nodes_Y(sensors,objectIndex(Index),Index1,Value).
%Actuators:
setOnActuator(actuator_X(brain,objectIndex(Index),Value)) :-objectIndex(actuator, Index), .
setOnActuator(actuator_Y(brain,objectIndex(Index),Value)) :-objectIndex(actuator, Index), .
setOnActuator(actuator_TurretTypeName(brain,objectIndex(Index),Value)) :-objectIndex(actuator, Index), .
