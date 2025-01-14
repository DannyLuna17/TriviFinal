import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:trivi_app/helpers/helpers.dart';
import 'package:trivi_app/providers/shared_data.dart';
import 'package:trivi_app/widgets/widgets.dart';

class FileUploadedWidget extends StatelessWidget {
  const FileUploadedWidget({
    required this.providerWithout,
    required this.name,
    super.key,
  });

  final SharedData providerWithout;
  final String name;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 1, end: 8),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.transparent,
        borderSide: BorderSide(color: Color.fromRGBO(195, 195, 195, 1)),
      ),
      badgeContent: ShrinkWidget(
        onPressed: () {
                                      if (providerWithout.vibration) Helpers.vibrate(HapticsType.success);

          providerWithout.setUploaded(!providerWithout.uploaded);
        },
        child: GestureDetector(
          child: const Icon(
            FlutterIcons.close_ant,
          ),
        ),
      ),
      child: ShrinkWidget(
        shrinkScale: 0.96,
        child: Column(
          children: [
            const Icon(
              FlutterIcons.pdf_box_mco,
              size: 65,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
