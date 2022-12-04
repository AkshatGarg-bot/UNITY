using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
namespace IndiePixel
{
    

public class GAUGEPANEL : MonoBehaviour
{
    [Header("UI Properties")]
    public TextMeshProUGUI RawThrottle;
    public TextMeshProUGUI StickyThrottle;
    public TextMeshProUGUI Collective;
    public TextMeshProUGUI StickyCollective;
    public TextMeshProUGUI Cyclic;
    public TextMeshProUGUI Pedal;

    [Header("Other References")]
    public IP_KeyboardHeli_Input Input;

    void Update()
    {
        RawThrottle.text = Input.RawThrottleInput.ToString();
        StickyThrottle.text = Input.StickyThrottle.ToString();
        Collective.text = Input.CollectiveInput.ToString();
        StickyCollective.text = Input.StickyCollectiveInput.ToString();
        Cyclic.text = "(" + Input.CyclicInput.x + "," + Input.CyclicInput.y + ")";
        Pedal.text = Input.PedalInput.ToString();
    }
}
}