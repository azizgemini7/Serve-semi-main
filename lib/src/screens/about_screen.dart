import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/providers/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';
  @override
  Widget build(BuildContext context) {
    final _about = Provider.of<GlobalData>(context, listen: false).about;
    return Scaffold(
        appBar: AppBar(
          title: Text('${AppLocalizations.of(context).about}', style: TextStyle(color: Colors.black)),
        ),
        body: FutureBuilder(
            future:
                Provider.of<GlobalData>(context, listen: false).fetchAbout(),
            builder: (_, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting &&
                    _about == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Html(data: Provider.of<GlobalData>(context, listen: false).about),
                    ),
                  )));
  }
}
