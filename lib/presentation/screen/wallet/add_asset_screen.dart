import 'package:bitriel_wallet/domain/usecases/add_asset_uc/add_asset_impl.dart';
import 'package:bitriel_wallet/index.dart';

class AddAsset extends StatelessWidget {

  const AddAsset({super.key});

  @override
  Widget build(BuildContext context) {

    final AddAssetUcImpl addAssetUcImpl = AddAssetUcImpl();

    if (addAssetUcImpl.context == null) addAssetUcImpl.setBuildContext = context;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // DropdownButton(
          //   items: items, 
          //   onChanged: (int? index) {
              
          //   }
          // ),
          
          Card(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: addAssetUcImpl.controller,
                onChanged: (String value) {
                  
                  addAssetUcImpl.validateWeb3Address();
          
                },
              ),
            ),
          ),

          ValueListenableBuilder(
            valueListenable: addAssetUcImpl.isEnable, 
            builder: (context, value, wg){
              return MyGradientButton(
                action: value == false ? null : () async {
                  await addAssetUcImpl.addAsset();
                }
              );
            }
          )
        ],
      ),
    );
  }
}