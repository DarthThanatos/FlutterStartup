import 'package:inject/inject.dart';

import '../main.dart';
import 'main_app.inject.dart' as g;
import 'module/chopper_module.dart';


// if changed, run the following in the console:
// flutter packages pub run build_runner build/watch --delete-conflicting-outputs
@Injector(const [ChopperModule])
abstract class Main{
  @provide
  MyApp get app;

  static Future<Main> create(ChopperModule chopperModule) async {
    return await g.Main$Injector.create(
      chopperModule
    );
  }
}