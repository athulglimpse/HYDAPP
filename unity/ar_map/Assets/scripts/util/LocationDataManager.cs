using System;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json;
using UnityEngine;

public class LocationDataManager 
{
    private static LocationDataManager Instance;

    private double limitDistance = 300;
    private List<MyLocationData> locationDatas;
    private Action<List<MyLocationData>> onDataChange;

    public static LocationDataManager GetInstance()
    {
        if(Instance == null)
        {
            Instance = new LocationDataManager();
        }
        return Instance;
    }

    public List<MyLocationData> LocationDatas
    {
        get => locationDatas;
    }

    public double LimitDistance
    {
        get => limitDistance;
    }

    public void AddCallback(Action<List<MyLocationData>> onDataChange)
    {
        this.onDataChange = onDataChange;
    }

    /// <summary>
    /// This function called from Flutter
    /// </summary>
    /// <param name="jsonData">List locations attached from Flutter</param>
    public void AttachData(string jsonData)
    {
        if (!string.IsNullOrEmpty(jsonData))
        {
            try
            {
                locationDatas = JsonConvert.DeserializeObject<List<MyLocationData>>(jsonData);
                if(onDataChange != null)
                {
                    onDataChange.Invoke(locationDatas);
                }
            }
            catch (Exception e)
            {
                Debug.LogError("Convert Json Fail " + e.Message);
                UnityMessageManager.Instance.SendMessageToFlutter("Convert Json Fail "+ e.Message);
            }

        }
        else
        {
            UnityMessageManager.Instance.SendMessageToFlutter("faild " + jsonData);
        }
      
    }

    /// <summary>
    /// This function called from Flutter
    /// </summary>
    /// <param name="distance"></param>
    public void UpdateLimitDistance(string distance)
    {
        double.TryParse(distance, out limitDistance);
    }

}
