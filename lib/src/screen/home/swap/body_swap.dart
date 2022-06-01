import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/passcode/body_passcode.dart';

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
            _payInput(context),
            
            _getDisplay(context),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyText(
                text: 'Enter how much you want to swap',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: paddingSize),
              child: MyText(
                text: 'Minimum value is 0.00058714 BTC',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColorHexa
              ),
            ),

            _buildNumberPad(context),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: true,
      ),
    );
  }

  Widget _payInput(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
      child: Row(
        children: [
          Column(
            children: [
              MyText(
                text: 'You Pay',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),
          Expanded(child: Container()),
          _dropdownPayToken(context),
        ],
      ),
    );
  }

  Widget _getDisplay(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize),
      child: Row(
        children: [
          Column(
            children: [
              MyText(
                text: 'You Get',
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColorHexa,
              ),
            ],
          ),
          Expanded(child: Container()),
          _dropdownGetToken(context),
        ],
      ),
    );
  }

  Widget _dropdownPayToken(BuildContext context){
    List<String> _animals = ["Dog", "Cat", "Crocodile", "Dragon"];

    String? _selectedColor;

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
            color: hexaCodeToColor("#114463"),
            borderRadius: BorderRadius.circular(8)),
        child: DropdownButton<String>(
          onChanged: (value) {
            // setState(() {
            //   _selectedColor = value;
            // });
          },
          value: _selectedColor,
    
          // Hide the default underline
          underline: Container(),
          hint: Center(
            child: Text(
              'Select',
              style: TextStyle(color: Colors.white),
            )
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          isExpanded: true,
    
          // The list of options
          items: _animals
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
    
          // Customize the selected item
          selectedItemBuilder: (BuildContext context) => _animals
              .map((e) => Center(
                    child: Text(
                      e,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _dropdownGetToken(BuildContext context){
    List<String> _animals = ["Dog", "Cat", "Crocodile", "Dragon"];

    String? _selectedColor;

    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
            color: hexaCodeToColor("#114463"),
            borderRadius: BorderRadius.circular(8)),
        child: DropdownButton<String>(
          onChanged: (value) {
            // setState(() {
            //   _selectedColor = value;
            // });
          },
          value: _selectedColor,
    
          // Hide the default underline
          underline: Container(),
          hint: Center(
            child: Text(
              'Select',
              style: TextStyle(color: Colors.white),
            )
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          isExpanded: true,
    
          // The list of options
          items: _animals
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
    
          // Customize the selected item
          selectedItemBuilder: (BuildContext context) => _animals
              .map((e) => Center(
                    child: Text(
                      e,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _tapAutoAmount(BuildContext context){
    return Container();
  }

  Widget _buildNumberPad(context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(1, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(2, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(3, () {
              }),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(4, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(5, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(6, () {
              }),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: <Widget>[
              ReuseKeyBoardNum(7, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(8, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(9, () {
              }),
            ],
          ),
          
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(child: Container()),
              // ReuseKeyBoardNum(null, null, child: Container()),
              SizedBox(width: 19),
              ReuseKeyBoardNum(0, () {
              }),
              SizedBox(width: 19),
              ReuseKeyBoardNum(
                null, 
                () {
                  
                },
                child: Transform.rotate(
                  angle: 70.6858347058,
                  child: Icon(Iconsax.shield_cross, color: hexaCodeToColor(AppColors.bgdColor), size: 30),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}