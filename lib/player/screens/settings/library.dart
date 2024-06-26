import 'package:music_app/player/global_variables.dart';
import 'package:music_app/player/utilities/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:remix_icon_icons/remix_icon_icons.dart';
import 'package:music_app/player/ui/elements/ui_elements.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:music_app/player/utilities/folder_picker.dart';

class Library extends StatefulWidget {
  const Library({
    super.key,
  });

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<String> directoryList = [];

  clearDirectoryList() {
    setState(() {
      directoryList = [];
    });
  }

  selectRootDirectory() async {
    directoryList = [];
    final List<Directory>? rootList = await getExternalStorageDirectories();
    if (rootList != null) {
      for (Directory place in rootList) {
        directoryList.add(place.path.split("Android")[0]);
      }
      setState(() {});
    }
  }

  directoryAdd(String path) async {
    Directory? newPath = await pickFolder(path, context);
    if (newPath != null) {
      specificPathsToQuery.add(newPath.path);
      await updateDirectories();
      setState(() {});
    }
  }

  directoryRemove(index) async {
    specificPathsToQuery.removeAt(index);
    await updateDirectories();
    setState(() {});
  }

  fullRescan() async {
    dataIsInitialized = false;
    await antiiqStore.put("dataInit", false);
    Restart.restartApp();
  }

  rescan() async {
    Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 2,
          surfaceTintColor: Colors.transparent,
          shadowColor: Theme.of(context).colorScheme.onBackground,
          leading: IconButton(
            iconSize: 50,
            color: Theme.of(context).colorScheme.onBackground,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(RemixIcon.arrow_left),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                RemixIcon.folder,
                color: Theme.of(context).colorScheme.onBackground,
                size: 30,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Library",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  style: ButtonStyles().style3,
                  function: () {
                    rescan();
                  },
                  child: const Text("Re-Scan Library"),
                ),
                CustomButton(
                  style: ButtonStyles().style2,
                  function: () {
                    fullRescan();
                  },
                  child: const Text("!Full Re-Scan!"),
                ),
                /*CustomCard(
                  theme: CardThemes().surfaceColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("Auto-Update Library"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            value: runtimeAutoScanEnabled,
                            onChanged: (value) => setState(() {
                              switchRuntimeAutoScanEnabled(value);
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Interval: ${runtimeAutoScanInterval.inMinutes} minutes"),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                          child: FlutterSlider(
                              selectByTap: true,
                              tooltip: FlutterSliderTooltip(
                                disabled: true,
                              ),
                              handlerHeight: 20,
                              handlerWidth: 5,
                              step: const FlutterSliderStep(
                                  step: 1, isPercentRange: false),
                              values: [runtimeAutoScanInterval.inMinutes.toDouble()],
                              min: 1,
                              max: 10,
                              handler: FlutterSliderHandler(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(),
                              ),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1)),
                              trackBar: FlutterSliderTrackBar(
                                inactiveTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border.all(
                                    width: 3,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                activeTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onDragging: (handlerIndex, lowerValue,
                                      upperValue) =>
                                  {
                                    setState(() {
                                      changeRuntimeAutoScanInterval(lowerValue.round());
                                    })
                                  }),
                        ),
                      ],
                    ),
                  ),
                ),*/
                CustomCard(
                  theme: CardThemes().surfaceColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            "Minimum Track Length: $minimumTrackLength seconds"),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                          child: FlutterSlider(
                              selectByTap: true,
                              tooltip: FlutterSliderTooltip(
                                disabled: true,
                              ),
                              handlerHeight: 20,
                              handlerWidth: 5,
                              step: const FlutterSliderStep(
                                  step: 1, isPercentRange: false),
                              values: [minimumTrackLength.toDouble()],
                              min: 5,
                              max: 120,
                              handler: FlutterSliderHandler(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(),
                              ),
                              foregroundDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1)),
                              trackBar: FlutterSliderTrackBar(
                                inactiveTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border.all(
                                    width: 3,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                activeTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              onDragging: (handlerIndex, lowerValue,
                                      upperValue) =>
                                  {
                                    setState(() {
                                      setMinimumTrackLength(lowerValue.round());
                                    })
                                  }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Directories",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomCard(
                  theme: CardThemes().settingsItemTheme.copyWith(
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Note: Adding directories here, excludes all other directories from being scanned.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      CustomButton(
                        style: ButtonStyles().style3,
                        function: () {
                          selectRootDirectory();
                        },
                        child: const Text("Add Directory from Storage"),
                      ),
                      directoryList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Select Storage"),
                                  IconButton(
                                    onPressed: () {
                                      clearDirectoryList();
                                    },
                                    icon: const Icon(
                                      RemixIcon.close_circle,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      for (String path in directoryList)
                        CustomButton(
                          style: ButtonStyles().style3,
                          function: () {
                            directoryAdd(path);
                          },
                          child: Text(path),
                        ),
                      specificPathsToQuery.isNotEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("Paths"),
                            )
                          : Container(),
                      for (String directory in specificPathsToQuery)
                        CustomCard(
                          theme: CardThemes().settingsItemTheme.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: TextScroll(
                                        directory,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  style: ButtonStyles().style1,
                                  function: () {
                                    directoryRemove(specificPathsToQuery
                                        .indexOf(directory));
                                  },
                                  child: const Text("Remove Directory"),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
