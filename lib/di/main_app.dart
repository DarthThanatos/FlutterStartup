import 'package:flutter_app/chat/chat_page.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer.dart';
import 'package:inject/inject.dart';

import '../main.dart';
import 'main_app.inject.dart' as g;
import 'module/chopper_module.dart';
import 'module/presenters_module.dart';


// if changed, run the following in the console:
// flutter packages pub run build_runner build/watch --delete-conflicting-outputs

@Injector(const [ChopperModule, PresentersModule])
abstract class Main{

  @provide
  MyApp get app;

  @provide
  ChatPage get chatPage;

  @provide
  FileViewer get fileViewer;

  @provide
  FilePickerDemo get filePickerDemo;

  static Future<Main> create(ChopperModule chopperModule, PresentersModule presentersModule) async {
    return await g.Main$Injector.create(
      chopperModule,
      presentersModule
    );
  }
}



class MainContainer{
  static Main container;
}