import 'package:bitriel_wallet/index.dart';

class StatusExchange extends StatelessWidget {

  final ValueNotifier<List<SwapResModel>>? lstSwapResponse;

  const StatusExchange({super.key, required this.lstSwapResponse});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(context, title: "Exchange Status"),
      body: Column(
        children: [
          _inputExchangeID(),
          
          MyButton(
            edgeMargin: const EdgeInsets.all(paddingSize),
            textButton: "Check",
            action: () async {

            },
          ),

          ValueListenableBuilder(
            valueListenable: lstSwapResponse!,
            builder: (context, lst, wg) {
              return ListView(
                shrinkWrap: true,
                children: lst.map((e) {
                  return InkWell(
                    onTap: (){
                      
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          children: [
                            Text(e.transaction_id!),
                            Text(e.status!),
                          ],
                        ),

                        const Text("Transfer")

                      ],
                    )
                  );
                }
                ).toList(),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _inputExchangeID() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: const Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Enter Exchange ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: TextField(
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Exchange ID',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}