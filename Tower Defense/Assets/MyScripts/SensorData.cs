using UnityEngine;
using Utils.CustomAttributes.ReadOnly;

public abstract class SensorData : MonoBehaviour
{
    // DEVONO essere protected per ThinkEngine v2 e per le classi derivate
    [ReadOnly] [SerializeField]
    protected int x;

    [ReadOnly] [SerializeField]
    protected int y;

    // ThinkEngine v2 legge queste property: OK così
    public int X => x; 
    public int Y => y;

    protected void Awake() =>
        UpdateData();

    protected void LateUpdate() => 
        UpdateData();

    protected virtual void UpdateData()
    {
        var position = transform.position;

        // MANTENIAMO esattamente la tua logica di posizionamento
        x = Mathf.RoundToInt(position.x) / +5;
        y = Mathf.RoundToInt(position.z) / -5;
    }
}
