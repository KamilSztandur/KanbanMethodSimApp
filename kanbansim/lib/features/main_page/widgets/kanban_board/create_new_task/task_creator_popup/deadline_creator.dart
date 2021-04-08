import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeadlineCreator extends StatelessWidget {
  final Function(String) updateDeadline;
  final Function getCurrentDeadline;
  final double subWidth;

  DeadlineCreator({
    Key key,
    @required this.subWidth,
    @required this.updateDeadline,
    @required this.getCurrentDeadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: '${AppLocalizations.of(context).setDeadline}:\n',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context).deadlineAvailabilityNotice,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        Container(
          width: this.subWidth,
          child: TextField(
            maxLength: 2,
            textAlign: TextAlign.left,
            onChanged: (String value) {
              this.updateDeadline(value);
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              hintText: AppLocalizations.of(context).enterDeadlineDayNumber,
              labelStyle: new TextStyle(color: const Color(0xFF424242)),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
