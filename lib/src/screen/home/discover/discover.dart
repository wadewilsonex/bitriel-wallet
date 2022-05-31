import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/discover/body_discover.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({ Key? key }) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return DiscoverPageBody();
  }
}