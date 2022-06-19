/* The components file has custom widgets which are used by multiple different screens */

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/shimmer_c.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuHeader extends StatelessWidget {
  
  final Map<String, dynamic>? userInfo;
 
  const MenuHeader({this.userInfo});

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      margin:  EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: hexaCodeToColor("#114463"),
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
                      child: Account(),
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
                          text: value.accountM.address == null ? "" : value.accountM.address!.replaceRange(5, value.accountM.address!.length - 5, "....."),
                          color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                          fontSize: 16,
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
                            AppConfig.iconsPath+'qr_code.svg',
                            width: 5.w,
                            height: 5.w,
                            color: hexaCodeToColor(AppColors.secondary),
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

  const MenuSubTitle({this.index});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
      // color: isDarkTheme
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
                  color: "#D4D6E3",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: hexaCodeToColor("#D4D6E3"),
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
    this.icon,
    @required this.index,
    @required this.subIndex,
    this.enable = true,
    this.trailing,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return ListTile(
      enabled: enable!,
      onTap: onTap,
      leading: icon ?? Image.asset(
        MenuModel.listTile[index!]['sub'][subIndex]['icon'].toString(),
        color: isDarkTheme ? Colors.white : Colors.black,
        width: 22.5.sp,
        height: 22.5.sp
      ),
      title: MyText(
        text: MenuModel.listTile[index!]['sub'][subIndex]['subTitle'].toString(),
        color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
        textAlign: TextAlign.left,
        fontSize: 16,
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
