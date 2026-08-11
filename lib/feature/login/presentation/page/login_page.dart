import 'package:builder_customer/core/localization/context_ext.dart';
import 'package:custom_ui/custom_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../../../../core/injector/injector_conf.dart';
import '../../../../core/config/flavor_config.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<LoginBloc>(),
        child: Builder(
          builder: (context) {
            // Now context is under BlocProvider
            return BlocListener<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccess) {
              // assuming your model/entity has toJson()
                  if (mounted) {
                    if (state is LoginSuccess) {
      if (!mounted) return;
      // Navigate using GoRouter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/dashboard'); // use go() instead of pushReplacement
      });
    }
                  }
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
                else if(state is LoginLoading){
                  CircularProgressIndicator();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

Image.asset(FlavorConfig.appConfig.logo,height: 250,width: 250,),


// Image.asset(FlavorConfig.appConfig.appNameImg,height: 56,width: 250,),
// SizedBox(height: 56,),

Container(padding: const EdgeInsets.only(left: 10),alignment: Alignment.centerLeft,child: Text(context.l10n?.login ?? 'Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
const SizedBox(height: 4,),
CustomTextField(
  hint:  context.l10n?.mobileNumber ?? 'Mobile Number',
  style: TextFieldStyle.outlined,
  controller: mobileController,
  keyboardType: TextInputType.phone,
  maxLength: 10,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number cannot be empty';
    }
    if (value.length != 10) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
),


SizedBox(height: 20,),
CustomButton(
  text:   context.l10n?.submit ?? 'Submit',
  type: ButtonType.elevated,
  icon: Icon(Icons.arrow_forward, color: Colors.white),
  iconPosition: IconPosition.suffix,
  onPressed: () {

     if (_formKey.currentState!.validate()) {
                            context
                                .read<LoginBloc>()
                                .add(LoginWithMobile(mobileController.text));
                          }
  },
),



                      // TextFormField(
                      //   controller: mobileController,
                      //   keyboardType: TextInputType.phone,
                      //   maxLength: 10,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Mobile Number',
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.length != 10) {
                      //       return 'Enter a valid 10-digit mobile number';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       context
                      //           .read<LoginBloc>()
                      //           .add(LoginWithMobile(mobileController.text));
                      //     }
                      //   },
                      //   child: const Text('Submit'),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
