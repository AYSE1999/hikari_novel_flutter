import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikari_novel_flutter/base/base_list_page_controller.dart';
import 'package:hikari_novel_flutter/models/reply_item.dart';

import '../../models/page_state.dart';
import '../../models/resource.dart';
import '../../network/api.dart';
import '../../network/parser.dart';

class ReplyController extends BaseListPageController<ReplyItem> {
  final String aid;
  final String rid;

  ReplyController({required this.aid, required this.rid});

  final replyContentController = TextEditingController();

  @override
  Rx<PageState> pageState = Rx(PageState.loading);

  @override
  Future<Resource> getData(int index) => Api.getReply(rid: rid, index: index);

  @override
  List<ReplyItem> getParser(String html) => Parser.getReply(html);

  Future<String> sendReply() async {
    if (replyContentController.text.length < 7) {
      return "word_number_too_low_tip".tr;
    }

    final result = await Api.sendReply(aid: aid, rid: rid, content: replyContentController.text);
    replyContentController.clear();
    switch (result) {
      case Success():
        {
          if (Parser.isError(result.data)) {
            return "reply_failed".tr;
          } else {
            return "reply_successfully".tr;
          }
        }
      case Error():
        {
          return "network_error".tr;
        }
    }
  }


}