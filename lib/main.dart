import 'package:MedBuzz/core/constants/route_generator.dart';
import 'package:MedBuzz/core/constants/route_names.dart';
import 'package:MedBuzz/core/models/diet_reminder/diet_reminder.dart';
import 'package:MedBuzz/core/models/fitness_reminder_model/fitness_reminder.dart';
import 'package:MedBuzz/core/models/medication_reminder_model/medication_reminder.dart';
import 'package:MedBuzz/core/models/appointment_reminder_model/appointment_reminder.dart';
import 'package:MedBuzz/core/models/notification_model/notification_model.dart';
import 'package:MedBuzz/core/models/user_model/user_model.dart';
import 'package:MedBuzz/core/models/water_reminder_model/water_drank.dart';
import 'package:MedBuzz/core/notifications/fitness_notification_manager.dart';
import 'package:MedBuzz/core/providers/providers.dart';
import 'package:MedBuzz/ui/darkmode/dark_mode_model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/models/medication_history_model/medication_history.dart';
import 'core/models/water_reminder_model/water_reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  timeDilation = 1.0;
  Hive.registerAdapter(WaterReminderAdapter());
  Hive.registerAdapter(MedicationReminderAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(DietModelAdapter());
  Hive.registerAdapter(FitnessReminderAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(WaterDrankAdapter());
  Hive.registerAdapter(MedicationHistoryAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  await Hive.openBox('onboarding');
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: providers, child: MaterialAPP());
  }
}

class MaterialAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print(reminderSound);
    return FeatureDiscovery(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'MedBuzz',
        theme: Provider.of<DarkModeModel>(context).appTheme,
//        initialRoute: RouteNames.splashScreen,
        initialRoute: RouteNames.splashScreen,
        //Routes now need to be named in the RoutesName class and returned from the generatedRoute function
        //in the RouteGenerator class
        //This update handles page transitions
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
