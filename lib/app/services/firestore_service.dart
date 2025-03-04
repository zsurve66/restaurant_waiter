import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../constants/app_enums.dart';
import '../data/user_data.dart';

class FirestoreService extends GetxService {
  static FirestoreService get to => Get.find();

  static const String _usersCollection = 'users';

  Future<void> createUser() async {
    User user = FirebaseAuth.instance.currentUser!;

    UserData userData = UserData(
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '',
      uid: user.uid,
      userType: UserType.waiter,
    );

    await FirebaseFirestore.instance
        .collection(_usersCollection)
        .doc(user.uid)
        .set(userData.toMap());
  }

  Query getUnAssignedServices() {
    return FirebaseFirestore.instance
        .collection('services')
        .where('serviceStatus', isEqualTo: ServiceStatus.pending.name);
  }

  Query getAssignedServices() {
    return FirebaseFirestore.instance
        .collection('services')
        .where('serviceStatus', isEqualTo: ServiceStatus.assigned.name)
        .where('assignedWaiterId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> acceptService(String serviceId) async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(serviceId)
        .update({
      'serviceStatus': ServiceStatus.assigned.name,
      'assignedWaiterId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
