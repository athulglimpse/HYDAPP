using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class GameLocationPoint : MonoBehaviour
{
    private Transform cameraMain;
    public Text tvName;
    public Text tvDistance;
    public Image icon;
    public Image iconLarge;
    public Image markerForcus;
    private Texture2D myTextureIcon;
    private MyLocationData locationData;

    public Texture2D loadingSpr;
    public Texture2D errorSpr;

    private Action<MyLocationData> actionOnTap;

    public List<Sprite> listIcons;

    private GameObject childNode;
     
    // Start is called before the first frame update
    void Start()
    {
        cameraMain = Camera.main.transform;
    }

    public void InitLayout(MyLocationData locationData, Action<MyLocationData> actionOnTap)
    {
        this.actionOnTap = actionOnTap;
        this.locationData = locationData;
        if(locationData == null)
        {
            return;
        }


        markerForcus.color = StringUtil.GetColorByExperienceId(locationData.parent?.experience?.id??"0");

        tvName.text = locationData?.parent?.title ?? "";
        icon.sprite = listIcons[StringUtil.GetIconByExperienceId(locationData.parent?.experience?.id ?? "0")];
        iconLarge.sprite = listIcons[StringUtil.GetIconByExperienceId(locationData.parent?.experience?.id ?? "0")];
        //StartCoroutine(GetTexture(GetCateUrlImage()));

        //Davinci.get()
        //    .load(GetCateUrlImage())
        //    .setLoadingPlaceholder(loadingSpr)
        //    .setErrorPlaceholder(errorSpr)
        //    .setCached(true)
        //    .into(icon)
        //    .start();

        //Davinci.get()
        //  .load(GetCateUrlImage())
        //  .setLoadingPlaceholder(loadingSpr)
        //  .setErrorPlaceholder(errorSpr)
        //  .setCached(true)
        //.into(iconLarge)
        //  .start();

        DisableFocus();

        if(transform.childCount>0)
            childNode = transform.GetChild(0).gameObject;
    }

    string GetCateUrlImage()
    {
        if(locationData != null)
        {
            CategoryModel categoryModel = locationData?.parent?.category;
            if(categoryModel != null)
            {
                return categoryModel.icon??"";
            }
        }
        return "";
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
            if(myTextureIcon != null)
            {
                Destroy(myTextureIcon);
            }
            myTextureIcon = ((DownloadHandlerTexture)www.downloadHandler).texture;
            Sprite sprite = Sprite.Create(myTextureIcon, new Rect(0.0f, 0.0f,
                myTextureIcon.width, myTextureIcon.height), new Vector2(0.5f, 0.5f), 100.0f);
            icon.sprite = sprite;
            iconLarge.sprite = sprite;
        }
    }

    public void EnableFocus()
    {
        iconLarge.gameObject.SetActive(false);
        tvName.gameObject.SetActive(true);
        tvDistance.gameObject.SetActive(true);
        icon.gameObject.SetActive(true);
    }

    public void DisableFocus()
    {
        iconLarge.gameObject.SetActive(true);
        tvName.gameObject.SetActive(false);
        tvDistance.gameObject.SetActive(false);
        icon.gameObject.SetActive(false);
    }

    private void LateUpdate()
    {
        //transform.LookAt(cameraMain);
        float distance = Vector3.Distance(transform.position, cameraMain.position);
        if (distance > 10)
        {
            transform.LookAt(cameraMain);
            childNode?.SetActive(true);
        }
        else
        {
            childNode?. SetActive(false);
        }
    }

    public void OnTap()
    {
        actionOnTap.Invoke(locationData);
    }

    private void OnDestroy()
    {
        if (myTextureIcon != null)
        {
            Destroy(myTextureIcon);
        }
    }

  

}
