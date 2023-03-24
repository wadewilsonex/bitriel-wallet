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
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      margin:  EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        gradient: isDarkMode ? null : LinearGradient(
          colors: [hexaCodeToColor(AppColors.primaryColor).withOpacity(0.2), hexaCodeToColor(AppColors.primaryColor).withOpacity(0.2)],
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
                onTap: value.getKeyring.current.address == null ? null : () {
                  Navigator.push(
                    context,
                    Transition(
                      child: const Account(),
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    )
                  );
                },
                child: AvatarShimmer(
                  txt: value.getKeyring.current.icon,
                  child: randomAvatar(value.getKeyring.current.icon ?? '', width: 5.0, height: 5.0)
                  // SvgPicture.string(
                  //   value.getKeyring.current.addressIcon ?? '',
                  //   width: 5.0,
                  //   // height: 8.0,
                  // )
                )
              ),
                
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  TextShimmer(txt: value.getKeyring.current.name),
                  
                  WidgetShimmer(
                    txt: value.getKeyring.current.address, 
                    child: Row(
                      children: [
                        
                        MyText(
                          right: 5,
                          text: value.getKeyring.current.address == null ? "" : value.getKeyring.current.address!.replaceRange(8, value.getKeyring.current.address!.length - 8, "........"),
                          hexaColor: isDarkMode ? AppColors.lowWhite : AppColors.darkGrey,
                          fontSize: 13,
                          textAlign: TextAlign.left
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: value.getKeyring.current.address ??''),
                            );
                            Fluttertoast.showToast(
                              msg: "Copied address",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }, 
                          child: SvgPicture.asset(
                            '${AppConfig.iconsPath}qr_code.svg',
                            width: 5,
                            height: 5,
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

  const MenuSubTitle({Key? key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
      // color: isDarkMode
      //   ? hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06)
      //   : Colors.grey[200],
      // height: 100,
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
        width: 22.5,
        height: 22.5
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