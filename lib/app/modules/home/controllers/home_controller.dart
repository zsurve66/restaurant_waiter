import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../services/firestore_service.dart';

class HomeController extends GetxController {
  Query unAssignedQuery = FirestoreService.to.getUnAssignedServices();
  Query assignedQuery = FirestoreService.to.getAssignedServices();

  void acceptService(String serviceId) {
    FirestoreService.to.acceptService(serviceId);
  }
}
