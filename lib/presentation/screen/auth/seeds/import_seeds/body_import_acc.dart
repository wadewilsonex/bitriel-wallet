import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/presentation/components/seeds_c.dart';
import 'package:wallet_apps/data/models/import_acc_m.dart';

class ImportAccBody extends StatelessWidget {

  final bool? enable;
  final String? reImport;
  final ImportAccModel? importAccModel;
  final Function? onChanged;
  final Function? onSubmit;
  final Function? clearInput;

  const   ImportAccBody({
    Key? key, 
    this.importAccModel,
    this.onChanged,
    this.onSubmit,
    this.clearInput,
    this.enable,
    this.reImport,
  }) : super(key: key);

  final EdgeInsetsGeometry padding = const EdgeInsets.only(left: paddingSize, right: paddingSize);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SeedContents(
            title: 'Restore with seed', 
            subTitle: 'Please add your 12 words seed below to restore your wallet.'
          ),
    
          MySeedField(
            pLeft: 0, pRight: 0,
            pTop: 20,
            pBottom: 16.0,
            hintText: "Add your 12 keywords",
            textInputFormatter: [
              LengthLimitingTextInputFormatter(
                TextField.noMaxLength,
              )
            ],
            controller: importAccModel!.key,
            focusNode: importAccModel!.keyNode,
            maxLine: 7,
            onChanged: onChanged,
            onSubmit: onSubmit,
          ),
    
          Expanded(child: Container()),
          MyGradientButton(
            textButton: "Continue",
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: onSubmit,
          ),
        ],
      ),
    );
  }
}
