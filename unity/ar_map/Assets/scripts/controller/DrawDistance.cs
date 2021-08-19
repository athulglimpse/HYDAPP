using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using ARLocation;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.UI;

namespace ARLocation
{
    public class DrawDistance : MonoBehaviour
    {
        private LineRenderer lineRenderer;
        private Camera mainCamera;
        //private TextMesh textMesh;
        //private GameObject textMeshGo;
        public Material trailMa;
        private ARLocationManager arLocationManager;
        private bool hasArLocationManager;
        public Text tvDistance;
        private Action<MyLocationData> onActionTab;
        public string  sortingLayer;
        private bool canDrawLine = false;
        private float offsetTextureX = 0;
        // Start is called before the first frame update
        void Start()
        {
            //Transform childDistance = transform.Find("tvDistance");
            //if(childDistance != null)
            //{
            //    tvDistance = childDistance.GetComponent<Text>();
            //}

            mainCamera = ARLocationManager.Instance.MainCamera;
            lineRenderer = GetComponent<LineRenderer>();
            arLocationManager = ARLocationManager.Instance;
            hasArLocationManager = arLocationManager != null;

            if (!lineRenderer)
            {
                lineRenderer = gameObject.AddComponent<LineRenderer>();

                lineRenderer.material = trailMa;
            }

            lineRenderer.useWorldSpace = true;
            lineRenderer.alignment = LineAlignment.View;
            lineRenderer.textureMode = LineTextureMode.Tile;
            lineRenderer.receiveShadows = false;
            lineRenderer.shadowCastingMode = ShadowCastingMode.Off;
            lineRenderer.allowOcclusionWhenDynamic = false;
            lineRenderer.positionCount = 2;
            lineRenderer.startWidth = 0.2f;
            lineRenderer.endWidth = 0.2f;
            lineRenderer.enabled = canDrawLine;
            lineRenderer.sortingLayerID = SortingLayer.NameToID(sortingLayer);
        }

        public void InitCallback( Action<MyLocationData> onActionTab)
        {
            this.onActionTab = onActionTab;
        }

        public void EnableLine()
        {
            canDrawLine = true;
            if (lineRenderer != null)
                lineRenderer.enabled = canDrawLine;
        }

        public void DisableLine()
        {
            canDrawLine = false;
            if (lineRenderer != null)
                lineRenderer.enabled = canDrawLine;
        }

        void Update()
        {

            var floorLevel = hasArLocationManager ? arLocationManager.CurrentGroundY : -ARLocation.Config.InitialGroundHeightGuess;
            var startPos = MathUtils.SetY(mainCamera.transform.position, floorLevel);
            var endPos = MathUtils.SetY(transform.position, floorLevel);

            var lineDir = (endPos - startPos).normalized;

            if (canDrawLine)
            {
                lineRenderer.SetPosition(0, startPos);
                lineRenderer.SetPosition(1, endPos);
                trailMa.SetTextureOffset("_MainTex", new Vector2(offsetTextureX, 0));
                offsetTextureX -= Time.deltaTime * 1f;
                if(offsetTextureX < -100)
                {
                    offsetTextureX = 0;
                }
            }

            var textPos = startPos + lineDir * 6.0f;

            //textMeshGo.transform.position = textPos;
            //textMeshGo.transform.LookAt(endPos, new Vector3(0, 1, 0));
            //textMeshGo.transform.Rotate(90, 90, 0);
            //textMesh.text = Vector3.Distance(startPos, endPos).ToString("0.00", CultureInfo.InvariantCulture) + "m";
            if (tvDistance != null) {
                tvDistance.text = Vector3.Distance(startPos, endPos).ToString("0.", CultureInfo.InvariantCulture) + " m";
            }
        }
    }
}