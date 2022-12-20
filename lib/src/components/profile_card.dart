import 'package:wallet_apps/index.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppString.accountView);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 25,
          bottom: 25,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: hexaCodeToColor(AppColors.whiteHexaColor),
        ),
        child: Consumer<ApiProvider>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 16),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: value.accountM.addressIcon == null
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hexaCodeToColor(
                                    AppColors.lowWhite,
                                  ),
                                ),
                              ),
                            )
                          : SvgPicture.string(
                              value.accountM.addressIcon!,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: value.accountM.name ?? 'Username',
                          hexaColor: "#FFFFFF",
                          fontSize: 20,
                        ),
                        SizedBox(
                          width: 100,
                          child: MyText(
                            text:
                                !value.isConnected ? "Connecting" : "Indracore",
                            hexaColor: AppColors.secondarytext,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    if (!value.isConnected)
                      Container()
                    else
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 150,
                          child: MyText(
                            text: '', //sdkModel.nativeBalance,
                            fontSize: 30,
                            hexaColor: AppColors.secondarytext,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: value.accountM.address),
                    ).then(
                      (value) => {
                        snackBar(context, "Copied to Clipboard")
                      },
                    );
                  },
                  child: MyText(
                    top: 16,
                    width: 300,
                    text: value.accountM.address ?? "",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}