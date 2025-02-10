import 'package:forui/forui.dart';

import 'main.dart';

export '../dashboard/dashboard.dart';
export 'dart:convert';
export 'dart:developer' hide Flow;
export 'dart:io';
export 'package:colornames/colornames.dart';
export 'package:file_picker/file_picker.dart';
export 'package:flutter/foundation.dart';
export 'package:freezed_annotation/freezed_annotation.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:manager/manager.dart';
export 'package:money/persons/person.dart';
export 'package:money/persons/person_page.dart';
export 'package:money/persons/persons_page.dart';
export 'package:money/settings/settings.dart';
export 'package:money/settings/settings_page.dart';
export 'package:money/transactions/transaction.dart';
export 'package:money/transactions/transaction_page.dart';
export 'package:money/transactions/transactions.dart';
export 'package:money/transactions/transactions_page.dart';
export 'package:states_rebuilder/states_rebuilder.dart';
export 'package:uuid/uuid.dart';

void main() async {
  try {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    // final appInfo = await PackageInfo.fromPlatform();
    await RM.storageInitializer(HiveStorage());
    // store = await openStore(
    //   directory: join(
    //     (await getApplicationDocumentsDirectory()).path,
    //     appInfo.appName,
    //   ),
    // );
    // GoogleFonts.config.allowRuntimeFetching = false;

    runApp(App());
  } catch (e) {
    runApp(
      MaterialApp(
        home: e.text(),
      ),
    );
  }
}

class App extends UI {
  const App({super.key});

  @override
  void didMountWidget(BuildContext context) {
    super.didMountWidget(context);
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(context) {
    return MaterialApp(
        navigatorKey: navigator.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Application(),
        themeMode: themeMode(),
        builder: (context, child) {
          return FTheme(
            data: FThemes.yellow.light,
            child: child!,
          );
        }
        // theme: FlexThemeData.light(
        //   fontFamily: fontFamily(font()),
        //   colorScheme: ColorScheme.fromSwatch(
        //     primarySwatch: materialColor(),
        //   ),
        //   useMaterial3: useMaterial3(),
        //   appBarStyle: FlexAppBarStyle.primary,
        //   subThemesData: FlexSubThemesData(
        //     defaultRadius: borderRadius(),
        //     inputDecoratorRadius: borderRadius(),
        //     fabRadius: borderRadius(),
        //     elevatedButtonRadius: borderRadius(),
        //     textButtonRadius: borderRadius(),
        //     outlinedButtonRadius: borderRadius(),
        //     toggleButtonsRadius: borderRadius(),
        //     cardRadius: borderRadius(),
        //     popupMenuRadius: borderRadius(),
        //     dialogRadius: borderRadius(),
        //     bottomSheetRadius: borderRadius(),
        //     interactionEffects: true,
        //     blendOnColors: true,
        //   ),
        //   lightIsWhite: true,
        //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // ),
        // darkTheme: FlexThemeData.dark(
        //   fontFamily: fontFamily(font()),
        //   colorScheme: ColorScheme.fromSwatch(
        //     primarySwatch: materialColor(),
        //     brightness: Brightness.dark,
        //   ),
        //   // useMaterial3: useMaterial3(),
        //   // appBarStyle: FlexAppBarStyle.primary,
        //   // subThemesData: FlexSubThemesData(
        //   //   defaultRadius: borderRadius(),
        //   //   inputDecoratorRadius: borderRadius(),
        //   //   fabRadius: borderRadius(),
        //   //   elevatedButtonRadius: borderRadius(),
        //   //   textButtonRadius: borderRadius(),
        //   //   outlinedButtonRadius: borderRadius(),
        //   //   toggleButtonsRadius: borderRadius(),
        //   //   cardRadius: borderRadius(),
        //   //   popupMenuRadius: borderRadius(),
        //   //   dialogRadius: borderRadius(),
        //   //   bottomSheetRadius: borderRadius(),
        //   //   interactionEffects: true,
        //   //   blendOnColors: true,
        //   // ),
        //   darkIsTrueBlack: true,
        //   // visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // ),
        );
  }
}

List<String> get fonts {
  return [
    "Default",
    "Azeret Mono",
    "Comfortaa",
    "DM Mono",
    "Dosis",
    "Fira Sans",
    "IBM Plex Mono",
    "Josefin Sans",
    "Montserrat",
    "Space Mono",
    "Ubuntu",
  ];
}

String? fontFamily(String font) {
  try {
    if (font == 'Default') {
      return null;
    }
    return GoogleFonts.getFont(font).fontFamily;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

final navigator = RM.navigate;
