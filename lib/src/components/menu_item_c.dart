import 'package:wallet_apps/index.dart';

class MyMenuItem extends StatelessWidget {
  final String? title;
  final String? asset;
  final Widget? icon;
  final Function? action;
  final String colorHex;
  final double top;
  final double bottom;
  final double left;
  final double right;
  final double width;
  final double height;
  
  const MyMenuItem({
    Key? key, 
    this.title,
    this.asset,
    this.icon,
    required this.colorHex,
    required this.action,
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
    required this.width,
    required this.height,
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
      child: Container( 
        height: 100,
        decoration: BoxDecoration(
          color: hexaCodeToColor(colorHex),
          borderRadius: BorderRadius.circular(8),
        ) ,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: MyText(
                      text: title,
                      hexaColor: AppColors.whiteColorHexa,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              Stack(
                children: <Widget>[ 
                  Positioned(
                    top: top.sp,
                    right: bottom.sp, 
                    left: left.sp,
                    bottom: bottom.sp,
                    child:Container( 
                      height: height.h,
                      width: width.w,
                      decoration:BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(asset!),
                        ),
                      )
                    )
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