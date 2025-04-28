import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../widgets/big_card.dart';
// import '../widgets/history_list.dart';

class ScanPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(

                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Scan()),
                    // );
                  },
                  child: const Text('SCAN QR CODE')
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ElevatedButton(

                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => GenerateScreen()),
                    // );
                  },
                  child: const Text('GENERATE QR CODE')
              ),
            ),
          ],
        )
    );
  }
}