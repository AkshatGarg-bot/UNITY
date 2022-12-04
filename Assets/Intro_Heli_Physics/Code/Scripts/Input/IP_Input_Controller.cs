using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;


namespace IndiePixel
{
    public enum InputType
    {
        Keyboard,
        Xbox,
        Oculus,

    }

    [RequireComponent(typeof(IP_KeyboardHeli_Input),typeof(IP_Oculus_Input))]
    [RequireComponent(typeof(IP_XboxHeli_Input))]
    public class IP_Input_Controller : MonoBehaviour
    {
        #region Variables
        [Header("Input Properties")]
        public InputType inputType = InputType.Keyboard;

        [Header("Input Events")]
        public UnityEvent onCamButtonPressed = new UnityEvent();

        private IP_KeyboardHeli_Input keyInput;
        private IP_XboxHeli_Input xboxInput;
        private IP_Oculus_Input oculusInput;
        private float throttleInput;
        public float ThrottleInput
        {
            get { return throttleInput; }
        }

        private float stickyThrottle;
        public float StickyThrottle
        {
            get { return stickyThrottle; }
        }

        private float collectiveInput;
        public float CollectiveInput
        {
            get { return collectiveInput; }
        }

        private float stickyCollectiveInput;
        public float StickyCollectiveInput
        {
            get { return stickyCollectiveInput; }
        }


        private Vector2 cyclicInput;
        public Vector2 CyclicInput
        {
            get { return cyclicInput; }
        }

        private float pedalInput;
        public float PedalInput
        {
            get { return pedalInput; }
        }

        private bool camInput;
        public bool CamInput
        {
            get { return camInput; }
        }

        private bool fire;
        public bool Fire
        {
            get { return fire; }
        }
        #endregion



        #region Buitlin Methods
        void Start()
        {
            keyInput = GetComponent<IP_KeyboardHeli_Input>();
            xboxInput = GetComponent<IP_XboxHeli_Input>();
            oculusInput = GetComponent<IP_Oculus_Input>();
            if (keyInput && xboxInput && oculusInput)
            {
                SetInputType(inputType);
            }
        }

        private void Update()
        {
            if (keyInput && xboxInput && oculusInput)
            {
                switch (inputType)
                {
                    case InputType.Keyboard:
                        throttleInput = keyInput.RawThrottleInput;
                        collectiveInput = keyInput.CollectiveInput;
                        stickyCollectiveInput = keyInput.StickyCollectiveInput;
                        cyclicInput = keyInput.CyclicInput;
                        pedalInput = keyInput.PedalInput;
                        stickyThrottle = keyInput.StickyThrottle;
                        camInput = keyInput.CamInput;
                        fire = keyInput.Fire;
                        break;

                    case InputType.Xbox:
                        throttleInput = xboxInput.RawThrottleInput;
                        collectiveInput = xboxInput.CollectiveInput;
                        stickyCollectiveInput = xboxInput.StickyCollectiveInput;
                        cyclicInput = xboxInput.CyclicInput;
                        pedalInput = xboxInput.PedalInput;
                        stickyThrottle = xboxInput.StickyThrottle;
                        camInput = xboxInput.CamInput;
                        fire = xboxInput.Fire;
                        break;

                    case InputType.Oculus:
                        throttleInput = oculusInput.RawThrottleInput;
                        collectiveInput = oculusInput.CollectiveInput;
                        stickyCollectiveInput = oculusInput.StickyCollectiveInput;
                        cyclicInput = oculusInput.CyclicInput;
                        pedalInput = oculusInput.PedalInput;
                        stickyThrottle = oculusInput.StickyThrottle;
                        camInput = oculusInput.CamInput;
                        fire = oculusInput.Fire;
                        break;

                    default:
                        break;
                }

                if(camInput)
                {
                    onCamButtonPressed.Invoke();
                }
            }
        }
        #endregion



        #region Custom Methods
        void SetInputType(InputType type)
        {
            if (type == InputType.Keyboard)
            {
                keyInput.enabled = true;
                xboxInput.enabled = false;
                oculusInput.enabled = false;
            }

            if(type == InputType.Xbox)
            {
                xboxInput.enabled = true;
                keyInput.enabled = false;
                oculusInput.enabled = false;
            }
            if(type == InputType.Oculus)
            {
                oculusInput.enabled = true;
                xboxInput.enabled = false;
                keyInput.enabled = false;
            }
        }
        #endregion
    }
}
