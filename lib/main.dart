import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trash_induc/repository/account_repository.dart';
import 'package:trash_induc/repository/admin_drawer_repository.dart';
import 'package:trash_induc/repository/mission_repository.dart';
import 'package:trash_induc/repository/transaction_repository.dart';
import 'package:trash_induc/ui/screens/wrapper.dart';
import 'package:trash_induc/utils/firebase_utils.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: FirebaseUtils.userStream,
          initialData: '',
        ),
        ChangeNotifierProvider(
          create: (_) => AdminDrawerRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => MissionRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountRepository(),
        ),
      ],
      child: ScreenUtilInit(
        child: const Wrapper(),
        // designSize: const Size(
        //   360,
        //   640,
        // ),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trash Induc',
          home: child,
        ),
      ),
    );
  }
}
