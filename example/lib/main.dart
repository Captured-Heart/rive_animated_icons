import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive Animated Icons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  int screenIndex = 2;
  ValueNotifier<MaterialColor> colorNotifier = ValueNotifier(Colors.green);

  List<MaterialColor> iconColors = [Colors.green, Colors.amber, Colors.blue, Colors.red];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Card(
        child: SizedBox(
          height: size.height * 0.085,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ...List.generate(
              4,
              (index) {
                // this method updates the screenIndex
                void onTapIcon() {
                  setState(() {
                    screenIndex = index;
                  });
                  colorNotifier.value = iconColors[index];
                  debugPrint('tapped $index');
                }

                return GestureDetector(
                  // so i don't need to pass this GestureDetector widget to the RiveAnimatedIcon widget
                  onTap: onTapIcon,
                  child: RiveAnimatedIcon(
                    riveIcon: RiveIcon.values[index],
                    width: 50,
                    height: 50,
                    color: iconColors[index],
                    loopAnimation: true,
                    //1.) this is the issue(IT IS NOT REALLY A BUG PER SAY, IT WAS JUST FOR MY USECASE) i encountered while trying to use RiveIcon for bottomnav bar icon,
                    ///2.) I noticed the [RiveAnimatedIcon] is wrapped with an Inkwell, which overrides the onTap property of the GestureDetector used to update the screenIndex
                    ///
                    ///
                    ///3.) To solve this, i had initially passed a null check to the onTap property of the [RiveAnimatedIcon] widget,
                    /*  widget.onTap == null ? null: (){
                       icon.input?.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        icon.input?.change(false);
                      });
                      widget.onTap?.call();
                    }
                    */
                    ///4.) but then it will disable the animation of the icon onPressed [NEW ISSUE]
                    ///5.) Now, i am just updating the screenIndex directly from the icon
                    onTap: onTapIcon,
                  ),
                );
              },
            ).expand(
              (element) => [
                const VerticalDivider(),
                element,
                const VerticalDivider(),
              ],
            ),
          ]),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                children: RiveIcon.values
                    .map((RiveIcon e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ValueListenableBuilder<MaterialColor>(
                                  valueListenable: colorNotifier,
                                  builder: (context, color, _) {
                                    log('what is the color: $color');

                                    //For some reasons,the icon color is not rebuilding except on restart.
                                    //ASIDE THAT I LOVE THE PACKAGE 😍, IT'S VERY SIMPLE TO USE,  AND THE ICONS ARE BEAUTIFUL💜. Jisike 💪🏽
                                    return RiveAnimatedIcon(
                                      riveIcon: e,
                                      width: 50,
                                      height: 50,
                                      loopAnimation: false,
                                      onTap: () {
                                        debugPrint('tapped');
                                      },
                                      onHover: (value) {
                                        debugPrint('value is $value');
                                      },
                                      color: color,
                                    );
                                  }),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: size.height * 0.4,
                width: size.width,
                child: Placeholder(
                  child: Center(
                    child: Text(
                      'Screen ${screenIndex + 1}',
                      style:  TextStyle(
                        color: iconColors[screenIndex],
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
