import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/bookshelf/controller.dart';
import '../widgets/bottom_action_bar.dart';

//公共widget
class Widgets {
  static Widget bookshelfBottomActionBar(BookshelfContentController currentTabController, BookshelfController bookshelfController, {bool edgeToEdge = false}) {
    return BottomActionBar(
      edgeToEdge: edgeToEdge,
      items: [
        BottomActionItem(
          icon: Icons.drive_file_move_outlined,
          label: "move_to_other_bookshelf".tr,
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: Text("move_to_other_bookshelf".tr),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    6,
                    (i) => ListTile(
                      onTap: () async {
                        await currentTabController.moveNovelToOther(i);
                        currentTabController.exitSelectionMode();
                        Get.back(); //关闭dialog
                        await bookshelfController.refreshBookshelf();
                      },
                      title: Text("bookshelf_number_selection".trParams({"no": i.toString()})),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        BottomActionItem(
          icon: Icons.delete_outline_outlined,
          label: "remove_from_bookshelf".tr,
          onTap: () async {
            await currentTabController.removeNovelFromList();
            currentTabController.exitSelectionMode();
            await bookshelfController.refreshBookshelf();
          },
        ),
      ],
    );
  }
}
