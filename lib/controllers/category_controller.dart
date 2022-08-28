import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../models/category.dart';

class CategoryController extends GetxController{
   FirebaseFirestore firestore=FirebaseFirestore.instance;
  var categories=[].obs;

   @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  getCategories()
  {
    firestore.collection('categories').get().then((value) => {
      value.docs.forEach((element) {
        print(element);
        Category c=Category.fromJson(Map.from(element.data()));
        categories.add(c);
      })
    });
  }
}