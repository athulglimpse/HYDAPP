using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using ARLocation;
using Newtonsoft.Json;
using UnityEngine;

public class MainScreen : MonoBehaviour
{
    [Tooltip("The locations where the objects will be instantiated.")]
    public List<PlaceAtLocation.LocationSettingsData> Locations;

    public GameObject prefabLocationPoint;
    private Dictionary<String, GameObject> listPoints = new Dictionary<string, GameObject>();
    private string currentLocationId = null;
    private double limitDistance = 300;
    public float scaleSelected = 60;

    public GameObject bottomTab;
    public GameObject loadingObject;

    // Start is called before the first frame update
    void Start()
    {
        limitDistance = LocationDataManager.GetInstance().LimitDistance;
        BottomTabController bottomTabController = bottomTab.GetComponent<BottomTabController>();
        bottomTabController.AddCallback(GuideDirection);
        LocationDataManager.GetInstance().AddCallback(OnDataChange);
        InitLocationPoints();

    }

    public void OnLocationInited()
    {
        print("OnLocationInited");
       
    }

    public void OnSpam()
    {
        UnityMessageManager.Instance.InitLocationData(DataTemp.dataLocations);
    }

    void OnDataChange(List<MyLocationData> locationDatas)
    {
         InitLocationPoints();
    }

    // Init location Point on 3D World
     void InitLocationPoints()
    {
        if(listPoints!= null)
        {
            foreach(KeyValuePair<String,GameObject> entry in listPoints)
            {
                Destroy(entry.Value);
            }
            listPoints.Clear();
        }
        List<MyLocationData> locationDatas = LocationDataManager.GetInstance().LocationDatas;

        if (locationDatas == null)
        {
            //None location datas;
            return ;
        }

        int index = 0;
        foreach(MyLocationData lo in locationDatas)
        {
            var loc = new Location()
            {
                Latitude = double.Parse(lo.lat),
                Longitude = double.Parse(lo.longitude),
                Altitude = 20,
                AltitudeMode = AltitudeMode.Absolute
            };
          
            var opts = new PlaceAtLocation.PlaceAtOptions()
            {
                HideObjectUntilItIsPlaced = true,
                MaxNumberOfLocationUpdates = 2,
                MovementSmoothing = 0.2f,
                UseMovingAverage = false
            };

            GameObject game = PlaceAtLocation.CreatePlacedInstance(prefabLocationPoint, loc, opts, false);

            PlaceAtLocation placeAtLocation =  game.GetComponent<PlaceAtLocation>();
            if(placeAtLocation != null)
            {
                placeAtLocation.LimitDistance = limitDistance;
            }

            DrawDistance drawDistance = game.GetComponent<DrawDistance>();
            if (drawDistance != null )
            {
                //init Layout and Callback
                drawDistance.InitCallback((MyLocationData data)=>{ });
                //drawDistance.EnableLine();
            }
            GameLocationPoint gameLocationPoint = game.GetComponent<GameLocationPoint>();
            if (gameLocationPoint != null  )
            {
                //init Layout and Callback
                gameLocationPoint.InitLayout(lo, OnTapLocation);
            }
            index++;
            listPoints.Add(lo.id, game);
        }
        loadingObject.SetActive(false);

    }

    //When user Tap On Location (Marker)
    public void OnTapLocation(MyLocationData item)
    {
        if (listPoints != null && listPoints.ContainsKey(item.id) &&
            !(currentLocationId?.Equals(item.id) ?? false))
        {
            ///Release previous Location 
            UnSelectCurrentLocation();

            currentLocationId = item.id;

            GameObject gameLocationSelect = listPoints[item.id];
            gameLocationSelect.transform.GetChild(0).localScale = new Vector3(1.2f, 1.2f, 1.2f);
            DrawDistance drawDistanceLocationSelect = gameLocationSelect.GetComponent<DrawDistance>();
            GameLocationPoint gameLocationPointLocationSelect = gameLocationSelect.GetComponent<GameLocationPoint>();

            //turn on LinePath render
            drawDistanceLocationSelect.EnableLine();
            gameLocationPointLocationSelect.EnableFocus();

            ShowGroupInfo(item, gameLocationSelect.transform);
        }
    }

    public void UnSelectCurrentLocation()
    {
        if (currentLocationId != null)
        {
            GameObject gameObject = listPoints[currentLocationId];
            gameObject.transform.GetChild(0).localScale = new  Vector3(1, 1, 1);
            DrawDistance drawDistance = gameObject.GetComponent<DrawDistance>();
            GameLocationPoint gameLocationPoint = gameObject.GetComponent<GameLocationPoint>();

            //turn of LinePath render
            drawDistance.DisableLine();
            gameLocationPoint.DisableFocus();
            currentLocationId = null;

            //Interact With Flutter
            RequestData requestData = new RequestData
            {
                responseCode = "StopGuideDirection"
            };
            UnityMessageManager.Instance.SendMessageToFlutter(JsonConvert.SerializeObject(requestData));
        }
    }

    private void ShowGroupInfo(MyLocationData item,Transform target)
    {
        bottomTab.SetActive(true);
        bottomTab.GetComponent<Animator>().CrossFade("slideUp", 0.2f);
        BottomTabController bottomTabController = bottomTab.GetComponent<BottomTabController>();
        bottomTabController.AttachData(item, target);

        
    }

    private void GuideDirection(MyLocationData item)
    {
        //Interact with Flutter
        LocationRequest locationRequest = new LocationRequest
        {
            id = item.id,
            latti = item.lat,
            longti = item.longitude
        };

        RequestData requestData = new RequestData
        {
            data = JsonConvert.SerializeObject(locationRequest),
            responseCode = "GuideDirection"
        };
        UnityMessageManager.Instance.SendMessageToFlutter(JsonConvert.SerializeObject(requestData));
    }


    /// <summary>
    /// Called by Flutter 
    /// </summary>
    /// <param name="data">Data is result of google direction API </param>
    public void GuideDirectionLocation(string data)
    {
        try
        {
            GuideResponse guideResponse = JsonConvert.DeserializeObject<GuideResponse>(data);
            if(guideResponse != null)
            {
                ShowGroupDirection(guideResponse);
            }
        }
        catch (Exception ex)
        {
            print("Ex cast data: "+ ex.ToString());
        }
    }

    private void ShowGroupDirection(GuideResponse data)
    {
        BottomTabController bottomTabController = bottomTab.GetComponent<BottomTabController>();
        bottomTabController.AttachDirectionData(data);
    }

    private void OnDestroy()
    {
        LocationDataManager.GetInstance().AddCallback(null);
    }


}
