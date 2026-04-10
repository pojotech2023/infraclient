

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:go_router/go_router.dart';
import '../../../../core/cache/local_storage.dart';
import '../../../../core/injector/injector_conf.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/bloc/theme_state.dart';
import '../../../../core/theme/appearance/app_appearance.dart';
import '../../../../core/localization/bloc/locale_bloc.dart';
import '../../../../core/localization/bloc/locale_state.dart';
import '../../../../core/config/flavor_config.dart';
import '../../../login/data/models/customer_model.dart';
import '../../../login/domain/entities/customer_entity.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/routes/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    super.initState();
    loadUser();
  }


loadUser() async {
  final localStorage = getIt<LocalStorage>();
final userMap = await localStorage.load(key: 'user', boxName: 'auth');

CustomerEntity? loggedInUser;
if (userMap != null) {
  try {
    Map<String, dynamic> userJson;
    if (userMap is String) {
      userJson = json.decode(userMap);
    } else {
      userJson = Map<String, dynamic>.from(userMap);
    }
    final customerModel = CustomerModel.fromJson(userJson);
    loggedInUser = customerModel.toEntity();
  } catch (e) {
    print("Error parsing user from local storage: $e");
  }
}

final redirectRoute = loggedInUser != null ? '/dashboard' : '/login';



    Future.delayed(const Duration(milliseconds: 5000), () {
  context.go(redirectRoute);
    });

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset(FlavorConfig.appConfig.logo,width: 250,height: 250,),
            SizedBox(height: 8,),
            // Image.asset(FlavorConfig.appConfig.appNameImg,width: 250,height: 56,),

          ],
        )
      ),
    );
  
    }

}
