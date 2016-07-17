package com.starlight36.react.amap;

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.help.InputtipsQuery;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;


/**
 * Created by marshal on 16/6/6.
 */
public class ReactAMapSearchManager extends ReactContextBaseJavaModule {
    private ReactContext reactContext;

    public ReactAMapSearchManager(ReactApplicationContext rContext) {
        super(rContext);
        reactContext = rContext;
    }

    @Override
    public String getName() {
        return "AMapSearchManager";
    }

    @ReactMethod
    public void inputtipsSearch(String requestId, String keys, String city) {
        InputtipsQuery inputtipsQuery = new InputtipsQuery(keys, city);
        ReactAMapSearch request = new ReactAMapSearch(reactContext, requestId);

        request.inputTips.setQuery(inputtipsQuery);
        request.inputTips.requestInputtipsAsyn();
    }

    @ReactMethod
    public void geocodeSearch(String requestId, String address, String city) {
        ReactAMapSearch request = new ReactAMapSearch(reactContext, requestId);
        GeocodeQuery query = new GeocodeQuery(address, city);

        request.geocodeSearch.getFromLocationNameAsyn(query);
    }

    @ReactMethod
    public void regeocodeSearch(String requestId, ReadableMap latlon, Float radius) {
        ReactAMapSearch request = new ReactAMapSearch(reactContext, requestId);
        LatLonPoint point = new LatLonPoint(latlon.getDouble("latitude"), latlon.getDouble("longitude"));
        RegeocodeQuery query = new RegeocodeQuery(point, radius != null?radius:1000, GeocodeSearch.AMAP);

        request.geocodeSearch.getFromLocationAsyn(query);
    }
}
