import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/firebase_exception_util.dart';
import '../../../utils/firebase_utils.dart';
import '../../widgets/action_button.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loading_bar.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/social_button.dart';
import '../../../shared/color.dart';
import '../../../shared/font.dart';
import '../../../shared/size.dart';
import '../../../ui/screens/auth/login_screen.dart';
import '../wrapper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  bool isLogining = false;
  bool isGooglePressed = false;
  bool isFacebookPressed = false;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          color: whitePure,
          padding: EdgeInsets.only(
            top: 50.r + ScreenUtil().statusBarHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// WIDGET: APP LOGO
              Padding(
                padding: EdgeInsets.fromLTRB(
                  defaultMargin,
                  8.r,
                  defaultMargin,
                  18.r,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logounej.png', height: 35.sp),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 70.r,
                ),
                child: Image(
                  width: 125.r,
                  height: 105.r,
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/splash.png"),
                ),
              ),

              /// SECTION: LOGIN FORM
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin,
                    vertical: 36.r,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// WIDGET: CUSTOM TEXT FIELD
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            topRight: Radius.circular(4.r),
                          ),
                          child: InputField(
                            controller: emailController,
                            hintText: "Email Address",
                            keyboardType: TextInputType.emailAddress,
                            borderRadius: 0,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email tidak boleh kosong";
                              } else if (!EmailValidator.validate(value)) {
                                return "Format email tidak valid";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        /// WIDGET: CUSTOM TEXT FIELD
                        InputField(
                          controller: nameController,
                          hintText: "Nama lengkap",
                          keyboardType: TextInputType.phone,
                          borderRadius: 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nama tidak boleh kosong";
                            } else if (value.length < 3) {
                              return "Nama tidak boleh kurang dari 3 karakter";
                            }
                          },
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        /// WIDGET: CUSTOM TEXT FIELD
                        InputField(
                          obscureText: true,
                          controller: passwordController,
                          hintText: "Password",
                          keyboardType: TextInputType.text,
                          borderRadius: 0,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                          },
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        /// WIDGET: CUSTOM TEXT FIELD
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4.r),
                            bottomRight: Radius.circular(4.r),
                          ),
                          child: InputField(
                            obscureText: true,
                            controller: rePasswordController,
                            hintText: "Re-Password",
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            borderRadius: 0,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return "Ketikkan ulang password anda";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),

                        /// WIDGET: CUSTOM MATERIAL BUTTON
                        if (isLogining)
                          LoadingBar()
                        else
                          ActionButton(
                            text: "SIGN UP",
                            textColor: whitePure,
                            color: lightGreen,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                signUpPressed();
                              }
                            },
                          ),
                        SizedBox(
                          height: 20.h,
                        ),

                        /// WIDGET: FORGOT PASSWORD LINK
                        Text(
                          "OR",
                          style: boldCalibriFont.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                        /// WIDGET: SOCIAL BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isGooglePressed)
                              SizedBox(
                                width: 140.r,
                                child: Center(
                                  child: LoadingBar(),
                                ),
                              )
                            else
                              SocialButton(
                                image: "assets/images/logo_google.png",
                                color: whitePure,
                                onPressed: () {
                                  setState(() {
                                    isGooglePressed = true;
                                  });
                                  googlePressed();
                                  // onGooglePressed(context);
                                },
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 24.h,
                        ),

                        /// WIDGET: LOGIN ACTION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already Have Account ? ",
                              style: regularCalibriFont.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                              },
                              child: Text(
                                "Login",
                                style: regularCalibriFont.copyWith(
                                  fontSize: 14.sp,
                                  color: lightGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUpPressed() async {
    setState(() {
      isLogining = true;
    });
    String email = emailController.text;
    String name = nameController.text;
    String password = passwordController.text;
    CustomSnackbar.buildSnackbar(
      context,
      "Sedang membuat akun..",
      1,
    );
    try {
      // implement firestore logic
      await FirebaseUtils.setupUser(email, password, name);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Wrapper(),
      ));
    } on FirebaseAuthException catch (e) {
      CustomSnackbar.buildSnackbar(
        context,
        "Terjadi kesalahan: ${generateAuthMessage(e.code)}",
        0,
      );

      setState(() {
        isLogining = false;
      });
    }
  }

  void googlePressed() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    await FirebaseUtils.setupUserForGoogle();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Wrapper(),
    ));
  }
}
