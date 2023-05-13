import '../../../index.dart';

Future dateTimePicker({required BuildContext context, required List<Map<String, dynamic>>? ticketObj}){
  return showDialog<DateTime>(
    context: context,
    builder: (_) => Theme(
      data: ThemeData(
        colorScheme: ColorScheme.light(
          primary: hexaCodeToColor(AppColors.primaryColor)
        )
      ), 
      child: DatePickerDialog(
        restorationId: 'date_picker_dialog',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.parse(AppUtils.stringDateToDateTime(ticketObj![0]['date'])),
        firstDate: DateTime.parse(AppUtils.stringDateToDateTime(ticketObj[0]['date'])),
        lastDate: DateTime.parse(AppUtils.stringDateToDateTime(ticketObj[ticketObj.length - 1]['date'])),
      )
    )
  );
}