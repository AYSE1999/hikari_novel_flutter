import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikari_novel_flutter/models/resource.dart';
import 'package:hikari_novel_flutter/models/user_info.dart';
import 'package:hikari_novel_flutter/router/route_path.dart';

import '../../network/api.dart';
import '../../service/local_storage_service.dart';

class MyController extends GetxController {
  Rxn<UserInfo> userInfo = Rxn(LocalStorageService.instance.getUserInfo());

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<String> sign() async {
    final loginResult = await Api.loginAppWenku8(username: usernameController.text, password: passwordController.text);
    switch (loginResult) {
      case Success():
        {
          final signResult = await Api.sign();
          switch (signResult) {
            case Success():
              {
                final isSignSuccess = _validSign(signResult.data);
                if (isSignSuccess.isNotEmpty) {
                  LocalStorageService.instance.setUsername(usernameController.text);
                  LocalStorageService.instance.setPassword(passwordController.text);
                  return "签到成功！当前积分：${isSignSuccess[0]}，经验值：${isSignSuccess[1]}";
                }
                switch (signResult.data) {
                  case "2":
                    return "用户名错误";
                  case "3":
                    return "密码错误";
                  case "9":
                    return "签到失败，你已经签到过了";
                  default:
                    return "签到失败 code:${signResult.data}";
                }
              }
            case Error():
              return "签到失败";
          }
        }
      case Error():
        return "签到失败";
    }
  }

  //提取数字
  List<String> _validSign(String xml) {
    // <?xml version="1.0" encoding="utf-8"?>
    // <metadata>
    // <item name="score">702</item>
    // <item name="experience">702</item>
    // </metadata>

    try {
      final nameRegex = RegExp(r'(?<=<item name=")[^"]+(?=">)'); //先提取name属性值
      final names = nameRegex.allMatches(xml).map((m) => m.group(0)!).toList(); //[score, experience]
      if (names[0] == "score" && names[1] == "experience") {
        final numberRegex = RegExp(r'(?<=<item[^>]*>)(\d+)(?=</item>)');
        final numberMatches = numberRegex.allMatches(xml).map((m) => m.group(1)!).toList();

        if (numberMatches.isNotEmpty) {
          return numberMatches;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void logout() {
    LocalStorageService.instance.setCookie(null);
    Get.offAndToNamed(RoutePath.welcome);
  }
}
