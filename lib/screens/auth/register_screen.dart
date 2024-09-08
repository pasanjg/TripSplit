import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../common/helpers/ui_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState>? _registerFormKey;
  OverlayEntry? _loader;

  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loader = UIHelper.overlayLoader(context);
    _registerFormKey = GlobalKey<FormState>();
  }

  void registerUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_registerFormKey!.currentState!.validate()) {
      _registerFormKey!.currentState!.save();
      Overlay.of(context).insert(_loader!);

      Navigator.pop(context);
      _loader!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'auth-banner',
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 40.0),
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: RichText(
                text: const TextSpan(
                  text: "Create your account.",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\nSubmit your details to create a new account.',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
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
                            TextSpan(
                              text: '\n& enjoy all the features.',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (input) => {},
                        validator: (input) => input!.isEmpty
                            ? "First name cannot be empty"
                            : null,
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
                        onSaved: (input) => {},
                        validator: (input) =>
                            input!.isEmpty ? "Last name cannot be empty" : null,
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
                        onSaved: (input) => {},
                        validator: (input) => !input!.contains('@')
                            ? "Should be a valid Email"
                            : null,
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
                        controller: _password,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (input) => {},
                        validator: (input) => input!.length < 8
                            ? "Password cannot be less than 8 characters"
                            : null,
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
                        validator: (input) => input != _password.text
                            ? "Should match the given password"
                            : null,
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
        ],
      ),
    );
  }
}
