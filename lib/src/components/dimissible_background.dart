import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.71.vmax),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Text(
            'Remove',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 2.6.vmax
            ),
          ),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(
            width: 1.4.vmax,
          ),
        ],
      ),
    );
  }
}
