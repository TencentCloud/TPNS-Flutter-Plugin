package com.tencent.tpns.plugin


import android.util.Log
import androidx.annotation.NonNull
import com.tencent.android.tpush.XGIOperateCallback
import com.tencent.android.tpush.XGPushConfig
import com.tencent.android.tpush.XGPushManager
import com.tencent.android.tpush.XGPushConstants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


public class XgFlutterPlugin : FlutterPlugin, MethodCallHandler {


    private var TAG = "| XgpushpPlugin | Flutter | Android | "

    constructor() {
        instance = this
    }

    constructor(binding: FlutterPlugin.FlutterPluginBinding, methodChannel: MethodChannel) {
        mPluginBinding = binding
        channel = methodChannel
        instance = this
    }

    constructor(mRegistrar: Registrar, mChannel: MethodChannel) {
        channel = mChannel
        registrar = mRegistrar
        instance = this
    }

    companion object {
        lateinit var instance: XgFlutterPlugin
        lateinit var mPluginBinding: FlutterPlugin.FlutterPluginBinding
        lateinit var channel: MethodChannel
        lateinit var registrar: Registrar
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "tpns_flutter_plugin")
            channel.setMethodCallHandler(XgFlutterPlugin(registrar, channel))
        }

        fun checkPluginBindingInit() : Boolean {
            return this::mPluginBinding.isInitialized
        }

        // 为兼容老版本 Flutter 项目插件加载方式，结合 kotlin lateinit 对象特性，
        // 需要在判断 mPluginBinding == mull 之前先判断是否有初始化
        fun isPluginBindingValid() : Boolean {
            if (checkPluginBindingInit()) {
//                Log.i("| XgpushpPlugin | Flutter | Android | ", 
//                        "mPluginBinding initialzed, " + (mPluginBinding != null))
                return mPluginBinding != null
            } else {
                Log.i("| XgpushpPlugin | Flutter | Android | ", "mPluginBinding not initialzed")
                return false
            }
        }
    }

    override fun onMethodCall(@NonNull p0: MethodCall, @NonNull p1: MethodChannel.Result) {
        Log.i(TAG, p0.method)
        if (!isPluginBindingValid() && registrar == null) {
            Log.i(TAG, "调用native的函数" + p0.method + "失败mPluginBinding==null&&registrar==null")
            return
        }
        when (p0.method) {
            Extras.FOR_FLUTTER_METHOD_REG_PUSH -> regPush(p0, p1)
            Extras.FOR_FLUTTER_METHOD_UNREGISTER_PUSH -> stopXg(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_TAG -> setXgTag(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_TAGS -> setXgTags(p0, p1)
            Extras.FOR_FLUTTER_METHOD_ADD_TAGS -> addXgTags(p0, p1)
            Extras.FOR_FLUTTER_METHOD_DELETE_TAG -> deleteXgTag(p0, p1)
            Extras.FOR_FLUTTER_METHOD_DELETE_TAGS -> deleteXgTags(p0, p1)
            Extras.FOR_FLUTTER_METHOD_CLEAN_TAGS -> cleanXgTags(p0, p1)
            Extras.FOR_FLUTTER_METHOD_GET_TOKEN -> xgToken(p0, p1)
            Extras.FOR_FLUTTER_METHOD_GET_SDK_VERSION -> xgSdkVersion(p0, p1)
            Extras.FOR_FLUTTER_METHOD_BIND_ACCOUNT -> bindAccount(p0, p1)
            Extras.FOR_FLUTTER_METHOD_APPEND_ACCOUNT -> appendAccount(p0, p1)
            Extras.FOR_FLUTTER_METHOD_DEL_ACCOUNT -> delAccount(p0, p1)
            Extras.FOR_FLUTTER_METHOD_DEL_ALL_ACCOUNT -> delAllAccount(p0, p1)
            Extras.FOR_FLUTTER_METHOD_ENABLE_OTHER_PUSH -> enableOtherPush(p0, p1)
            Extras.FOR_FLUTTER_METHOD_ENABLE_OTHER_PUSH2 -> enableOtherPush2(p0, p1)
            Extras.FOR_FLUTTER_METHOD_GET_OTHER_PUSH_TOKEN -> getOtherPushToken(p0, p1)
            Extras.FOR_FLUTTER_METHOD_GET_OTHER_PUSH_TYPE -> getOtherPushType(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_BADGE_NUM -> setBadgeNum(p0, p1)
            Extras.FOR_FLUTTER_METHOD_RESET_BADGE_NUM -> resetBadgeNum(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_MI_PUSH_APP_ID -> setMiPushAppId(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_MI_PUSH_APP_KEY -> setMiPushAppKey(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_MZ_PUSH_ID -> setMzPushAppId(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_MZ_PUSH_KEY -> setMzPushAppKey(p0, p1)
            Extras.FOR_FLUTTER_METHOD_ENABLE_OPPO_NOTIFICATION -> enableOppoNotification(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_OPPO_PUSH_APP_KEY -> setOppoPushAppKey(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_OPPO_PUSH_APP_ID -> setOppoPushAppId(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_MIUI_ROM -> isMiuiRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_EMUI_ROM -> isEmuiRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_MEIZU_ROM -> isMeizuRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_OPPO_ROM -> isOppoRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_VIVO_ROM -> isVivoRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_FCM_ROM -> isFcmRom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_IS_360_ROM -> is360Rom(p0, p1)
            Extras.FOR_FLUTTER_METHOD_ENABLE_DEBUG -> setEnableDebug(p0, p1)
            Extras.FOR_FLUTTER_METHOD_SET_HEADER_BEAT_INTERVAL_MS -> setHeartbeatIntervalMs(p0, p1)
        }
    }


    /**
     * 调用Flutter 函数
     *
     * @param methodName 函数名称
     * @param para       参数
     */
    fun toFlutterMethod(methodName: String, para: Map<String, Any?>?) {
        Log.i(TAG, "调用Flutter=>${methodName}")
        MainHandler.getInstance().post { channel.invokeMethod(methodName, para) }
    }

    fun toFlutterMethod(methodName: String, para: String) {
        Log.i(TAG, "调用Flutter=>${methodName}")
        MainHandler.getInstance().post { channel.invokeMethod(methodName, para) }
    }

    /**
     * 信鸽推送注册
     */
    fun regPush(call: MethodCall?, result: MethodChannel.Result?) {
        Log.i(TAG, "调用信鸽SDK-->registerPush()")
        XGPushManager.registerPush(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext)
    }

    fun mRegPush(methodName: String, para: Map<String, Any?>?) {
        MainHandler.getInstance().post { channel.invokeMethod("startXg", para) }
    }

    /**
     * 开启Debug模式
     */
    private fun setEnableDebug(call: MethodCall, result: MethodChannel.Result) {
        val map = call.arguments<HashMap<String, Any>>()
        val debug = map[Extras.DEBUG] as Boolean
        Log.i(TAG, "调用信鸽SDK-->enableDebug()----->isDebug=${debug}")
        XGPushConfig.enableDebug(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, debug)
    }

    /**
     * 设置心跳时间间隔
     */
    fun setHeartbeatIntervalMs(call: MethodCall, result: MethodChannel.Result) {
        val map = call.arguments<HashMap<String, Any>>()
        val interval = map[Extras.HEADER_BEAT_INTERVAL_MS] as Int
        Log.i(TAG, "调用信鸽SDK-->setHeartbeatIntervalMs()----->interval=${interval}")
        XGPushConfig.setHeartbeatIntervalMs(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, interval)
    }

    /**
     * 反注册
     *
     *
     * 当用户已退出或 App 被关闭，不再需要接收推送时，可以取消注册 App，即反注册。
     * （一旦设备反注册，直到这个设备重新注册成功期间内，下发的消息该设备都无法收到）
     *
     * @param call   方法
     * @param result 结果
     */
    fun stopXg(call: MethodCall?, result: MethodChannel.Result?) {
        Log.i(TAG, "调用信鸽SDK-->unregisterPush()")
        XGPushManager.unregisterPush(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext)
    }

    /**
     * 设置标签,单个标签 call传参为TagName
     *
     * @param call   方法
     * @param result 结果
     */
    fun setXgTag(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<HashMap<String, String>>()
        val tagName = map[Extras.TAG_NAME]
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->setTag()---->tagName${tagName}")
        XGPushManager.setTag(context, tagName, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "setTag successful")
                val para = "setTag successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "setTag failure")
                val para = "setTag failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 设置多tag call传参为List<String>tag的集合
     * 一次设置多个标签，会覆盖这个设备之前设置的标签。
     *
     * @param call   方法
     * @param result 结果
    </String> */
    fun setXgTags(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, List<String>>>()
        val tags = HashSet<String>(map[Extras.TAG_NAMES])
        //operateName用户定义的操作名称，回调结果会原样返回，用于标识回调属于哪次操作。
        val operateName = "setTags:" + System.currentTimeMillis()
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->setTags()")
        XGPushManager.setTags(context, operateName, tags, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "setTags successful")
                val para = "setTags successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "setTags failure")
                val para = "setTags failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 添加多个标签  call传参为List<String>tag的集合 每个 tag 不能超过40字节（超过会抛弃）不能包含空格（含有空格会删除空格)
     * 最多设置1000个 tag，超过部分会抛弃
     * 一次设置多个标签，会覆盖这个设备之前设置的标签。
     *
     *
     * 如果新增的标签的格式为 "test:2 level:2"，则会删除这个设备的全部历史标签，再新增 test:2 和 level。
     * 如果新增的标签有部分不带:号，如 "test:2 level"，则会删除这个设备的全部历史标签，再新增 test:2 和 level 标签。
     *
     *
     * 新增的 tags 中，:号为后台关键字，请根据具体的业务场景使用。
     * 此接口调用的时候需要间隔一段时间（建议大于5s），否则可能造成更新失败。
     *
     * @param call   方法
     * @param result 结果
    </String> */
    fun addXgTags(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, List<String>>>()
        val tags = HashSet<String>(map[Extras.TAG_NAMES])
        //operateName用户定义的操作名称，回调结果会原样返回，用于标识回调属于哪次操作。
        val operateName = "addTags:" + System.currentTimeMillis()
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->addTags()")
        XGPushManager.addTags(context, operateName, tags, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "addTags successful")
                val para = "addTags successful"
                toFlutterMethod(Extras.XG_PUSH_DID_BIND_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "addTags failure")
                val para = "addTags failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_BIND_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 删除指定标签 call传参为TagName需要删除的标签名称
     *
     * @param call   方法
     * @param result 结果
     */
    fun deleteXgTag(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val tagName = map[Extras.TAG_NAME]
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->deleteTag()----tagName=${tagName}")
        XGPushManager.deleteTag(context, tagName, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "deleteTag successful")
                val para = "deleteTag successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "deleteTag failure")
                val para = "deleteTag failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }
        })
    }


    /**
     * 删除多个标签  call传参为List<String>tag的集合 每个标签是一个 String。限制：
     * 每个 tag 不能超过40字节（超过会抛弃），不能包含空格（含有空格会删除空格）。最多设置1000个tag，超过部分会抛弃。
     *
     * @param call   方法
     * @param result 结果
    </String> */
    fun deleteXgTags(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, List<String>>>()
        val tags = HashSet<String>(map[Extras.TAG_NAMES])
        //operateName用户定义的操作名称，回调结果会原样返回，用于标识回调属于哪次操作。
        val operateName = "deleteTags:" + System.currentTimeMillis()
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->deleteTags()----operateName=${operateName}")
        XGPushManager.deleteTags(context, operateName, tags, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "deleteTags successful")
                val para = "deleteTags successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "deleteTags failure")
                val para = "deleteTags failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }
        })
    }


    /**
     * 清楚所有标签
     *
     * @param call   方法
     * @param result 结果
     */
    fun cleanXgTags(call: MethodCall?, result: MethodChannel.Result?) { //operateName用户定义的操作名称，回调结果会原样返回，用于标识回调属于哪次操作。
        val operateName = "cleanTags:" + System.currentTimeMillis()
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->cleanTags()----operateName=${operateName}")
        XGPushManager.cleanTags(context, operateName, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "cleanTags successful")
                val para = "cleanTags successful"
                toFlutterMethod(Extras.XG_PUSH_DID_CLEAR_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "cleanTags failure")
                val para = "cleanTags failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_CLEAR_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 获取Xg的token
     * App 第一次注册会产生 Token，之后一直存在手机上，不管以后注销注册操作，该 Token 一直存在，
     * 当 App 完全卸载重装了 Token 会发生变化。不同 App 之间的 Token 不一样。
     */
    fun xgToken(call: MethodCall?, result: MethodChannel.Result) {
        val token: String = XGPushConfig.getToken(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext)
        Log.i(TAG, "调用信鸽SDK-->getToken()----token=${token}")
        result.success(token)
    }

    fun xgSdkVersion(call: MethodCall?, result: MethodChannel.Result) {
        val sdkVersion: String = XGPushConstants.SDK_VERSION
        Log.i(TAG, "调用信鸽SDK-->SDK_VERSION----${sdkVersion}")
        result.success(sdkVersion)
    }

    fun getAccountType(accountType: String): Int {
        when (accountType) {
            "UNKNOWN" -> return XGPushManager.AccountType.UNKNOWN.getValue()
            "CUSTOM" -> return XGPushManager.AccountType.CUSTOM.getValue()
//            "IDFA" -> return XGPushManager.AccountType.IDFA.getValue()
            "PHONE_NUMBER" -> return XGPushManager.AccountType.PHONE_NUMBER.getValue()
            "WX_OPEN_ID" -> return XGPushManager.AccountType.WX_OPEN_ID.getValue()
            "QQ_OPEN_ID" -> return XGPushManager.AccountType.QQ_OPEN_ID.getValue()
            "EMAIL" -> return XGPushManager.AccountType.EMAIL.getValue()
            "SINA_WEIBO" -> return XGPushManager.AccountType.SINA_WEIBO.getValue()
            "ALIPAY" -> return XGPushManager.AccountType.ALIPAY.getValue()
            "TAOBAO" -> return XGPushManager.AccountType.TAOBAO.getValue()
            "DOUBAN" -> return XGPushManager.AccountType.DOUBAN.getValue()
            "FACEBOOK" -> return XGPushManager.AccountType.FACEBOOK.getValue()
            "TWITTER" -> return XGPushManager.AccountType.TWITTER.getValue()
            "GOOGLE" -> return XGPushManager.AccountType.GOOGLE.getValue()
            "BAIDU" -> return XGPushManager.AccountType.BAIDU.getValue()
            "JINGDONG" -> return XGPushManager.AccountType.JINGDONG.getValue()
            "LINKEDIN" -> return XGPushManager.AccountType.LINKEDIN.getValue()
            "IMEI" -> return XGPushManager.AccountType.IMEI.getValue()
            else -> return XGPushManager.AccountType.UNKNOWN.getValue()
        }
    }

    /**
     * 绑定账号注册
     * 推荐有账号体系的App使用（此接口会覆盖设备之前绑定过的账号，仅当前注册的账号生效）
     *
     * @param call   String 账号
     * @param result 结果
     */
    fun bindAccount(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val account = map[Extras.ACCOUNT]
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        var accountType: String = (map[Extras.ACCOUNT_TYPE]) ?: "UNKNOWN"
        Log.i(TAG, "调用信鸽SDK-->bindAccount()----account=${account}, accountType=${accountType}")
        XGPushManager.bindAccount(context, account, getAccountType(accountType), object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "bindAccount successful")
                val para = "bindAccount successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "bindAccount failure")
                val para = "bindAccount failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UPDATED_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 添加账号
     * 推荐有账号体系的App使用（此接口保留之前的账号，只做增加操作，一个token下最多只能有10个账号超过限制会自动顶掉之前绑定的账号)
     *
     * @param call   String 账号
     * @param result 结果
     */
    fun appendAccount(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val account = map[Extras.ACCOUNT]
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        var accountType: String = (map[Extras.ACCOUNT_TYPE]) ?: "UNKNOWN"
        Log.i(TAG, "调用信鸽SDK-->appendAccount()----account=${account}, accountType=${accountType}")
        XGPushManager.appendAccount(context, account, getAccountType(accountType), object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "appendAccount successful")
                val para = "appendAccount successful"
                toFlutterMethod(Extras.XG_PUSH_DID_BIND_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "appendAccount failure")
                val para = "appendAccount failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_BIND_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 解除指定账号绑定
     * 账号解绑只是解除 Token 与 App 账号的关联，若使用全量/标签/Token 推送仍然能收到通知/消息。
     *
     * @param call   String账号
     * @param result 结果
     */
    fun delAccount(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val account = map[Extras.ACCOUNT]
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        var accountType: String = (map[Extras.ACCOUNT_TYPE]) ?: "UNKNOWN"
        Log.i(TAG, "调用信鸽SDK-->delAccount()----account=${account}, accountType=${accountType}")
        XGPushManager.delAccount(context, account, getAccountType(accountType), object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "delAccount successful")
                val para = "delAccount successful"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "delAccount failure")
                val para = "delAccount failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_UNBIND_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 清除全部账号
     */
    fun delAllAccount(call: MethodCall, result: MethodChannel.Result?) {
        val context = if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext
        Log.i(TAG, "调用信鸽SDK-->delAllAccount()")
        XGPushManager.delAllAccount(context, object : XGIOperateCallback {
            override fun onSuccess(p0: Any?, p1: Int) {
                Log.i(TAG, "delAllAccount successful")
                val para = "delAllAccount successful"
                toFlutterMethod(Extras.XG_PUSH_DID_CLEAR_WITH_IDENENTIFIER, para)
            }

            override fun onFail(p0: Any?, p1: Int, p2: String?) {
                Log.i(TAG, "delAllAccount failure")
                val para = "delAllAccount failure----->code=${p1}--->message=${p2}"
                toFlutterMethod(Extras.XG_PUSH_DID_CLEAR_WITH_IDENENTIFIER, para)
            }
        })
    }

    /**
     * 开启其他推送  XGPushManager.registerPush 前，开启第三方推送
     */
    fun enableOtherPush(call: MethodCall, result: MethodChannel.Result?) {
        Log.i(TAG, "调用信鸽SDK-->enableOtherPush()")
        XGPushConfig.enableOtherPush(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, true)
    }

    /**
     * 开启其他推送  XGPushManager.registerPush 前，开启第三方推送
     */
    fun enableOtherPush2(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<HashMap<String, Any>>()
        val enable = map["enable"] as Boolean
        Log.i(TAG, "调用信鸽SDK-->enableOtherPush2()")
        XGPushConfig.enableOtherPush(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, enable)
    }

    /**
     * 获取厂商推送 token  XGPushManager.registerPush 成功后
     */
    fun getOtherPushToken(call: MethodCall?, result: MethodChannel.Result) {
        val otherPushToken: String = (XGPushConfig.getOtherPushToken(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext))?:""
        Log.i(TAG, "调用信鸽SDK-->getOtherPushToken()---otherPushToken=${otherPushToken}")
        result.success(otherPushToken)
    }

    /**
     * 获取厂商推送品牌  XGPushManager.registerPush 成功后
     */
    fun getOtherPushType(call: MethodCall?, result: MethodChannel.Result) {
        val otherPushType: String = (XGPushConfig.getOtherPushType(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext))?:""
        Log.i(TAG, "调用信鸽SDK-->getOtherPushType()---otherPushType=${otherPushType}")
        result.success(otherPushType)
    }

    fun setBadgeNum(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, Int>>()
        val badgeNum = map[Extras.BADGE_NUM] as Int
        Log.i(TAG, "调用信鸽SDK-->setBadgeNum()-----badgeNum=${badgeNum}")
        XGPushConfig.setBadgeNum(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, badgeNum)
    }

    fun resetBadgeNum(call: MethodCall, result: MethodChannel.Result?) {
        Log.i(TAG, "调用信鸽SDK-->resetBadgeNum()")
        XGPushConfig.resetBadgeNum(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext)
    }


    /**
     * 设置小米平台的APP_KEY
     * 推荐有账号体系的App使用（此接口保留之前的账号，只做增加操作，一个token下最多只能有10个账号超过限制会自动顶掉之前绑定的账号)
     *
     * @param call   String APP_KEY
     * @param result 结果
     */
    fun setMiPushAppKey(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val appKey = map[Extras.APP_KEY]
        Log.i(TAG, "调用信鸽SDK-->setMiPushAppKey()-----key=${appKey}")
        XGPushConfig.setMiPushAppKey(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appKey)
    }

    /**
     * 设置小米平台的APP_ID
     *
     * @param call   String app_id
     * @param result 结果
     */
    fun setMiPushAppId(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val appId = map[Extras.APP_ID]
        Log.i(TAG, "调用信鸽SDK-->setMiPushAppId()-----appId=${appId}")
        XGPushConfig.setMiPushAppId(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appId)
    }


    /**
     * 设置魅族平台的的APP_KEy
     */
    fun setMzPushAppKey(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val appKey = map[Extras.APP_KEY]
        Log.i(TAG, "调用信鸽SDK-->setMzPushAppKey()-----appKey=${appKey}")
        XGPushConfig.setMzPushAppKey(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appKey)
    }

    /**
     * 设置魅族平台的的APP_KEy
     */
    fun setMzPushAppId(call: MethodCall, result: MethodChannel.Result?) {
        val map = call.arguments<Map<String, String>>()
        val appId = map[Extras.APP_ID]
        Log.i(TAG, "调用信鸽SDK-->setMzPushAppId()-----appId=${appId}")
        XGPushConfig.setMzPushAppId(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appId)
    }

    /**
     * 在调用腾讯移动推送 XGPushManager.registerPush前，调用以下代码：
     * 在应用首次启动时弹出通知栏权限请求窗口，应用安装周期内，提示弹窗仅展示一次。需 TPNS-OPPO 依赖包版本在 1.1.5.1 及以上支持，系统 ColorOS 5.0 以上有效。
     */
    private fun enableOppoNotification(call: MethodCall, result: MethodChannel.Result) {
        val map = call.arguments<Map<String, Any>>()
        val isNotification = map["isNotification"] as Boolean
        Log.i(TAG, "调用信鸽SDK-->enableOppoNotification()-----isNotification=${isNotification}")
        XGPushConfig.enableOppoNotification(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, isNotification)
    }

    /**
     * 设置OPPO的key
     *
     * @param call   String类型的APPKey
     * @param result
     */
    private fun setOppoPushAppKey(call: MethodCall, result: MethodChannel.Result) {
        val map = call.arguments<Map<String, String>>()
        val appKey = map[Extras.APP_KEY]
        Log.i(TAG, "调用信鸽SDK-->setOppoPushAppKey()-----appKey=${appKey}")
        XGPushConfig.setOppoPushAppKey(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appKey)
    }

    /**
     * 设置OPPO的appID
     *
     * @param call   String 类型发AppId
     * @param result
     */
    private fun setOppoPushAppId(call: MethodCall, result: MethodChannel.Result) {
        val map = call.arguments<Map<String, String>>()
        val appId = map[Extras.APP_ID]
        Log.i(TAG, "调用信鸽SDK-->setOppoPushAppId()-----appId=${appId}")
        XGPushConfig.setOppoPushAppId(if (!isPluginBindingValid()) registrar.context() else mPluginBinding.applicationContext, appId)
    }

    /**
     * 判断是否为谷歌手机
     */
    fun isFcmRom(call: MethodCall?, result: MethodChannel.Result?) { //        boolean is
    }

    /**
     * 判断是否为360手机
     */
    private fun is360Rom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "is360Rom===" + DeviceInfoUtil.is360Rom())
        result.success(DeviceInfoUtil.is360Rom())
    }

    /**
     * 判断是否为Vivo手机
     */
    private fun isVivoRom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "isVivoRom===" + DeviceInfoUtil.isVivoRom())
        result.success(DeviceInfoUtil.isVivoRom())
    }

    /**
     * 判断是否为Oppo手机
     */
    private fun isOppoRom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "isOppoRom===" + DeviceInfoUtil.isOppoRom())
        result.success(DeviceInfoUtil.isOppoRom())
    }

    /**
     * 判断是否为魅族手机
     */
    private fun isMeizuRom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "isMeizuRom===" + DeviceInfoUtil.isMeizuRom())
        result.success(DeviceInfoUtil.isMeizuRom())
    }

    /**
     * 判断是否为华为手机
     */
    private fun isEmuiRom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "isEmuiRom===" + DeviceInfoUtil.isEmuiRom())
        result.success(DeviceInfoUtil.isEmuiRom())
    }

    /**
     * 判断是否为小米手机
     */
    private fun isMiuiRom(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "isMiuiRom===" + DeviceInfoUtil.isMiuiRom())
        result.success(DeviceInfoUtil.isMiuiRom())
    }


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel1 = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "tpns_flutter_plugin")
        channel1.setMethodCallHandler(XgFlutterPlugin(flutterPluginBinding, channel1))
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
