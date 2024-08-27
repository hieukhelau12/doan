import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/view/login/login_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  // @override
  // void onReady() {
  //   screenRedirect();
  //   super.onReady();
  // }

  // screenRedirect() async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     if (user.emailVerified) {
  //       Get.offAll(() => const MainTabView());
  //     } else {
  //       Get.offAll(() => VerifyEmailView(
  //             email: _auth.currentUser?.email,
  //           ));
  //     }
  //   } else {
  //     deviceStorage.writeIfNull('IsFirstTime', true);
  //     deviceStorage.read('IsFirstTime') != true
  //         ? Get.offAll(() => const LoginView())
  //         : Get.offAll(() => const OnBoardingView());
  //   }
  // }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Get.snackbar(
            "Thông Báo", "Email đã được sử dụng bởi một tài khoản khác!");
      } else {
        Get.snackbar("Thông Báo", "Lỗi: ${e.code}");
      }
      return null;
    }
  }

  Future<User?> logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" ||
          e.code == "wrong-password" ||
          e.code == "invalid-credential") {
        Get.snackbar("Thông Báo", "Email hoặc mật khẩu không hợp lệ!");
      } else {
        Get.snackbar("Thông Báo", "Lỗi: ${e.code}");
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        return await _auth.signInWithCredential(credential);

        // Get.snackbar("Thông Báo", "Đăng nhập thành công");
        // Get.to(() => const MainTabView());
      }
    } catch (e) {
      print(e);
      Get.snackbar("Thông báo", "Lỗi $e");
    }
    return null;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.snackbar("Thông Báo", "Lỗi: $e");
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      Get.snackbar("Thông Báo", "Lỗi: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginView());
    } catch (e) {
      Get.snackbar("Thông Báo", "Lỗi: $e");
    }
  }
}
