/**
 * Created by chenjunsheng on 16/7/17.
 */
'use strict';

import {
    NativeAppEventEmitter,
    DeviceEventEmitter,
    NativeModules,
    Platform,
} from 'react-native';

const AMapSearchManager = NativeModules.AMapSearchManager;
const emitter = Platform.OS == 'ios' ? NativeAppEventEmitter : DeviceEventEmitter;

let lastId = "", promiseQueue = {}
const requestIdGenerator = (type = "AMapSearch")=> {
    let requestId = `${type}-${+new Date}-${Math.ceil(Math.random()*100000)}`
    if (requestId == lastId) {
        return requestIdGenerator(type)
    }
    lastId = requestId;
    return lastId;
};

const searchRequstFactory = (type) => (...args) => {
    if (AMapSearchManager[type]) {
        let resolve, reject, promise =  new Promise((res, rej)=> {
                resolve = res, reject = rej
            }),
            requestId = requestIdGenerator(type)

        args = [requestId, ...args]

        AMapSearchManager[type].apply(null, args)
        promiseQueue[requestId] = {resolve, reject}
        return promise
    }
};

emitter.addListener(
    'ReceiveAMapSearchResult',
    (reminder) => {
        let {data, error, requestId} = reminder
        if(requestId && promiseQueue[requestId]) {
            let promise = promiseQueue[requestId];
            if (error) {
                promise.reject(error)
            } else {
                promise.resolve(data)
            }
        }
    }
);

export const inputTipsSearch = searchRequstFactory('inputTipsSearch');
export const geocodeSearch = searchRequstFactory('geocodeSearch');
export const regeocodeSearch = searchRequstFactory('regeocodeSearch');
