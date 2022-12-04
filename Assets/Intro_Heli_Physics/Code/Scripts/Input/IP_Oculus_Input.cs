using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;
using System;

namespace IndiePixel
{
    public class IP_Oculus_Input :  IP_KeyboardHeli_Input
    {

        private Vector2 inputCyclicValue;
        private float oculus_throttle_up;
        private float oculus_throttle_down;
        private float oculus_collective_up;
        private float oculus_collective_down;
        private float oculus_pedal;

        public InputActionReference IAR_cyclic;
        public InputActionReference IAR_throttle_up;
        public InputActionReference IAR_throttle_down;
        public InputActionReference IAR_collective_up;
        public InputActionReference IAR_collective_down;
        public InputActionReference IAR_pedal;
        
        void Start()
        {
            Debug.Log("Start");
        }
        
        protected override void HandleCyclic()
        {
            cyclicInput.y = inputCyclicValue.y;
            cyclicInput.x = inputCyclicValue.x; 
            Debug.Log("cyclicInput:-" + cyclicInput);
        }
        
        protected override void HandleCollective()
        {
            decimal cu = Convert.ToDecimal(oculus_collective_up);
            decimal cd = Convert.ToDecimal(oculus_collective_down);
            decimal cv = Decimal.Subtract(cu , cd);
            Debug.Log("cu" + cu);
            Debug.Log("cd" + cd);
            Debug.Log("cv" + cv);   
            collectiveInput = (float)(cv);
        }
        
        protected override void HandlePedal()
        {
            pedalInput = oculus_pedal;
        }
        
        protected override void HandleThrottle()
        {
            decimal tu = Convert.ToDecimal(oculus_throttle_up);
            decimal td = Convert.ToDecimal(oculus_throttle_down);
            decimal tv = Decimal.Subtract(tu, td);
            throttleInput = (float)(tv);
            Debug.Log("tu" + tu);
            Debug.Log("td" + td);
            Debug.Log("tv" + tv);
            Debug.Log(throttleInput + "#$****************");
        }

        private void test_cyclic(InputAction.CallbackContext obj)
        {
           inputCyclicValue = obj.ReadValue<Vector2>();
        //    Debug.Log("Input value: " + inputCyclicValue);
        //    Debug.Log("tested");
        }
        private void test_throttle_up(InputAction.CallbackContext obj)
        {
            oculus_throttle_up = obj.ReadValue<float>();
            Debug.Log("UP_throttle  "  + oculus_throttle_up);
        }

        private void test_throttle_down(InputAction.CallbackContext obj)
        {
            oculus_throttle_down = obj.ReadValue<float>();
            
            Debug.Log("tested_DOWN" + "   " + oculus_throttle_down);
        }

        private void test_pedal(InputAction.CallbackContext obj)
        {
            oculus_pedal =  obj.ReadValue<Vector2>().x;
            // Debug.Log("tested_pedal");
        }
        private void test_collective_up(InputAction.CallbackContext obj)
        {
            oculus_collective_up = -obj.ReadValue<float>();
            //  Debug.Log("tested_collective");
        }
        private void test_collective_down(InputAction.CallbackContext obj)
        {
            oculus_collective_down = -obj.ReadValue<float>();
            //  Debug.Log("tested_collective");
        }
        private void OnEnable()
        {
            IAR_cyclic.action.performed += test_cyclic;
            IAR_throttle_up.action.performed += test_throttle_up;
            IAR_throttle_down.action.performed += test_throttle_down;
            IAR_collective_up.action.performed += test_collective_up;
            IAR_collective_down.action.performed += test_collective_down;
            IAR_pedal.action.performed += test_pedal;
        }

        private void OnDisable()
        {
            IAR_cyclic.action.performed -= test_cyclic;
            IAR_throttle_up.action.performed -= test_throttle_up;
            IAR_throttle_down.action.performed -= test_throttle_down;

            IAR_collective_up.action.performed -= test_collective_up;
            IAR_collective_down.action.performed -= test_collective_down;
            IAR_pedal.action.performed -= test_pedal;
        }
    }
}
