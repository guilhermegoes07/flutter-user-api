import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:pessoas/core/theme/app_theme.dart';
import 'package:pessoas/features/home/view/home_screen.dart';
import 'package:pessoas/features/home/viewmodel/home_view_model.dart';
import 'package:pessoas/features/persisted/viewmodel/persisted_view_model.dart';
import 'package:pessoas/features/user/repository/datasource/user_api_data_source.dart';
import 'package:pessoas/features/user/repository/datasource/user_local_data_source.dart';
import 'package:pessoas/features/user/repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  HttpOverrides.global = RandomUserHttpOverrides();

  final dio = Dio();
  final apiDataSource = UserApiDataSourceImpl(dio);
  final localDataSource = await UserLocalDataSourceImpl.create();
  final repository = UserRepositoryImpl(
    apiDataSource: apiDataSource,
    localDataSource: localDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: repository),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(repository),
        ),
        ChangeNotifierProvider<PersistedViewModel>(
          create: (_) => PersistedViewModel(repository),
        ),
      ],
      child: const PessoasApp(),
    ),
  );
}

class RandomUserHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) {
      if (host == 'randomuser.me' || host.endsWith('.randomuser.me')) {
        return true;
      }
      return false;
    };
    return client;
  }
}

class PessoasApp extends StatelessWidget {
  const PessoasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pessoas',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
