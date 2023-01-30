import 'package:wallet_apps/index.dart';

class MyMenuItem extends StatelessWidget {
  final String? title;
  final String? asset;
  final Widget? icon;
  final Function? action;
  final String colorHex;
  
  const MyMenuItem({
    Key? key, 
    this.title,
    this.asset,
    this.icon,
    required this.colorHex,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // return GestureDetector(
    //   onTap: (){
    //     action!();
    //   },
    //   child: Container(
    //     height: 15.h,
    //     decoration: BoxDecoration(
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.grey.withOpacity(0.5),
    //           spreadRadius: 1,
    //           blurRadius: 7,
    //           offset: const Offset(0, 3), // changes position of shadow
    //         ),
    //       ],
    //       borderRadius: BorderRadius.circular(8),
    //       color: hexaCodeToColor(colorHex),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.only(left: 10.0),
    //       child: Column(
            
    //         children: [
    //           Row(  
    //             children: [
    //               MyText(
    //                 top: 10,
    //                 text: title,
    //                 hexaColor: AppColors.whiteColorHexa,
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 18,
    //               ),
    //             ],
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Flexible(
    //                 child: MyText(
    //                   textAlign: TextAlign.start,
    //                   text: subtitle,
    //                   hexaColor: AppColors.whiteColorHexa,
    //                   fontWeight: FontWeight.w400,
    //                   fontSize: 14,
    //                 ),
    //               ),
                  
    //               icon!
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return InkWell(
      onTap: () {
        action!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 13.7.sp,
          decoration: BoxDecoration(
            color: hexaCodeToColor(colorHex),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
                child: MyText(
                  text: title,
                  hexaColor: AppColors.whiteColorHexa,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),

              Row(
                children: [
                  const Spacer(),
                  Flexible(
                    child: Align(
                      heightFactor: 0.77,
                      widthFactor: 0.77,
                      alignment: Alignment.topLeft,
                      child: Image.asset(asset!),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
      // child: Container(
      //   height: 14.h,
      //   // width: 120,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(8),
      //     color: hexaCodeToColor(colorHex),
      //   ),
      //   child: Stack(
      //     children: [
      //       Column(
      //         // mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         children: [
      //           Row(
      //             // mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               Container(
      //                 margin: const EdgeInsets.only(left: 10, top: 10),
      //                 child: MyText(
      //                   text: title,
      //                   hexaColor: AppColors.whiteColorHexa,
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 17,
      //                 ),
      //               ),
      //             ],
      //           ),
                
      //         ],
      //       ),

      //       Align(
      //         alignment: Alignment.bottomRight,
      //         child: SizedBox(
      //           width: 40.w,
      //           child: Image.asset(
      //             asset!,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );

  }
}