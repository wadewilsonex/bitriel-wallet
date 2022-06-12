import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import '../../index.dart';

class PassCodeComponent{

  void passCode({required BuildContext context, required InputController inputController}){
    screenLock<void>(
      context: context,
      title: Column(
        children: [
          MyText(
            text: "PIN!",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteHexaColor,
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 42, right: 42, top: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Assign a security ', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'PIN ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'that will be required when opening in the future', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      confirmTitle: Column(
        children: [
          MyText(
            text: "Verify PIN!",
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteHexaColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42, right: 42, top: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Assign a security ', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'PIN ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: 'that will be required when opening in the future', 
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      correctString: '123456',
      confirmation: true,
      digits: 6,
      // inputController: inputController,
      screenLockConfig: ScreenLockConfig(
        backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      ),
      secretsConfig: SecretsConfig(
        spacing: 15, // or spacingRatio
        padding: const EdgeInsets.all(40),
        secretConfig: SecretConfig(
          borderColor: Colors.transparent,
          borderSize: 2.0,
          disabledColor: hexaCodeToColor(AppColors.passcodeColor),
          enabledColor: hexaCodeToColor(AppColors.primaryColor),
          height: 25,
          width: 25,
          build: (context, {required config, required enabled}) {
            return SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: enabled
                      ? config.enabledColor
                      : config.disabledColor,
                  border: Border.all(
                    width: config.borderSize,
                    color: config.borderColor,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                width: config.width,
                height: config.height,
              ),
              width: config.width,
              height: config.height,
            );
          },
        ),
      ),
      inputButtonConfig: InputButtonConfig(
        textStyle: InputButtonConfig.getDefaultTextStyle(context)
            .copyWith(
          color: hexaCodeToColor(AppColors.whiteColorHexa),
          fontWeight: FontWeight.bold,
        ),
        buttonStyle: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
          ),
          backgroundColor: Colors.white.withOpacity(0.06),
        ),
        displayStrings: [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9'
        ]
      ),
      cancelButton: const Icon(Icons.close),
      deleteButton: const Icon(Icons.delete),
      didConfirmed: (matchedText) {

        Navigator.push(context, MaterialPageRoute(builder: (context) => ContentsBackup()));
        // ignore: avoid_print
      },  
    );
  }

}