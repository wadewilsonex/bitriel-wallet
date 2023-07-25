import 'package:bitriel_wallet/index.dart';

class AddAsset extends StatelessWidget {

  const AddAsset({super.key});

  @override
  Widget build(BuildContext context) {

    final AddAssetUcImpl addAssetUcImpl = AddAssetUcImpl();

    addAssetUcImpl.setBuildContext = context;

    addAssetUcImpl.fetchContracts();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          ValueListenableBuilder(
            valueListenable: addAssetUcImpl.networkIndex, 
            builder: (context, value, wg){
              return Text(addAssetUcImpl.networkSymbol![value]['symbol']);
            }
          ),

          // GestureDetector(
          //   onTap: () async {
          //     FocusScope.of(context).unfocus();
          //     await showModalBottomSheet(
          //       context: context,
          //       isDismissible: true,
          //       backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.vertical( 
          //           top: Radius.circular(25.0),
          //         ),
          //       ),
          //       builder: (context) => listNetwork(
          //         isValue: true,
          //         listNetwork: addAssetUcImpl.networkSymbol!,
          //         onChanged: (value) {
          //           addAssetUcImpl.onChanged(value);
          //         }
          //         // initialValue: initialValue,
          //         // onChanged: (value) {
          //         //   assetM!.controllerAssetCode.clear();
                    
          //         //   onChangeNetwork!(value);

          //         //   onChangedQuery!(value);
                    
          //         // },
          //       ),
          //     );

          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(
          //       bottom: 8,
          //       left: paddingSize,
          //       right: paddingSize,
          //     ),
              
          //     child: Container(
          //       padding: const EdgeInsets.fromLTRB(
          //         paddingSize, 0, paddingSize, 0
          //       ), 
          //       decoration: BoxDecoration(
          //         color: isDarkMode
          //           ? Colors.white.withOpacity(0.06)
          //           : hexaCodeToColor(AppColors.whiteHexaColor),
          //         borderRadius: BorderRadius.circular(5),
          //       ),
          //       child: Row(
          //         children: <Widget>[

          //           const Expanded(
          //             child: MyTextConstant(
          //               // pTop: paddingSize,
          //               // pBottom: paddingSize,
          //               text: "Network",
          //               fontWeight: FontWeight.bold,
          //               fontSize: 17,
          //               textAlign: TextAlign.left,
          //               // hexaColor: isDarkMode
          //               //   ? AppColors.darkSecondaryText
          //               //   : AppColors.textColor,
          //             ),
          //           ),

          //           Row(
          //             children: [
          //               // Image.file(File("${networkSymbol![initialValue!]["logo"]}"), height: 22.sp, width: 22.sp,),

          //               // SizedBox(width: 30),

          //               // MyTextConstant(
          //               //   text: "${networkSymbol![initialValue!]["symbol"]}",
          //               //   fontWeight: FontWeight.bold,
          //               //   fontSize: 17,
          //               // ),

          //               SizedBox(width: 15,),

          //               Icon(Iconsax.arrow_right_3, color: hexaCodeToColor(AppColors.primaryColor),),
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          
          Card(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: addAssetUcImpl.controller,
                onChanged: (String value) {
                  
                  // addAssetUcImpl.validateWeb3Address();
                  addAssetUcImpl.searchContract(value);
          
                },
              ),
            ),
          ),

          // Show Loading
          ValueListenableBuilder(
            valueListenable: addAssetUcImpl.isSearching, 
            builder: (context, value, wg){
              // ignore: unnecessary_null_comparison
              if (value == true) return const CircularProgressIndicator();
              return const SizedBox();
            }
          ),

          ValueListenableBuilder(
            valueListenable: addAssetUcImpl.isEnable, 
            builder: (context, value, wg){
              return MyGradientButton(
                action: 
                // value == false ? null : 
                () async {

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