using System;
using UnityEngine;
using Utils.CustomAttributes.ReadOnly;

public enum TurretType
{
    None = 0,
    StandardTurret, StandardTurretUpgraded,
    MissileLauncher, MissileLauncherUpgraded,
    LaserBeamer, LaserBeamerUpgraded,
}

[RequireComponent(typeof(Node))]
public class NodeSensorData : SensorData
{
    private Node node;

    [ReadOnly]
    [SerializeField]
    private TurretType turretType;

    [ReadOnly]
    [SerializeField]
    private string turretTypeName;

    // 🔹 PROPERTY per ThinkEngine v2
    public string TurretTypeName => turretTypeName;

    // X e Y da SensorData
    public int X => x;
    public int Y => y;

    private new void Awake()
    {
        turretTypeName = "none";
        node = GetComponent<Node>();
        UpdateData();
    }

    private void Start() =>
        NodeSensorDataList.Instance.Add(this);

    private void OnDestroy() =>
        NodeSensorDataList.Instance?.Remove(this);

    public void SetTurretType(string turretGameObjectName)
    {
        turretGameObjectName = turretGameObjectName.Split('(')[0].Replace("_", "");
        SetTurretType((TurretType)Enum.Parse(typeof(TurretType), turretGameObjectName));
    }

    public void SetTurretType(TurretType turretType)
    {
        this.turretType = turretType;
        var pascalCaseName = turretType.ToString();
        turretTypeName = char.ToLower(pascalCaseName[0]) + pascalCaseName.Substring(1);
    }
}
