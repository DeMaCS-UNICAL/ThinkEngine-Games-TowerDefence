using System;
using UnityEngine;
using Utils.CustomAttributes.ReadOnly;

[RequireComponent(typeof(Enemy))]
public class EnemySensorData : SensorData
{
    private Enemy enemy;

    [ReadOnly]
    [SerializeField]
    private int health;

    private string type;

    // 🔹 PROPERTY per ThinkEngine v2
    public int Health => health;
    public string Type => type;

    // X e Y arrivano da SensorData (vedi step 3 sotto)
    public int X => x;
    public int Y => y;

    private new void Awake()
    {
        enemy = GetComponent<Enemy>();

        type = enemy.name.Substring(
            enemy.name.IndexOf('_') + 1,
            (enemy.name.Length - enemy.name.IndexOf('_')) - (enemy.name.Length - enemy.name.IndexOf('(') + 1)
        ).ToLower();

        UpdateData();
    }

    private void Start() =>
        EnemySensorDataList.Instance.Add(this);

    protected override void UpdateData()
    {
        base.UpdateData();
        health = (int)Mathf.Ceil(enemy.Health);
    }

    private void OnDestroy() =>
        EnemySensorDataList.Instance?.Remove(this);
}
