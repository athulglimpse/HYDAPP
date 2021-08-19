using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StaticScreen : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        UnityMessageManager s = UnityMessageManager.Instance;
        Invoke("StartSplashScreen", 0.3f);
    }

    private void StartSplashScreen()
    {
        SceneManager.LoadScene("SplashScreen");
    }

}
