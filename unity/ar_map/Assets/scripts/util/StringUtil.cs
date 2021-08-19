using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;

public class StringUtil 
{
    public static string DecodeString(string data)
    {
        //string str = @"P\u003e\u003cp\u003e Notes \u003cstrong\u003e Разработчик: \u003c/STRONG\u003e \u003cbr /\u003eЕсли игра Безразлично";
        Regex regex = new Regex(@"\\u([0-9a-z]{4})", RegexOptions.IgnoreCase);
        data = regex.Replace(data, match => char.ConvertFromUtf32(Int32.Parse(match.Groups[1].Value, System.Globalization.NumberStyles.HexNumber)));
        return data;
    }

    public static Color HexToColor(string hex)
    {
        Color newCol;

        if (ColorUtility.TryParseHtmlString(hex, out newCol))
        {
           return  newCol;
        }
        return new Color(248, 111, 39);
    }

    public static Color GetColorByExperienceId(string id)
    {
        switch (id)
        {
            case "0":
                return HexToColor("#FBBC43");
            case "22":
                return HexToColor("#212237");
            case "19":
                return HexToColor("#7DB2E1");
            case "20":
                return HexToColor("#DA7112");
            case "23":
                return HexToColor("#7DB2E1");
            case "21":
                return HexToColor("#E75D52");
            default:
                return HexToColor("#FBBC43");
        }
    }

    public static int GetIconByExperienceId(string id)
    {
        switch (id)
        {
            case "0":
                return 0;
            case "22":
                return 1;
            case "19":
                return 2;
            case "20":
                return 3;
            case "23":
                return 4;
            case "21":
                return 5;
            default:
                return 0;
        }
    }
}
