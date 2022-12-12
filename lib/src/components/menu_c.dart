/* The components file has custom widgets which are used by multiple different screens */
import 'dart:ui';

import 'package:random_avatar/random_avatar.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmers/shimmer_c.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet_apps/src/constants/ui_helper.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';

class MenuHeader extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;
 
  const MenuHeader({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      margin:  EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: isDarkMode ? null : LinearGradient(
          colors: [hexaCodeToColor("#F27649"), hexaCodeToColor("#F28907")],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight, 
          stops: const [0.25, 0.75],
        ),
        color: isDarkMode ? hexaCodeToColor(AppColors.bluebgColor ) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Consumer<ApiProvider>(
        builder: (context, value, child) {
          return Row(
            children: [
              
              InkWell(
                onTap: value.accountM.address == null ? null : () {
                  Navigator.push(
                    context,
                    Transition(
                      child: const Account(),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );
                },
                child: AvatarShimmer(
                  txt: value.accountM.addressIcon,
                  child: randomAvatar(value.accountM.addressIcon ?? '', width: 5.0.w, height: 5.0.w)
                  // SvgPicture.string(
                  //   value.accountM.addressIcon ?? '',
                  //   width: 5.0.w,
                  //   // height: 8.0,
                  // )
                )
              ),
                
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  TextShimmer(txt: value.accountM.name),
                  
                  WidgetShimmer(
                    txt: value.accountM.address, 
                    child: Row(
                      children: [
                        
                        MyText(
                          right: 5,
                          text: value.accountM.address == null ? "" : value.accountM.address!.replaceRange(8, value.accountM.address!.length - 8, "........"),
                          hexaColor: AppColors.lowWhite,
                          fontSize: 13,
                          textAlign: TextAlign.left
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: value.accountM.address ??''),
                            );
                            Fluttertoast.showToast(
                              msg: "Copied address",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }, 
                          child: SvgPicture.asset(
                            '${AppConfig.iconsPath}qr_code.svg',
                            width: 5.w,
                            height: 5.w,
                            color: hexaCodeToColor(isDarkMode ? AppColors.secondary : AppColors.whiteColorHexa),
                          )
                        )
                      ]
                    )
                  )
    
    
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

class MenuSubTitle extends StatelessWidget {
  
  final int? index;

  MenuSubTitle({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
      // color: isDarkMode
      //   ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06)
      //   : Colors.grey[200],
      height: 55,
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

  const MyListTile({
    Key? key, 
    this.icon,
    @required this.index,
    @required this.subIndex,
    this.enable = true,
    this.trailing,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return ListTile(
      enabled: enable!,
      onTap: onTap,
      leading: icon ?? Image.asset(
        MenuModel.listTile[index!]['sub'][subIndex]['icon'].toString(),
        color: isDarkMode ? Colors.white : hexaCodeToColor(AppColors.darkGrey),
        width: 22.5.sp,
        height: 22.5.sp
      ),
      title: MyText(
        text: MenuModel.listTile[index!]['sub'][subIndex]['subTitle'].toString(),
        textAlign: TextAlign.left,
        fontSize: 15,
      ),
      trailing: trailing,
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