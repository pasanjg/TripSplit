import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/extensions.dart';
import '../../mixins/validate_mixin.dart';
import '../../models/user_model.dart';
import '../../widgets/connectivity_indicator.dart';
import '../../common/helpers/ui_helper.dart';
import '../../widgets/custom/index.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidateMixin {
  GlobalKey<FormState>? _registerFormKey;
  OverlayEntry? _loader;

  String? firstname, lastname, email, password, confirmPassword;

  @override
  void initState() {
    super.initState();
    _loader = UIHelper.overlayLoader(context);
    _registerFormKey = GlobalKey<FormState>();
  }

  Future<void> registerUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_registerFormKey!.currentState!.validate()) {
      _registerFormKey!.currentState!.save();
      Overlay.of(context).insert(_loader!);

      final userModel = Provider.of<UserModel>(context, listen: false);
      await userModel.createUser(
        firstname: firstname!,
        lastname: lastname!,
        email: email!,
        password: password!,
      );

      if (!context.mounted) return;

      if (userModel.errorMessage != null) {
        UIHelper.of(context).showSnackBar(userModel.errorMessage!, error: true);
      } else if (userModel.successMessage != null) {
        UIHelper.of(context).showSnackBar(userModel.successMessage!);
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.home,
          (route) => false,
        );
      }

      _loader!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create your account'),
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
              "Submit your details to create a new account",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
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
                  key: _registerFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: "Let's get started",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          children: <TextSpan>[
                            // TextSpan(
                            //   text: '\n& enjoy all the features.',
                            //   style: TextStyle(
                            //     fontSize: 14.0,
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (input) => firstname = input,
                        validator: validateText,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "First name",
                          hintText: 'John',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (input) => lastname = input,
                        validator: validateText,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "Last name",
                          hintText: 'Doe',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (input) => password = input,
                        onChanged: (input) => password = input,
                        validator: validatePassword,
                        isPassword: true,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "Password",
                          hintText: '••••••••••••',
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
                        validator: (input) =>
                            validateConfirmPassword(password, input),
                        isPassword: true,
                        decoration: CustomTextFormField.buildDecoration(context)
                            .copyWith(
                          labelText: "Confirm password",
                          hintText: '••••••••••••',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      CustomButton(
                        onTap: () {
                          registerUser(context);
                        },
                        text: 'Register',
                      ),
                      const SizedBox(height: 30.0),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "I already have an account",
                          style: TextStyle(
                            fontSize: 15.0,
                            height: 0.1,
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
