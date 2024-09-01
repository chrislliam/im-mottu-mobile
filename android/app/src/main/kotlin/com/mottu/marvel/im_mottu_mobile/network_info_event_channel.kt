package com.mottu.marvel.im_mottu_mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import io.flutter.plugin.common.EventChannel

class NetworkInfoEventChannel(private val context: Context) : EventChannel.StreamHandler {
    private var connectivityReceiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        connectivityReceiver = createConnectivityReceiver(events)
        context.registerReceiver(connectivityReceiver, IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION))
    }

    private fun createConnectivityReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val connectivityManager = context?.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                val networkInfo = connectivityManager.activeNetworkInfo
                val isConnected = networkInfo != null && networkInfo.isConnected
                events?.success(isConnected)
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        if (connectivityReceiver != null) {
            context.unregisterReceiver(connectivityReceiver)
            connectivityReceiver = null
        }
    }
}
