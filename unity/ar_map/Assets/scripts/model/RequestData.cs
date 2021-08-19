using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class RequestData 
{
    public string data;
    public string responseCode;
    public string message;
}

[Serializable]
public class LocationRequest
{
    public string id;
    public string latti;
    public string longti;
}
