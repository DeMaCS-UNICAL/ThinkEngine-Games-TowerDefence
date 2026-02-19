using System;
using System.Collections.Generic;
using UnityEngine;
using Utils.CustomAttributes.ReadOnly;

public class AI : MonoBehaviour
{
    // --- CAMPI INTERNI (visibili nell’Inspector) ---
    [SerializeField]
    private int x;

    [SerializeField]
    private int y;

    [SerializeField]
    private string turretTypeName = "-1";

    // --- PROPERTY PER THINKENGINE v2 (Attuatori) ---
    // Queste sono quelle che vedrai in Actuator Configuration v2
    public int X
    {
        get => x;
        set => x = value;
    }

    public int Y
    {
        get => y;
        set => y = value;
    }

    public string TurretTypeName
    {
        get => turretTypeName;
        set => turretTypeName = value;
    }

    // Per rilevare cambiamenti
    private int previousX = -1;
    private int previousY = -1;
    private string previousTurretTypeName = "-1";

    private Dictionary<Tuple<int, int>, Node> nodes;
    private Shop shop;
    
    private void Start()
    {
        // Valori iniziali: nessuna azione
        x = y = -1;
        turretTypeName = "-1";
        previousX = previousY = -1;
        previousTurretTypeName = "-1";

        var parent = GameObject.Find("Nodes");
        nodes = new Dictionary<Tuple<int, int>, Node>();
        shop = GameObject.Find("Shop").GetComponent<Shop>();

        foreach (Transform row in parent.transform)
        {
            foreach (Transform child in row)
            {
                NodeSensorData nodeSensorData = child.gameObject.GetComponent<NodeSensorData>();
                Node node = child.gameObject.GetComponent<Node>();

                // Usa le coordinate del NodeSensorData (X,Y) come chiave
                var key = new Tuple<int, int>(nodeSensorData.X, nodeSensorData.Y);
                if (!nodes.ContainsKey(key))
                {
                    nodes.Add(key, node);
                }
            }
        }
    }

    private void Update()
    {
        Debug.Log($"[AI DEBUG] x={x}, y={y}, turretTypeName={turretTypeName}");

        // Se ThinkEngine non ha scritto nulla, non fare niente
        if (!AreValuesUpdated()) return;

        previousX = x;
        previousY = y;
        previousTurretTypeName = turretTypeName;

        // Se turretTypeName è "-1" o vuoto, non c'è azione da eseguire
        if (string.IsNullOrEmpty(turretTypeName) || turretTypeName == "-1")
            return;

        var position = new Tuple<int, int>(x, y);

        if (!nodes.TryGetValue(position, out var node))
        {
            foreach (var key in nodes.Keys)
{
    int x = key.Item1;
    int y = key.Item2;

    Debug.LogWarning($"Key: ({x}, {y})");
}
            Debug.LogWarning($"[AI] Nessun Node trovato in posizione ({x},{y})");
            return;
        }

        // Se non c'è torre, interpreto il comando come "build"
        if (node.turret == null)
        {
            switch (turretTypeName)
            {
                case "standardTurret":
                    node.BuildTurret(shop.standardTurret);
                    return;
                case "missileLauncher":
                    node.BuildTurret(shop.missileLauncher);
                    return;
                case "laserBeamer":
                    node.BuildTurret(shop.laserBeamer);
                    return;
                default:
                    Debug.LogWarning($"[AI] TurretTypeName sconosciuto per build: {turretTypeName}");
                    return;
            }
        }
        else
        {
            // Se la torre esiste, interpreto il comando come "upgrade"
            switch (turretTypeName)
            {
                case "standardTurretUpgraded":
                case "missileLauncherUpgraded":
                case "laserBeamerUpgraded":
                    node.UpgradeTurret();
                    return;
                default:
                    Debug.LogWarning($"[AI] TurretTypeName sconosciuto per upgrade: {turretTypeName}");
                    return;
            }
        }
    }

    private bool AreValuesUpdated()
    {
        return (previousX != x) || (previousY != y) || (previousTurretTypeName != turretTypeName);
    }
}
