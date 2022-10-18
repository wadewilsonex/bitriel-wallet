import 'dart:ui';
import '../../../../index.dart';

class AssetHistory extends StatelessWidget {
  final List<TxHistory>? txHistoryModel;
  final String? logo;
  final bool? isPay;
  final Function? deleteHistory;
  final Function? showDetailDialog;
  const AssetHistory({
    Key? key,
    this.txHistoryModel,
    this.isPay,
    this.logo,
    this.deleteHistory,
    this.showDetailDialog, 
    }
  ) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (txHistoryModel!.isEmpty)
            SvgPicture.asset(
              '${AppConfig.iconsPath}no_data.svg',
              width: 180,
              height: 180,
            )
          else
            Expanded(
              child: txHistoryModel!.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: txHistoryModel!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: const DismissibleBackground(),
                          onDismissed: (direction) {
                            deleteHistory!(
                                index, txHistoryModel![index].symbol);
                          },
                          child: GestureDetector(
                            onTap: () {
                              showDetailDialog!(txHistoryModel![index]);
                            },
                            child: rowDecorationStyle(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color:
                                          hexaCodeToColor(AppColors.secondary),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Image.asset(logo!),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: txHistoryModel![index].symbol!,
                                            hexaColor: "#FFFFFF",
                                          ),
                                          MyText(
                                              text: txHistoryModel![index].org!,
                                              fontSize: 15),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            width: double.infinity,
                                            text: txHistoryModel![index].amount!,
                                            hexaColor: "#FFFFFF",
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          if (isPay == false)
            Container()
          else
            BackdropFilter(
              // Fill Blur Background
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  // Expanded(
                  //   child: CustomAnimation.flareAnimation(
                  //     _flareController,
                  //     AppConfig.animationPath+"check.flr",
                  //     "Checkmark",
                  //   ),
                  // ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
