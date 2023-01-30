import 'package:wallet_apps/index.dart';

Widget buildListBody(
  List<dynamic>? activity,
) {
  return activity != null
      ? activity.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: activity.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   transitionRoute(
                    //     TransactionActivityDetails(_activity[index]),
                    //   ),
                    // );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4.0, top: 10.5),
                    padding: const EdgeInsets.only(top: 20.38, bottom: 16.62),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* Asset Icons */
                        Container(
                          margin: const EdgeInsets.only(right: 9.5),
                          width: 31.0,
                          height: 31.0,
                          child: CircleAvatar(
                              backgroundImage: AssetImage(
                            AppConfig.logoTrxActivity,
                          )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            /* Asset name and date time */
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                activity[index]['location'].toString(),
                              ),
                              Text(
                                AppUtils.timeStampToDateTime(
                                  activity[index]['created_at'].toString(),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Text(
                            activity[index]['status'].toString(),
                            style: TextStyle(
                              color: hexaCodeToColor(AppColors.greenColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
                // : Container();
              },
            )
          : loading() /* Show Loading If History Length = 0 */
      : Align(
          child: SvgPicture.asset('${AppConfig.iconsPath}no_data.svg'),
        ); /* Show Text (No activity) If Respoonse Length = 0 */
}

Widget rowInformation(String title, dynamic data) {
  /* Display Information By Row */
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 2.6.sp,
                color: Colors.white,
              ),
            ),
            /* Title */
            Expanded(
              child: Text(
                "$data",
                style: TextStyle(
                  fontSize: 2.6.sp,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ) /* Subtitle */
          ],
        ),
      ),
      Divider(
        height: 1,
        color: Colors.white.withOpacity(0.2),
        thickness: 1.0,
      ),
    ],
  );
}
