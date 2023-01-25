import '../../../../index.dart';

class AssetCheckIn extends StatelessWidget {
  final List<Map> _txCheckIn;
  const AssetCheckIn(this._txCheckIn, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (_txCheckIn.isEmpty)
            SvgPicture.asset(
              '${AppConfig.iconsPath}no_data.svg',
              width: 250,
              height: 250,
            )
          else
            Expanded(
              child: _txCheckIn.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: _txCheckIn.length,
                      itemBuilder: (context, index) {
                        return rowDecorationStyle(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: hexaCodeToColor(AppColors.secondary),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child:
                                    Image.asset('${AppConfig.assetsPath}koompi_white_logo.png'),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      MyText(
                                        text: '',
                                        hexaColor: "#FFFFFF",
                                      ),
                                      MyText(text: '', fontSize: 2.2),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      MyText(
                                        width: double.infinity,
                                        text: '',
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
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
