import 'package:wallet_apps/index.dart';

class SwapPageBody extends StatelessWidget {
  const SwapPageBody({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(Iconsax.profile_circle, size: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Iconsax.scan,
              size: 25,
            ),
            onPressed: () {

            },
          )
        ],
      ),
      
      body: BodyScaffold(
        physic: BouncingScrollPhysics(),
        isSafeArea: true,
        bottom: 0,
        child: Column(
          children: [
           
            
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: true,
      ),
    );
  }


}