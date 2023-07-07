import 'package:bitriel_wallet/domain/usecases/acc_manage_uc/create_wallet/create_wallet_uc.dart';
import 'package:bitriel_wallet/index.dart';

class CreateWalletImpl implements CreateWalletUsecase {
  
  @override
  Future<void> verifyLater() async {

    // _importAccountModel.status = false;

    // /// From Multi Account
    // if (widget.newAcc != null){

    //   dialogLoading(context);

    //   await addAndImport();
      
    //   Provider.of<ApiProvider>(context, listen: false).notifyListeners();
          
    //   Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));
    // }

    // /// From Onboading Page Create New
    // else {

    //   if(!mounted) return;
      
    //   Navigator.push(
    //     context, 
    //     Transition(
    //       child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
    //       transitionEffect: TransitionEffect.RIGHT_TO_LEFT
    //     )
    //   );
    // }

  }

  Future<void> generateSeed(BuildContext context) async {
    String seed = await Provider.of<SDKProvier>(context, listen: false).getSdkProvider.generateSeed();
    print(seed);
  }
}