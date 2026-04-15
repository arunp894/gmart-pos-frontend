package com.macromend.gmart;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.*;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.*;
import com.imin.library.IminSDKManager;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "usb_printer_channel";
    private static final String ACTION_USB_PERMISSION = "com.example.print_app.USB_PERMISSION";

    private UsbManager usbManager;
    private UsbDeviceConnection connection;
    private UsbInterface usbInterface;
    private UsbEndpoint endpointOut;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        usbManager = (UsbManager) getSystemService(Context.USB_SERVICE);
        if (usbManager == null) {
            Log.e("USB_DEBUG", "UsbManager is null!");
        }

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "getConnectedPrinters":
                            result.success(getConnectedPrinters());
                            break;
                        case "cashBox":
                            IminSDKManager.opencashBox(this);
                            result.success("");
                            break;
                        case "requestUsbPermission":
                            String deviceId = call.argument("deviceId");
                            if (usbManager != null && deviceId != null) {
                                requestUsbPermission(deviceId);
                                result.success(true);
                            } else {
                                Log.e("USB_DEBUG", "usbManager or deviceId is null in requestUsbPermission");
                                result.success(false);
                            }
                            break;
                        case "printData":
                            String devId = call.argument("deviceId");
                            List<Integer> dataList = call.argument("data");
                            if (usbManager == null) {
                                Log.e("USB_DEBUG", "usbManager is null in printData!");
                                result.success(false);
                                return;
                            }
                            if (devId == null || dataList == null) {
                                Log.e("USB_DEBUG", "deviceId or dataList is null in printData!");
                                result.success(false);
                                return;
                            }
                            byte[] data = new byte[dataList.size()];
                            for (int i = 0; i < dataList.size(); i++) {
                                data[i] = dataList.get(i).byteValue();
                            }
                            boolean ok = printData(devId, data);
                            result.success(ok);
                            break;
                        default:
                            result.notImplemented();
                    }
                });

//        // Register USB permission receiver
//        IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
//        registerReceiver(usbReceiver, filter);

        IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) { // API 33+
            registerReceiver(usbReceiver, filter, Context.RECEIVER_NOT_EXPORTED);
        } else {
            registerReceiver(usbReceiver, filter);
        }

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        try {
            unregisterReceiver(usbReceiver);
        } catch (Exception e) {
            Log.e("USB_DEBUG", "Receiver already unregistered: " + e.getMessage());
        }
    }

    private List<Map<String, Object>> getConnectedPrinters() {
        if (usbManager == null) {
            Log.e("USB_DEBUG", "usbManager is null in getConnectedPrinters!");
            return Collections.emptyList();
        }
        HashMap<String, UsbDevice> deviceList = usbManager.getDeviceList();
        List<Map<String, Object>> printers = new ArrayList<>();
        for (UsbDevice device : deviceList.values()) {
            Map<String, Object> dev = new HashMap<>();
            dev.put("deviceId", String.valueOf(device.getDeviceId()));
            dev.put("vendorId", device.getVendorId());
            dev.put("productId", device.getProductId());
            dev.put("deviceName", device.getDeviceName());
            printers.add(dev);
        }
        Log.d("USB_DEBUG", "Found printers: " + printers.size());
        return printers;
    }

    private void requestUsbPermission(String deviceIdStr) {
        if (usbManager == null) {
            Log.e("USB_DEBUG", "usbManager is null in requestUsbPermission!");
            return;
        }
        int deviceId = Integer.parseInt(deviceIdStr);
        for (UsbDevice device : usbManager.getDeviceList().values()) {
            if (device.getDeviceId() == deviceId) {
                PendingIntent pi = PendingIntent.getBroadcast(
                        this,
                        0,
                        new Intent(ACTION_USB_PERMISSION),
                        Build.VERSION.SDK_INT >= 31 ? PendingIntent.FLAG_MUTABLE : 0
                );
                usbManager.requestPermission(device, pi);
                Log.d("USB_DEBUG", "Requested permission for deviceId: " + deviceId);
                break;
            }
        }
    }

    private boolean printData(String deviceIdStr, byte[] data) {
        if (usbManager == null) {
            Log.e("USB_DEBUG", "usbManager is null in printData!");
            return false;
        }
        int deviceId = Integer.parseInt(deviceIdStr);
        for (UsbDevice device : usbManager.getDeviceList().values()) {
            if (device.getDeviceId() == deviceId) {
                connection = usbManager.openDevice(device);
                if (connection == null) {
                    Log.e("USB_DEBUG", "Failed to open device");
                    return false;
                }
                usbInterface = device.getInterface(0);
                connection.claimInterface(usbInterface, true);

                // Find OUT endpoint
                endpointOut = null;
                for (int i = 0; i < usbInterface.getEndpointCount(); i++) {
                    UsbEndpoint ep = usbInterface.getEndpoint(i);
                    if (ep.getType() == UsbConstants.USB_ENDPOINT_XFER_BULK &&
                            ep.getDirection() == UsbConstants.USB_DIR_OUT) {
                        endpointOut = ep;
                        break;
                    }
                }
                if (endpointOut == null) {
                    Log.e("USB_DEBUG", "No OUT endpoint found");
                    connection.releaseInterface(usbInterface);
                    connection.close();
                    return false;
                }
                int r = connection.bulkTransfer(endpointOut, data, data.length, 2000);
                Log.d("USB_DEBUG", "bulkTransfer result: " + r);
                connection.releaseInterface(usbInterface);
                connection.close();
                return r >= 0;
            }
        }
        Log.e("USB_DEBUG", "Device not found by deviceId: " + deviceId);
        return false;
    }

    private final BroadcastReceiver usbReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            if (ACTION_USB_PERMISSION.equals(intent.getAction())) {
                UsbDevice device = intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);
                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                    Log.d("USB_DEBUG", "Permission granted for device: " + device);
                } else {
                    Log.d("USB_DEBUG", "Permission denied for device: " + device);
                }
            }
        }
    };
}
