using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TSD
{
    public class ObjectAttach : MonoBehaviour 
    {
        public Transform go;
        private Transform m_transform;

	    // Use this for initialization
	    void Start () 
        {
		    if(!isObjectValid())
            {
                this.enabled = false; //disable script if there is nothing to follow
            }

            m_transform = GetComponent<Transform>();
	    }

        bool isObjectValid()
        {
            if(go != null)
            {
                return true;
            }
            return false;
        }
	
	    // Update is called once per frame
	    void Update () 
        {
            m_transform.position = go.position;
	    }
    }
}