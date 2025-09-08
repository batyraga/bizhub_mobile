import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/config/langs/config.dart';
import 'package:bizhub/generated/locale_keys.g.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/palette.dart';
import 'package:bizhub/firebase_options.dart';
import 'package:bizhub/icons/bizhub_icons.dart';
import 'package:bizhub/providers/chat.service.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/providers/notification.service.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:bizhub/screens/child_screens/post_detail.dart';
import 'package:bizhub/screens/child_screens/product_detail.dart';
import 'package:bizhub/screens/sellers.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/login_modal.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/favorites.dart';
import 'package:bizhub/screens/home.dart';
import 'package:bizhub/screens/collections.dart';
import 'package:bizhub/screens/user_profile/main.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await storage.init();
  await api.loadApiAddress();
  await api.init();
  // await notificationService.init();

  final initialDynamicLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Favorites().initState()),
          ChangeNotifierProvider(
            create: (context) => Auth().initState(),
          ),
          ChangeNotifierProvider(
            create: (_) => Language().initState(),
          ),
          ChangeNotifierProxyProvider<Auth, ChatService>(
            create: (_) => ChatService(),
            update: (_, auth, s) => s!.initState(auth),
            lazy: true,
          ),
          ChangeNotifierProvider(
            create: (_) => FilterProduct(),
          ),
          ChangeNotifierProvider(
            create: (context) => MySellerWallet(),
          ),
        ],
        child: EasyLocalization(
            fallbackLocale: fallbackLocale,
            supportedLocales: supportedLocales,
            path: langPath,
            assetLoader: CodegenLoader(),
            child: BizhubRunner(
                child: CustomMaterialApp(
                    child: BizhubFetchErrors(
                        child:
                            MyApp(initialDynamicLink: initialDynamicLink)))))),
  );
}

class CustomMaterialApp extends StatelessWidget {
  final Widget child;
  const CustomMaterialApp({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
            prefixStyle: const TextStyle(
              color: Color.fromRGBO(151, 151, 190, 1),
              fontFamily: "Nunito",
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                    color: primaryColor, width: 1, style: BorderStyle.solid),
                gapPadding: 0),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                    color: primaryColor, width: 1, style: BorderStyle.solid),
                gapPadding: 0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                    color: primaryColor, width: 1, style: BorderStyle.solid),
                gapPadding: 0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                    color: primaryColor, width: 1, style: BorderStyle.solid),
                gapPadding: 0),
          ),
          iconTheme: const IconThemeData(
            shadows: [],
          ),
          primarySwatch: Palette.bizhub,
          shadowColor: Colors.transparent,
          fontFamily: "Nunito",
          scaffoldBackgroundColor: Colors.white,
          primaryColor: primaryColor,
          colorScheme: ColorScheme(
            primary: primaryColor,
            background: Colors.white,
            brightness: Brightness.light,
            error: Colors.red[100]!,
            onBackground: Colors.black,
            onError: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            secondary: secondaryColor,
            surface: Colors.white,
          ),
        ),
        title: "Bizhub app",
        home: child);
  }
}

