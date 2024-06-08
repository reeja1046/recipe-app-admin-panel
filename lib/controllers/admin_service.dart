import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/core/constants/show_toast.dart';

class AdminService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveAdminDataToFirebase(
      Map<String, dynamic> adminData, adminId) async {
    try {
      await firestore.collection('admin_profile').doc(adminId).set(adminData);
      showToast(message: 'User Data saved to firebase');
    } catch (e) {
      print('Error Occured');
    }
  }

  Future<bool> doesAdminIdExist(String adminId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('admin_profile')
          .where('adminId', isEqualTo: adminId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking if admin ID exists: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAdminData(String adminId) async {
    try {
      DocumentSnapshot adminSnapshot =
          await firestore.collection('admin_profile').doc(adminId).get();
      if (adminSnapshot.exists) {
        Map<String, dynamic> adminData =
            adminSnapshot.data() as Map<String, dynamic>;
        print('User data retrieved successfully: $adminData');
        return adminData;
      } else {
        print('Document does not exist for adminId: $adminId');
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }
}
