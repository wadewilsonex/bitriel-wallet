import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
            onPressed: () {
              final contract =
                  Provider.of<ContractProvider>(context, listen: false)
                      .listContract;

              // MarketProvider().fetchLineChartData('polkadot');

              // List<SmartContractModel> testList = [
              //   contract[0],
              //   contract[1],
              // ];

              // testList.add(contract[0]);
              // testList.add(contract[1]);

              //  print(contract[3].lineChartData);
              final res = SmartContractModel.encode(contract);

              print(res);

              // debugPrint(res, wrapWidth: 1024);

              final res1 = SmartContractModel.decode(res);

              print(res1[2].symbol);

              // print(res1[2].marketData.id);

              // print('lineChartData: ${res1[2].lineChartData}');

              // res1[3].lineChartModel =
              //     LineChartModel().prepareGraphChart(res1[3]);
            },
            child: Text('Covert')),
        // Pie Chart With List Asset Market
        PortFolioCus(),

        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.isReady
              // Asset List As Row
              ? AnimatedOpacity(
                  opacity: value.isReady ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: AssetList(),
                )
              // Loading Data Effect Shimmer
              : MyShimmer(isDarkTheme: isDarkTheme);
        }),
      ],
    );
  }
}
