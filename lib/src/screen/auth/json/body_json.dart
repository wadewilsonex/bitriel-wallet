import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/seeds_c.dart';
import 'package:wallet_apps/data/models/import_acc_m.dart';

class JsonBody extends StatelessWidget {

  final ImportAccModel? accModel;
  final Function? onChanged;
  final Function? onSubmit;
  
  JsonBody({
    Key? key, 
    required this.accModel, 
    required this.onChanged, 
    required this.onSubmit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Column(  
        children: [
          
          const Align( 
            alignment: Alignment.centerLeft,
            child: SeedContents(
              title: 'Restore with Json', 
              subTitle: 'Please add your Json Text Or File below to restore your wallet.'
            ),
          ),
    
          MySeedField(
            pLeft: 0, pRight: 0,
            pTop: 20,
            pBottom: 16.0,
            hintText: "Add your Json text",
            textInputFormatter: [
              LengthLimitingTextInputFormatter(
                TextField.noMaxLength,
              )
            ],
            controller: accModel!.key,
            focusNode: accModel!.keyNode,
            maxLine: 7,
            onChanged: onChanged,
            //inputAction: TextInputAction.done,
            onSubmit: (){},
          ),
    
          MyInputField(
            pLeft: 0, pRight: 0,
            controller: accModel!.usrName, 
            focusNode: accModel!.usrNameNode,
            onChanged: onChanged,
            onSubmit: (){}
          ),

          MyInputField(
            pLeft: 0, pRight: 0,
            controller: accModel!.pwCon, 
            focusNode: accModel!.pwNode,
            onChanged: onChanged,
            onSubmit: (){}
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