using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class BottomTabController : MonoBehaviour
{
    public Text tvTitle;
    public Text tvCategory;
    public Image imgThumb;

    public Text tvDirection;
    public Text tvNextDirection;
    public Text tvDuration;
    public Image imgDirect;


    public GameObject groupGuideDirection;
    public GameObject groupLocationInfo;
    public GameObject loadingDirection;

    private Texture2D myTextureIcon;
    private MyLocationData locationData;
    private Action<MyLocationData> onStartDirection;
    private Transform target;

    public Transform arrowDirect;
    public Texture2D loadingSpr;
    public Texture2D errorSpr;

    private bool directionEnable = false;

    public void AttachData(MyLocationData locationData, Transform target)
    {
        this.target = target;
        this.locationData = locationData;
        tvTitle.text = locationData?.parent?.title ?? "";
        tvCategory.text = locationData?.parent?.category?.name ?? "";
        //StartCoroutine(GetTexture(locationData?.parent?.thumb?.url ?? ""));

        Davinci.get()
            .load(locationData?.parent?.thumb?.url ?? "")
            .setLoadingPlaceholder(loadingSpr)
            .setErrorPlaceholder(errorSpr)
            .setCached(true)
            .into(imgThumb)
            .start();


        directionEnable = false; 
        groupLocationInfo.SetActive(true);
        groupGuideDirection.SetActive(false);
        loadingDirection.SetActive(false);
    }



    IEnumerator GetTexture(string url)
    {
        UnityWebRequest www = UnityWebRequestTexture.GetTexture(url);
        yield return www.SendWebRequest();

        if (www.isNetworkError || www.isHttpError)
        {
            Debug.Log(www.error);
        }
        else
        {
            if (myTextureIcon != null)
            {
                Destroy(myTextureIcon);
            }
            myTextureIcon = ((DownloadHandlerTexture)www.downloadHandler).texture;
            Sprite sprite = Sprite.Create(myTextureIcon, new Rect(0.0f, 0.0f,
                myTextureIcon.width, myTextureIcon.height), new Vector2(0.5f, 0.5f), 100.0f);
            imgThumb.sprite = sprite;
        }
    }

    public void AttachDirectionData(GuideResponse guideResponse)
    {

        directionEnable = true;
        tvDirection.text = StringUtil.DecodeString(guideResponse?.intro ?? "");
        tvNextDirection.text = StringUtil.DecodeString(guideResponse?.nextIntro ?? "");
        tvDuration.text = guideResponse.eta ?? "";

        groupLocationInfo.SetActive(false);
        groupGuideDirection.SetActive(true);
    }

    public void OnClickClose()
    {
        gameObject.GetComponent<Animator>().CrossFade("slideDown", 0.2f);
    }

    public void OnCloseTab()
    {
        gameObject.SetActive(true);
    }

    public void OnStartDirection()
    {
        loadingDirection.SetActive(true);
        onStartDirection?.Invoke(locationData);
    }

    public void AddCallback(Action<MyLocationData> onStartDirection)
    {
        this.onStartDirection = onStartDirection;
    }

    private void OnDestroy()
    {
        if (myTextureIcon != null)
        {
            Destroy(myTextureIcon);
        }
    }


    private void Update()
    {
        if (directionEnable && target != null) 
        {
            float dot = Vector3.Dot(Camera.main.transform.right, target.position - Camera.main.transform.position);
            float angle = (dot > 0 ? -1 : 1)* Vector3.Angle(Camera.main.transform.forward, target.position - Camera.main.transform.position);
            arrowDirect.eulerAngles = new Vector3(0, 0, angle);
        }
    }
}
