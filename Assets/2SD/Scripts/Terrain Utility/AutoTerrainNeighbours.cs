using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

namespace TSD
{
	[ExecuteInEditMode]
    public class AutoTerrainNeighbours : MonoBehaviour
    {
        private List<Terrain> everyTerrain = new List<Terrain>();

        private void Start()
        {
            everyTerrain = GetComponentsInChildren<Terrain>().ToList();
            setNeighbours();
        }

        //find the neighbours and assign them
        public void setNeighbours()
        {
            everyTerrain.Clear();
            everyTerrain = GetComponentsInChildren<Terrain>().ToList();

            //find the closest terrain
            foreach (Terrain currentItem in everyTerrain)
            {
                Vector3 currentPos = currentItem.transform.position;

                //store the closest terrains
                Terrain left = null;
                Terrain right = null;
                Terrain top = null;
                Terrain bottom = null;

                //loop through every element
                foreach (Terrain otherItem in everyTerrain)
                {
                    //skip the current terrain
                    if (otherItem == currentItem)
                    {
                        continue;
                    }

                    //store the other terrain's position so we can compare it with the current one's
                    Vector3 otherPos = otherItem.transform.position;

                    //only check if we are in the same row\collumn
                    if (isEqual(otherPos.z, currentPos.z, 10))
                    {
                        if (otherPos.x < currentPos.x)
                        {
                            if (isEqual(otherPos.x, currentPos.x, currentItem.terrainData.size.x + 10))// && left == null)
                            {
                                left = otherItem;
                            }
                        }
                        else
                        {
                            if (isEqual(otherPos.x, currentPos.x, currentItem.terrainData.size.x + 10))// && right == null)
                            {
                                right = otherItem;
                            }
                        }
                    }
                    //only check if we are in the same row\collumn
                    if (isEqual(otherPos.x, currentPos.x, 10))
                    {
                        if (otherPos.z > currentPos.z)
                        {
                            if (isEqual(otherPos.z, currentPos.z, currentItem.terrainData.size.z + 10))// && top == null)
                            {
                                top = otherItem;
                            }
                        }
                        else
                        {
                            if (isEqual(otherPos.z, currentPos.z, currentItem.terrainData.size.z + 10))// && bottom == null)
                            {
                                bottom = otherItem;
                            }
                        }
                    }

                }
                //assign the founded 
                currentItem.SetNeighbors(left, top, right, bottom);

                left = null;
                top = null;
                right = null;
                bottom = null;
            }
        }

        private bool isEqual(float value1, float value2, float threshold)
        {
            float result = Mathf.Abs(value1 - value2);
            if (result < threshold)
            {
                return true;
            }
            return false;
        }
    }
}