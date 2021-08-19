using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SplashScreen : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //#if UNITY_EDITOR

        //UnityMessageManager.Instance.InitLocationData(DataTemp.dataLocations);
        //LocationDataManager.GetInstance().AttachData();
        //Invoke("OpenARScreen", 0.5f);
        //#endif
        //

    }

    void OpenARScreen()
    {
        SceneManager.LoadSceneAsync("MainARLocation");
    }
}
