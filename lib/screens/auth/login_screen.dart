import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/extensions/extensions.dart';
import '../../mixins/validate_mixin.dart';
import '../../widgets/connectivity_indicator.dart';
import '../../common/helpers/ui_helper.dart';
import '../../common/constants/constants.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import '../../widgets/custom/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidateMixin {
  GlobalKey<FormState>? loginFormKey;
  OverlayEntry? loader;

  String? email, password;

  @override
  void initState() {
    super.initState();
    loader = UIHelper.overlayLoader(context);
    loginFormKey = GlobalKey<FormState>();
  }

  void loginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      Overlay.of(context).insert(loader!);

      final userModel = Provider.of<UserModel>(context, listen: false);
      await userModel.login(email: email!, password: password!);

      if (!context.mounted) return;

      if (userModel.errorMessage != null) {
        UIHelper.of(context).showSnackBar(userModel.errorMessage!, error: true);
      } else {
        final tripModel = Provider.of<TripModel>(context, listen: false);
        await tripModel.getUserTrips();

        Navigator.of(context).pushReplacementNamed(RouteNames.home);
      }

      loader!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account.'),
        titleTextStyle: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Choose a sign in method to access your account.',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).primaryColor.contrastColor(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 30.0,
                ),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'Welcome back! ',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "\nLet's get you signed in",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      CustomTextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => email = input,
                        validator: validateEmail,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "Email",
                          hintText: 'johndoe@gmail.com',
                          prefixIcon: Icon(
                            Icons.alternate_email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      CustomTextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (input) => password = input,
                        validator: validatePassword,
                        isPassword: true,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "Password",
                          hintText: '••••••••••••',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      CustomButton(
                        onTap: () {
                          loginUser(context);
                        },
                        text: 'Login',
                      ),
                      // TODO: Add social login buttons
                      // const SizedBox(height: 20.0),
                      // const Text('or continue with'),
                      // const SizedBox(height: 20.0),
                      const SizedBox(height: 15.0),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.register);
                        },
                        child: Text(
                          "I don't have an account",
                          style: TextStyle(
                            fontSize: 15.0,
                            height: 2.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const ConnectivityIndicator(),
        ],
      ),
    );
  }
}
