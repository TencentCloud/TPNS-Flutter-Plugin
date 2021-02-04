package com.tencent.tpns.plugin;

public interface Extras {
    //参数
    String DEBUG = "enableDebug";
    String TAG_NAME = "tagName";  //tag名称
    String TAG_NAMES = "tagNames"; //tag名称集合
    String CONTENT = "content";  //
    String RESULT_CODE = "resultCode";
    String MESSAGE = "message";
    String PUSH_TOKEN = "pushToken";
    String TITLE = "title";
    String CUSTOM_MESSAGE = "customMessage";
    String PUSH_CHANNEL = "pushChannel";
    String NOTIFACTION_ID = "notifactionId";
    String NOTIFACTION_ACTION_TYPE = "notifactionActionType";
    String MSG_ID = "msgId";
    String ACTIVITY = "activity";
    String ACTIVITY_NAME = "activityName";
    String ACTION_TYPE = "actionType";
    String ACCOUNT = "account";
    String ACCOUNT_TYPE = "accountType";
    String APP_KEY = "appKey";
    String APP_ID = "appId";
    String HEADER_BEAT_INTERVAL_MS = "heartBeatIntervalMs";
    String XG_PUSH_DID_SET_BADGE = "xgPushDidSetBadge";

    //Flutter调用native的函数名称
    String FOR_FLUTTER_METHOD_REG_PUSH = "regPush";
    String FOR_FLUTTER_METHOD_UNREGISTER_PUSH = "stopXg";
    String FOR_FLUTTER_METHOD_SET_TAG = "setXgTag";
    String FOR_FLUTTER_METHOD_SET_TAGS = "setXgTags";
    String FOR_FLUTTER_METHOD_ADD_TAGS = "addXgTags";
    String FOR_FLUTTER_METHOD_DELETE_TAG = "deleteXgTag";
    String FOR_FLUTTER_METHOD_DELETE_TAGS = "deleteXgTags";
    String FOR_FLUTTER_METHOD_CLEAN_TAGS = "cleanXgTags";
    String FOR_FLUTTER_METHOD_GET_TOKEN = "xgToken";
    String FOR_FLUTTER_METHOD_GET_SDK_VERSION = "xgSdkVersion";
    String FOR_FLUTTER_METHOD_BIND_ACCOUNT = "bindAccount";
    String FOR_FLUTTER_METHOD_APPEND_ACCOUNT = "appendAccount";
    String FOR_FLUTTER_METHOD_DEL_ACCOUNT = "delAccount";
    String FOR_FLUTTER_METHOD_DEL_ALL_ACCOUNT = "delAllAccount";
    String FOR_FLUTTER_METHOD_ENABLE_OTHER_PUSH = "enableOtherPush";
    String FOR_FLUTTER_METHOD_ENABLE_OTHER_PUSH2 = "enableOtherPush2";
    String FOR_FLUTTER_METHOD_GET_OTHER_PUSH_TOKEN = "getOtherPushToken";
    String FOR_FLUTTER_METHOD_GET_OTHER_PUSH_TYPE = "getOtherPushType";
    String FOR_FLUTTER_METHOD_SET_MI_PUSH_APP_ID = "setMiPushAppId";
    String FOR_FLUTTER_METHOD_SET_MI_PUSH_APP_KEY = "setMiPushAppKey";
    String FOR_FLUTTER_METHOD_SET_MZ_PUSH_ID = "setMzPushAppId";
    String FOR_FLUTTER_METHOD_SET_MZ_PUSH_KEY = "setMzPushAppKey";
    String FOR_FLUTTER_METHOD_ENABLE_OPPO_NOTIFICATION = "enableOppoNotification";
    String FOR_FLUTTER_METHOD_SET_OPPO_PUSH_APP_ID = "setOppoPushAppId";
    String FOR_FLUTTER_METHOD_SET_OPPO_PUSH_APP_KEY = "setOppoPushAppKey";
    String FOR_FLUTTER_METHOD_IS_MIUI_ROM = "isMiuiRom";
    String FOR_FLUTTER_METHOD_IS_EMUI_ROM = "isEmuiRom";
    String FOR_FLUTTER_METHOD_IS_MEIZU_ROM = "isMeizuRom";
    String FOR_FLUTTER_METHOD_IS_OPPO_ROM = "isOppoRom";
    String FOR_FLUTTER_METHOD_IS_VIVO_ROM = "isVivoRom";
    String FOR_FLUTTER_METHOD_IS_360_ROM = "is360Rom";
    String FOR_FLUTTER_METHOD_IS_FCM_ROM = "isFcmRom";
    String FOR_FLUTTER_METHOD_ENABLE_DEBUG = "setEnableDebug";
    String FOR_FLUTTER_METHOD_SET_HEADER_BEAT_INTERVAL_MS = "setHeartbeatIntervalMs";


    //调用Flutter的函数名称
    String ON_REGISTERED_DEVICE_TOKEN = "onRegisteredDeviceToken"; //获取设备token回调（在注册成功里面获取的）
    String ON_REGISTERED_DONE = "onRegisteredDone";    //注册成功回调
    String UN_REGISTERED = "unRegistered";     //反注册回调
    String ON_RECEIVE_NOTIFICATION_RESPONSE = "onReceiveNotificationResponse";   //收到通知
    String ON_RECEIVE_MESSAGE = "onReceiveMessage";       //收到透传通知
    String XG_PUSH_DID_BIND_WITH_IDENENTIFIER = "xgPushDidBindWithIdentifier";   // 绑定账号跟标签
    String XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER = "xgPushDidUnbindWithIdentifier"; //解绑账号跟标签
    String XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER = "xgPushDidUpdatedBindedIdentifier"; //更新账号跟标签
    String XG_PUSH_DID_CLEAR_WITH_IDENENTIFIER = "xgPushDidClearAllIdentifiers";  //清除账号跟标签
    String XG_PUSH_CLICK_ACTION = "xgPushClickAction";   //通知点击事件
}
