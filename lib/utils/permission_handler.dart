import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class PermissionUtil {
  factory PermissionUtil() {
    return _singleton;
  }

  static final PermissionUtil _singleton = PermissionUtil._internal();
  PermissionUtil._internal() {
    debugPrint("Instance created PermissionUtil");
  }

  Future<PermissionStatus> getLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;

    debugPrint("permission : $permission");

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.location.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus, context) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to location denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  getAllParties(BuildContext context) async {
    PermissionStatus permissionStatus = await getLocationPermission();
    if (permissionStatus == PermissionStatus.granted) {
    } else {
      handleInvalidPermissions(permissionStatus, context);
    }
  }

  Future<bool> getLocationStatus(BuildContext context) async {
    bool status = false;
    PermissionStatus permissionStatus = await getLocationPermission();
    if (permissionStatus == PermissionStatus.granted) {
      status = true;
    } else {
      status = false;
      handleInvalidPermissions(permissionStatus, context);
    }
    return status;
  }

  Future<bool> getGPSStatus() async {
    loc.Location locationR = loc.Location();
    bool serviceEnabled = false;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await locationR.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationR.requestService();
      if (!serviceEnabled) {
        serviceEnabled = false;
      } else {
        serviceEnabled = true;
      }
    }

    permissionGranted = await locationR.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await locationR.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return false;
      }
    }
    return serviceEnabled;
  }

  Future<bool> handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
