import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthorsNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).applicationLegalese,
      overflow: TextOverflow.fade,
      maxLines: 2,
      style: TextStyle(color: Colors.white),
      softWrap: false,
      textAlign: TextAlign.center,
    );
  }
}
