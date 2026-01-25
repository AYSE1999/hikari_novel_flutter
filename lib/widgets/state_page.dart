import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.msg, required this.onRetry});

  final String msg;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "error".tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), child: Text(msg)),
          onRetry == null ? Container() : FilledButton.icon(onPressed: onRetry, icon: Icon(Icons.refresh), label: Text("retry".tr)),
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/logo_transparent.png",
        width: 150,
        height: 150,
      ),
    );
  }
}

class PleaseSelectPage extends StatelessWidget {
  const PleaseSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.web_traffic, size: 48),
          SizedBox(height: 16),
          Text("please_select_type".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class EmptyPage extends StatelessWidget {
  final Function()? onRefresh;

  const EmptyPage({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, size: 48),
          SizedBox(height: 16),
          Text("empty_content".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          onRefresh != null ? TextButton.icon(onPressed: onRefresh, icon: Icon(Icons.refresh), label: Text("refresh".tr)) : SizedBox(),
        ],
      ),
    );
  }
}
