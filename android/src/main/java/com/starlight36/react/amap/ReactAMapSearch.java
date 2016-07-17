package com.starlight36.react.amap;

import android.content.Context;

import java.util.List;

import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.help.Inputtips;
import com.amap.api.services.help.Tip;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

/**
 * Created by marshal on 16/6/8.
 */
public class ReactAMapSearch extends AMapSearch implements GeocodeSearch.OnGeocodeSearchListener, Inputtips.InputtipsListener {
    public Inputtips inputTips;
    public GeocodeSearch geocodeSearch;

    public ReactAMapSearch(Context context, String requestId) {
        inputTips = new Inputtips(context, this);
        geocodeSearch = new GeocodeSearch(context);
        geocodeSearch.setOnGeocodeSearchListener(this);
        this.setRequestId(requestId);
    }

    @Override
    public void onGetInputtips(List<Tip> list, int resultId) {
        if (1000 != resultId) {
            this.sendEventWithError("request inputTips error");
            return;
        }

        WritableArray array = Arguments.createArray();
        for (Tip tip: list
                ) {
            WritableMap map = Arguments.createMap();
            map.putString("name", tip.getName());
            map.putString("district", tip.getDistrict());
            WritableMap location = Arguments.createMap();
            location.putDouble("latitude", tip.getPoint().getLatitude());
            location.putDouble("longitude", tip.getPoint().getLongitude());
            map.putMap("location", location);
            array.pushMap(map);
        }
        this.sendEventWithData(array);
    }

    @Override
    public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int resultId) {
        if (1000 != resultId) {
            this.sendEventWithError("request regeocode error");
            return;
        }
        WritableArray array = Arguments.createArray();
        WritableMap map = Arguments.createMap();
        RegeocodeAddress address = regeocodeResult.getRegeocodeAddress();

        map.putString("formatAddress", address.getFormatAddress());
        map.putString("province",address.getProvince());
        map.putString("city",address.getCity());
        map.putString("township",address.getTownship());
        map.putString("neighborhood",address.getNeighborhood());
        map.putString("building",address.getBuilding());
        map.putString("district", address.getDistrict());

        array.pushMap(map);

        this.sendEventWithData(array);
    }

    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int resultId) {
        if (1000 != resultId) {
            this.sendEventWithError("request geocode error");
            return;
        }

        WritableArray array = Arguments.createArray();
        for (GeocodeAddress address: geocodeResult.getGeocodeAddressList()
                ) {
            WritableMap map = Arguments.createMap();
            map.putString("formatAddress", address.getFormatAddress());
            map.putString("province",address.getProvince());
            map.putString("city",address.getCity());
            map.putString("township",address.getTownship());
            map.putString("neighborhood",address.getNeighborhood());
            map.putString("building",address.getBuilding());
            map.putString("adcode",address.getAdcode());
            map.putString("level",address.getLevel());
            map.putString("district", address.getDistrict());

            WritableMap location = Arguments.createMap();
            location.putDouble("latitude", address.getLatLonPoint().getLatitude());
            location.putDouble("longitude", address.getLatLonPoint().getLongitude());
            map.putMap("location", location);

            array.pushMap(map);
        }
        this.sendEventWithData(array);
    }
}
