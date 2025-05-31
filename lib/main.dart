import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wolt Modal Sheet Issue',
      scrollBehavior: DragScrollBehavior(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wolt Modal Sheet Issue')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open test sheet'),
          onPressed: () {
            WoltModalSheet.show<void>(
              context: context,
              pageListBuilder: (modalSheetContext) {
                return [
                  _buildPage1(modalSheetContext),
                  // _buildPage2(modalSheetContext),
                ];
              },
              modalTypeBuilder: (context) {
                return WoltBottomSheetType();
              },
              onModalDismissedWithDrag: () {
                debugPrint('Bottom sheet is dismissed with drag.');
                Navigator.of(context).pop();
              },
              onModalDismissedWithBarrierTap: () {
                debugPrint('Modal is dismissed with barrier tap.');
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }

  SliverWoltModalSheetPage _buildPage1(BuildContext sheetContext) {
    final WoltModalSheetPage page = WoltModalSheetPage(
      // resizeToAvoidBottomInset: false,
      hasSabGradient: false, // Remove default gradient overlay
      topBarTitle: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Page1 - Demo of scroll issue ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      isTopBarLayerAlwaysVisible: true, // Keep title visible when scrolling
      // Main content is the scrollable list
      child: Builder(
        builder: (context) {
          final bool noKeyboardShown =
              MediaQuery.viewInsetsOf(context).bottom == 0;
          return Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    WoltModalSheet.of(
                      sheetContext,
                    ).addPage(_buildPage2(sheetContext));

                    WoltModalSheet.of(context).showNext();
                  },
                  child: Text('Next sheet'),
                ),
                SizedBox(height: 20),
                if (noKeyboardShown)
                  FilledButton(onPressed: () {}, child: Text('Dummy button')),
                if (noKeyboardShown) SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Input',
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );

    return page;
  }

  SliverWoltModalSheetPage _buildPage2(BuildContext context) {
    final WoltModalSheetPage page = WoltModalSheetPage(
      hasSabGradient: false,
      leadingNavBarWidget: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // WoltModalSheet.of(context).showPrevious();
          WoltModalSheet.of(context).popPage();
        },
      ),
      topBarTitle: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Page2 - Demo of scroll issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      isTopBarLayerAlwaysVisible: true, // Keep title visible when scrolling
      // Main content is the scrollable list
      child: Builder(
        builder: (context) {
          final bool noKeyboardShown =
              MediaQuery.viewInsetsOf(context).bottom == 0;
          return Column(
            children: [
              SizedBox(height: 20),
              if (noKeyboardShown)
                FilledButton(onPressed: () {}, child: Text('Dummy button')),
              if (noKeyboardShown) SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Input',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 50,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Scrolling content ${index + 1}'),
                    leading: CircleAvatar(child: Text('${index + 1}')),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    return page;
  }
}

// Define a custom scroll behavior that enables mouse dragging
class DragScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.mouse,
  };
}
