import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:integrity/models/serviceModel.dart';


class ServiceController extends GetxController{
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  saveService(ServiceModel service)
  {
    firestore.collection('services').add(service.toJson()).
    then((value) => {
      Get.snackbar('success','Service Created',snackPosition: SnackPosition.BOTTOM)
    }).
    catchError((error) => {
      Get.snackbar('Error',error,snackPosition: SnackPosition.BOTTOM)
    });;
  }
}