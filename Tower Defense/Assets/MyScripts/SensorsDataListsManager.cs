using System.Collections.Generic;
using UnityEngine;

public class SensorsDataListsManager : MonoBehaviour
{
    public List<EnemySensorData> enemies;
    public List<NodeSensorData> nodes;


    public List<EnemySensorData> Enemies => enemies;
    public List<NodeSensorData> Nodes => nodes;

    private void Awake()
    {
        enemies = EnemySensorDataList.Instance.List;
        nodes = NodeSensorDataList.Instance.List;
    }
    
}