class MyApp extends StatefulWidget {
  final PendingDynamicLinkData? initialDynamicLink;
  const MyApp({
    super.key,
    this.initialDynamicLink,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class CustomScreen {
  final StatefulWidget screen;
  final String label;
  final IconData icon;
  final String iconFilled;
  final int index;
  const CustomScreen(
      {required this.screen,
      required this.label,
      required this.icon,
      required this.iconFilled,
      required this.index});
}

class _MyAppState extends State<MyApp> {
  final List<CustomScreen> screens = const [
    CustomScreen(
        index: 0,
        screen: HomeScreen(),
        label: LocaleKeys.home,
        icon: BizhubIcons.home // Icons.home
        ,
        iconFilled: "assets/svgs/home_filled.svg"),
    CustomScreen(
        index: 1,
        screen: CollectionsScreen(),
        label: LocaleKeys.collections,
        icon: BizhubIcons.collections // Icons.grid_3x3_outlined,
        ,
        iconFilled: "assets/svgs/collections_filled.svg"),
    CustomScreen(
        index: 2,
        screen: FavoritesScreen(),
        label: LocaleKeys.favorites,
        icon: BizhubIcons.favorite //Icons.favorite_border_outlined
        ,
        iconFilled: "assets/svgs/favorites_filled.svg"),
    CustomScreen(
      index: 3,
      screen: SellersScreen(),
      label: LocaleKeys.sellers,
      icon: BizhubIcons.shop // Icons.house_siding_outlined
      ,
      iconFilled: "assets/svgs/shops_filled.svg",
    ),
    CustomScreen(
      index: 4,
      screen: ProfileScreen(),
      label: LocaleKeys.profile,
      icon: BizhubIcons.user // Icons.person
      ,
      iconFilled: "assets/svgs/profile_filled.svg",
    ),
  ];
  int _currentScreenIndex = 0;

  void changeScreen(int index) {
    if (index == _currentScreenIndex) {
      return;
    }
    setState(() {
      _currentScreenIndex = index;
    });
  }

  void handleMessageFromFirebase(RemoteMessage message) {
    log("[notification] - ${message.senderId} - ${message.notification?.title}");
  }

  @override
  void initState() {
    super.initState();
    notificationService.setupInteractedMessage(handleMessageFromFirebase);
    if (widget.initialDynamicLink != null) {
      onHandleDynamicLink(widget.initialDynamicLink!);
    }
    FirebaseDynamicLinks.instance.onLink.listen(onHandleDynamicLink);

    FlutterNativeSplash.remove();

    globalEvents.on("loginModal", ([data]) async {
      showLoginModal(context);
    });

    globalEvents.on("at-changed", ([data]) async {
      context.read<Auth>().changeAccessToken(data![0] as String);
      context.read<ChatService>().reconnect();
    });

    globalEvents.on("check-connection", ([data]) async {
      BizhubFetchErrors.errorCheck(context);
    });
  }

  void onHandleDynamicLink(PendingDynamicLinkData event) {
    log("[FirebaseDynamicLinks] - uri - ${event.link.toString()}");
    if (event.link.pathSegments[0] != "links") {
      return;
    }
    final String? postId = event.link.queryParameters["postId"];
    if (postId != null) {
      Navigator.push(
          context,
          PageTransition(
              ctx: context,
              type: PageTransitionType.fade,
              child: PostDetailRoutePage(
                postId: postId,
                parentContext: context,
              )));
      return;
    }

    final String? productId = event.link.queryParameters["productId"];
    if (productId != null) {
      Navigator.push(
          context,
          PageTransition(
              ctx: context,
              type: PageTransitionType.fade,
              child: ProductDetailRoutePage(
                id: productId,
                parentContext: context,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentScreenIndex,
        children: screens.map((e) => e.screen).toList(),
      ),
      // start
      bottomNavigationBar: Consumer<Language>(builder: (context, lang, _) {
        return Container(
          height: 60.0,
          decoration: const BoxDecoration(color: Colors.white,
              // border:
              //     Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.15)))
              boxShadow: [
                BoxShadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 2.5,
                  color: Color.fromARGB(255, 224, 224, 224),
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: screens
                .map((e) => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        // splashColor: const Color.fromARGB(255, 246, 246, 246),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (e.index != _currentScreenIndex) {
                            changeScreen(e.index);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (e.index == _currentScreenIndex)
                              SvgPicture.asset(
                                e.iconFilled,
                                fit: BoxFit.fitHeight,
                                // width: 19.25,
                                height: 19.0,
                                alignment: Alignment.centerRight,
                              )
                            else
                              Icon(
                                e.icon,
                                size: 19.0,
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              e.label,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: e.index == _currentScreenIndex
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ).tr()
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        );
        // return CustomNavigationBar(
        //     elevation: 20.0,
        //     currentIndex: _currentScreenIndex,
        //     onTap: changeScreen,
        //     iconSize: 22.0,
        //     selectedColor: secondaryColor,
        //     strokeColor: primaryColor,
        //     unSelectedColor: Colors.black,
        //     items: screens
        //         .map((e) => CustomNavigationBarItem(
        //             icon: Icon(e.icon),
        //             selectedIcon: e.iconFilled,
        //             title: Text(e.label).tr(),
        //             selectedTitle: Text(
        //               e.label,
        //               style: const TextStyle(fontWeight: FontWeight.w600),
        //             ).tr()))
        //         .toList());
      }),
      // end
    );
  }
}
