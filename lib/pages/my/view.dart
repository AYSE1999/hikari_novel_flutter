import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikari_novel_flutter/common/constants.dart';
import 'package:hikari_novel_flutter/common/util.dart';
import 'package:hikari_novel_flutter/network/request.dart';
import 'package:hikari_novel_flutter/pages/my/controller.dart';
import 'package:hikari_novel_flutter/router/app_sub_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/api.dart';
import '../../service/local_storage_service.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});

  final controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildUserInfoCard(context),
            const SizedBox(height: 20),
            ListTile(title: Text("browsing_history".tr), leading: const Icon(Icons.history), onTap: AppSubRouter.toBrowsingHistory),
            ListTile(title: Text("check_update".tr), leading: const Icon(Icons.update), onTap: _checkUpdate),
            ListTile(title: Text("setting".tr), leading: const Icon(Icons.settings_outlined), onTap: AppSubRouter.toSetting),
            ListTile(title: Text("about".tr), leading: const Icon(Icons.info_outline), onTap: AppSubRouter.toAbout),
            ListTile(title: Text("logout".tr), leading: const Icon(Icons.logout), onTap: controller.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardBorderRadius)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => {AppSubRouter.toUserInfo()},
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: controller.userInfo.value == null
                    ? const CircleAvatar()
                    : CircleAvatar(backgroundImage: CachedNetworkImageProvider(controller.userInfo.value!.avatar, headers: Request.userAgent)),
              ),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                controller.userInfo.value?.username ?? "",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: FilledButton(
                onPressed: () {
                  controller.usernameController.text = LocalStorageService.instance.getUsername() ?? "";
                  controller.passwordController.text = LocalStorageService.instance.getPassword() ?? "";
                  Get.dialog(
                    AlertDialog(
                      title: Text("check_in".tr),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("check_in_tip".tr),
                          const SizedBox(height: 10),
                          TextField(
                            controller: controller.usernameController,
                            decoration: InputDecoration(labelText: "用户名", border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: controller.passwordController,
                            decoration: InputDecoration(labelText: "密码", border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: Get.back, child: Text("cancel".tr)),
                        TextButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(await controller.sign())));
                            Get.back();
                          },
                          child: Text("confirm".tr),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("check_in".tr),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void _checkUpdate() async {
    final dynamic result = await Util.isLatestVersionAvail();
    if (result is bool) {
      var actions = result
          ? [
              TextButton(onPressed: () => launchUrl(Uri.parse(Api.latestUrl)), child: Text("go_to_update".tr)),
              TextButton(onPressed: Get.back, child: Text("confirm".tr)),
            ]
          : [TextButton(onPressed: Get.back, child: Text("confirm".tr))];
      Get.dialog(
        AlertDialog(title: Text("check_update".tr), content: Text(result ? "new_version_available".tr : "no_new_version_available".tr), actions: actions),
      );
    } else if (result is String) {
      Get.dialog(
        AlertDialog(
          title: Text("check_update".tr),
          content: Text(result.toString()),
          actions: [TextButton(onPressed: Get.back, child: Text("confirm".tr))],
        ),
      );
    }
  }
}
