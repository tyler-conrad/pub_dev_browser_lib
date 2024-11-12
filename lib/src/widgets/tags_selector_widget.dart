import 'package:flutter/material.dart' as m;

import 'package:pub_api_client/pub_api_client.dart' as pac;

import '../text_editing_controller_adapter.dart' as teca;
import 'selectable_outlined_button_widget.dart' as sob;

/// A [m.Wrap]ed list of [sob.SelectableOutlinedButton]s that represent tags,
/// SDKs, platforms, to be used as search filters.
///
/// Uses the [textEditingControllerAdapter] to add or remove tags from the
/// search field.
class TagSelector extends m.StatelessWidget {
  const TagSelector({
    super.key,
    required this.textEditingControllerAdapter,
  });

  final teca.TextEditingControllerAdapter textEditingControllerAdapter;

  sob.SelectableOutlinedButton selectableOutlinedButton({
    required String text,
    required List<String> tags,
    required RegExp regExp,
  }) =>
      sob.selectableOutlinedButton(
        label: text,
        tags: tags,
        regExp: regExp,
        textEditingControllerAdapter: textEditingControllerAdapter,
      );

  @override
  m.Widget build(m.BuildContext context) {
    return m.Wrap(
      alignment: m.WrapAlignment.center,
      children: <m.Widget>[
        selectableOutlinedButton(
          text: 'Flutter Favorite',
          tags: [pac.PackageTag.isFlutterFavorite],
          regExp: RegExp(r'^is:flutter-favorite$'),
        ),
        selectableOutlinedButton(
          text: 'Include Unlisted',
          tags: [pac.PackageTag.showUnlisted],
          regExp: RegExp(r'^show:unlisted$'),
        ),
        selectableOutlinedButton(
          text: 'Has Screenshot',
          tags: [pac.PackageTag.hasScreenshot],
          regExp: RegExp(r'^has:screenshot$'),
        ),
        selectableOutlinedButton(
          text: 'Dart 3 Ready',
          tags: const ['is:dart3-compatible'],
          regExp: RegExp(r'^is:dart3-compatible$'),
        ),
        selectableOutlinedButton(
          text: 'Plugin',
          tags: const ['is:plugin'],
          regExp: RegExp(r'^is:plugin$'),
        ),
        selectableOutlinedButton(
          text: 'WASM Ready',
          tags: const ['is:wasm-ready'],
          regExp: RegExp(r'^is:wasm-ready$'),
        ),
        selectableOutlinedButton(
          text: 'Null Safe',
          tags: [pac.PackageTag.isNullSafe],
          regExp: RegExp(r'^is:null-safe$'),
        ),
        selectableOutlinedButton(
          text: 'License OSI Approved',
          tags: [pac.PackageTag.licenseOsiApproved],
          regExp: RegExp(r'^license:osi-approved$'),
        ),
        selectableOutlinedButton(
          text: 'Android',
          tags: [pac.PackageTag.platformAndroid],
          regExp: RegExp(r'^platform:android$'),
        ),
        selectableOutlinedButton(
          text: 'iOS',
          tags: [pac.PackageTag.platformIos],
          regExp: RegExp(r'^platform:ios$'),
        ),
        selectableOutlinedButton(
          text: 'Linux',
          tags: [pac.PackageTag.platformLinux],
          regExp: RegExp(r'^platform:linux$'),
        ),
        selectableOutlinedButton(
          text: 'macOS',
          tags: [pac.PackageTag.platformMacos],
          regExp: RegExp(r'^platform:macos$'),
        ),
        selectableOutlinedButton(
          text: 'Windows',
          tags: [pac.PackageTag.platformWindows],
          regExp: RegExp(r'^platform:windows$'),
        ),
        selectableOutlinedButton(
          text: 'Web',
          tags: [pac.PackageTag.platformWeb],
          regExp: RegExp(r'^platform:web$'),
        ),
        selectableOutlinedButton(
          text: 'Dart',
          tags: [pac.PackageTag.sdkDart],
          regExp: RegExp(r'^sdk:dart$'),
        ),
        selectableOutlinedButton(
          text: 'Flutter',
          tags: [pac.PackageTag.sdkFlutter],
          regExp: RegExp(r'^sdk:flutter$'),
        ),
      ],
    );
  }
}
