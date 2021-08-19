using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class MyLocationData 
{
    public String lat;
    public String longitude;
    public String id;
    public String street;
    public String location_at;
    public String address;
    public ParentData parent;

}


[Serializable]
public class ParentData
{
    public String id;
    public String title;
    public String type;
    public ImageModel thumb;
    public CategoryModel category;
    public Experience experience;
}


[Serializable]
public class CategoryModel
{
    public String id;
    public String name;
    public String icon;

}

[Serializable]
public class Experience
{
    public String id;
    public String name;
}



[Serializable]
public class ImageModel
{
    public String id;
    public String name;
    public String url;

}

