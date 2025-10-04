import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:test_project/features/products/presentation/controllers/products_controller.dart';
import 'package:test_project/features/products/presentation/views/products_screen.dart';
import 'package:test_project/injections.dart';
import 'package:test_project/utils/app_resources.dart';
import 'package:test_project/utils/close_keyboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<ProductsController>()),
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          title: 'Super Product',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SplashScreen(),
          builder: (context, child) {
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    closeKeyBoard(context);
                  },
                  child: child ?? const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getIt<ProductsController>().init();
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => ProductsScreen()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Image.asset(AppResources.logo, width: 150, height: 150),
      ),
    );
  }
}
