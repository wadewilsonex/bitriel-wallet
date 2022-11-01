import 'package:wallet_apps/index.dart';
import '../../../../graphql/graphql.dart';
import 'body_address_detail.dart';

class ExplorerDetail extends StatefulWidget {
  final String? controller;
  const ExplorerDetail({Key? key, this.controller}) : super(key: key);

  @override
  State<ExplorerDetail> createState() => _ExplorerDetailState();
}

class _ExplorerDetailState extends State<ExplorerDetail> {

  final ExplorerQueries _explorerQueries = ExplorerQueries();

  @override
  Widget build(BuildContext context) {
    return ExplorerDetailBody(
      explorerQueries: _explorerQueries,
      controller: widget.controller,
    );
  }
}