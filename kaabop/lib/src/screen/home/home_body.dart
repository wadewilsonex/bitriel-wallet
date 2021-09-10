import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    // final contract = Provider.of<ContractProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // RaisedButton(
        //   onPressed: () {
        //     contract.unsubscribeNetwork();
        //   },
        //   child: Text('unsubscribe'),
        // ),
        // Pie Chart With List Asset Market
        PortFolioCus(),

        Consumer<ContractProvider>(builder: (context, value, child) {
          if (value.isReady) print("value.isReady ${value.isReady}");
          return value.isReady
            // Asset List As Row
            ? AnimatedOpacity(
                opacity: value.isReady ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: AssetList(),
              )
            // Loading Data Effect Shimmer
            : MyShimmer(
                isDarkTheme: isDarkTheme,
              );
        }),
      ],
    );
  }
}
