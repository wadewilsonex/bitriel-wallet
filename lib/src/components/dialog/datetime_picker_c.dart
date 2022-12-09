import 'package:flutter/cupertino.dart';

import '../../../index.dart';

Future dateTimePicker({required BuildContext context}){
  return showDialog<DateTime>(
    context: context,
    builder: (_) => DatePickerDialog(
      restorationId: 'date_picker_dialog',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime(2021),
      firstDate:DateTime(2000),
      lastDate: DateTime(2023)
    )
  );
}