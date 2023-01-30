/* The components file has custom widgets which are used by multiple different screens */

import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmers/shimmer_c.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuHeader extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;
 
  const MenuHeader({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 2.sp),
      margin:  EdgeInsets.symmetric(horizontal: 2.sp, vertical: 2.sp),
      width: 38.sp,
      decoration: BoxDecoration(
        gradient: isDarkMode ? null : LinearGradient(
          colors: [hexaCodeToColor(AppColors.primaryColor).withOpacity(0.2), hexaCodeToColor(AppColors.primaryColor).withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight, 
          stops: const [0.25, 0.75],
        ),
        color: isDarkMode ? hexaCodeToColor(AppColors.bluebgColor ) : null,
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: Consumer<ApiProvider>(
        builder: (context, value, child) {

          return InkWell(
            onTap: value.accountM.address == null ? null : () {
              Navigator.push(
                context,
                Transition(
                  child: const Account(),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                )
              );
            },
            child: Row(
              children: [
                
                AvatarShimmer(
                  txt: value.accountM.addressIcon,
                  child: randomAvatar(value.accountM.addressIcon ?? '', width: 6.0.sp, height: 6.0.sp)
                  // SvgPicture.string(
                  //   value.accountM.addressIcon ?? '',
                  //   width: 5.0.w,
                  //   // height: 8.0,
                  // )
                ),
                    
                SizedBox(width: 1.sp),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      TextShimmer(txt: value.accountM.name),
                      
                      WidgetShimmer(
                        txt: value.accountM.address, 
                        child: Row(
                          children: [
                            
                            Flexible(child: MyText(
                              right: 1.sp,
                              text: value.accountM.address == null ? "" : value.accountM.address!.replaceRange(8, value.accountM.address!.length - 8, "......."),
                              hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
                              // fontSize: 1.9.sp,
                              fontSize: 2,
                              // width: 10.sp,
                              textAlign: TextAlign.left,
                            )),
                
                            // InkWell(
                            //   onTap: () async {
                            //     await Clipboard.setData(
                            //       ClipboardData(text: value.accountM.address ??''),
                            //     );
                            //     Fluttertoast.showToast(
                            //       msg: "Copied address",
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.CENTER,
                            //     );
                            //   }, 
                            //   child: SvgPicture.asset(
                            //     '${AppConfig.iconsPath}qr_code.svg',
                            //     width: 2.sp,
                            //     height: 2.sp,
                            //     color: hexaCodeToColor(AppColors.secondary),
                            //   )
                            // )
                          ]
                        )
                      )
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 2.sp,)
              ],
            ),
          );
        }
      )
    );
  }
}

class MenuSubTitle extends StatelessWidget {
  
  final int? index;

  const MenuSubTitle({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2.sp, top: 2.sp, bottom: 1.sp),
      // color: isDarkMode
      //   ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06)
      //   : Colors.grey[200],
      // height: 8.sp,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Row(
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  text: MenuModel.listTile[index!]['title'].toString(),
                  hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              Expanded(
                child: Divider(
                  thickness: 0.4,
                  color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.darkGrey),
                  indent: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyListTile extends StatelessWidget {

  final Widget? icon;
  final void Function()? onTap;
  final int? index;
  final int? subIndex;
  final Widget? trailing;
  final bool? enable;
  final double? padding;

  const MyListTile({
    Key? key, 
    this.icon,
    @required this.index,
    @required this.subIndex,
    this.enable = true,
    this.trailing,
    this.padding = 1.5,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 7.5.sp,
          // padding: EdgeInsets.symmetric(vertical: padding!.sp),
          child: Row(
            children: [
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.sp),
                child: icon ?? Image.asset(
                  MenuModel.listTile[index!]['sub'][subIndex]['icon'].toString(),
                  color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey),
                  width: 3.5.sp,
                  height: 3.5.sp
                ),
              ),
              MyText(
                text: MenuModel.listTile[index!]['sub'][subIndex]['subTitle'].toString(),
                textAlign: TextAlign.left,
                // fontSize: 2.2.sp,
              ),
              Expanded(child: Align(alignment: Alignment.centerRight, child: trailing ?? Container() ,) )
              
            ],
          ),
        ),
      ),
    );
  }
}
  
// Widget customListTile(
//     BuildContext context, IconData icon, String title, dynamic method,
//     {bool maintenance = false}) {
//   return Container(
//     padding: EdgeInsets.only(left: 19.0, right: 19.0),
//     decoration: BoxDecoration(
//         border: Border(
//             top: BorderSide(width: 1, color: Colors.white.withOpacity(0.2)))),
//     child: ListTile(
//         contentPadding: EdgeInsets.all(0),
//         leading: Container(
//           padding: EdgeInsets.all(0),
//           // child: FaIcon(
//           //   icon,
//           //   color: Colors.white
//           // ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//               fontWeight: FontWeight.w400, color: hexaCodeToColor("#EFF0F2")),
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 10.0,
//           color: Colors.white,
//         ),
//         onTap: !maintenance
//             ? method
//             : () async {
//                 await dialog(
//                     context,
//                     Text("Feature under maintenance",
//                         textAlign: TextAlign.center),
//                     Text("Message"));
//               }),
//   );
// }