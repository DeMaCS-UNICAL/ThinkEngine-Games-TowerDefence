using UnityEngine;

public class PlayerStats : MonoBehaviour
{
    // Usati dal gioco come prima
    public static int Money;
    public static int Lives;
    public static int Rounds;

    // Parametri iniziali configurabili da Inspector
    public int startLives = 20;
    public int startMoney = 400;

    // --- PROPRIETÀ DI ISTANZA PER THINKENGINE v2 ---

    // ThinkEngine v2 vedrà queste e potrà leggerle
    public int MoneyInstance  => Money;
    public int LivesInstance  => Lives;
    public int RoundsInstance => Rounds;

    private void Start()
    {
        Money = startMoney;
        Lives = startLives;
        Rounds = 0;
    }
}
