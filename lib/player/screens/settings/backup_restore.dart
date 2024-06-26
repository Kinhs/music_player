import 'package:music_app/player/utilities/file_handling/backup_and_restore.dart';
import 'package:flutter/material.dart';
import 'package:remix_icon_icons/remix_icon_icons.dart';
import 'package:music_app/player/ui/elements/ui_elements.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:music_app/player/utilities/folder_picker.dart';

class BackupRestore extends StatefulWidget {
  const BackupRestore({
    super.key,
  });

  @override
  State<BackupRestore> createState() => _BackupRestoreState();
}

class _BackupRestoreState extends State<BackupRestore> {
  

  showBackUpRestoreDirectoryList() async {
    backupRestoreDirectoryList = [];
    final List<Directory>? rootList = await getExternalStorageDirectories();
    if (rootList != null) {
      for (Directory place in rootList) {
        backupRestoreDirectoryList.add(place.path.split("Android")[0]);
      }
      setState(() {});
    }
  }

  clearBackupRestoreDirectoryList() {
    setState(() {
      backupRestoreDirectoryList = [];
    });
  }

  selectBackupRestorePath(String path) async {
    Directory? newPath = await pickFolder(path, context);
    if (newPath != null) {
      backupRestorePath = newPath.path;
      setState(() {});
    }
  }

  String backupRestorePath = "";
  List<String> backupRestoreDirectoryList = [];

 

  backupOrRestore(bool toBackUp) async {
    bool popDialog = false;
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return popDialog;
          },
          child: Dialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please wait..."),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomInfiniteProgressIndicator(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (backupRestorePath != "") {
      if (toBackUp) {
        await backup(backupRestorePath);
      } else if (!toBackUp) {
        await restore(backupRestorePath);
      }
    }
    if (mounted) {
      popDialog = true;
      setState(() {
        backupRestorePath = "";
        backupRestoreDirectoryList = [];
      });

      Navigator.of(context).pop();
    } else {
      return;
    }
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
                RemixIcon.save_3,
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
                    "Backup/Restore",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                ),
                backupRestorePath == ""
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomButton(
                                style: ButtonStyles().style1,
                                function: () {
                                  showBackUpRestoreDirectoryList();
                                },
                                child: const Text(
                                    "Select Directory for Backup/Restore"),
                              ),
                            ),
                            backupRestoreDirectoryList.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Select Storage"),
                                        IconButton(
                                          onPressed: () {
                                            clearBackupRestoreDirectoryList();
                                          },
                                          icon: const Icon(
                                            RemixIcon.close_circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            for (String path in backupRestoreDirectoryList)
                              CustomButton(
                                style: ButtonStyles().style3,
                                function: () {
                                  selectBackupRestorePath(path);
                                },
                                child: Text(path),
                              ),
                          ],
                        ),
                      )
                    : Container(),
                backupRestorePath != ""
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomCard(
                          theme: CardThemes().surfaceColor,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text("Select Action"),
                                ),
                                CustomButton(
                                  style: ButtonStyles().style3,
                                  function: () {
                                    backupOrRestore(true);
                                  },
                                  child: const Text("Backup"),
                                ),
                                CustomButton(
                                  style: ButtonStyles().style1,
                                  function: () {
                                    backupOrRestore(false);
                                  },
                                  child: const Text("Restore"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
