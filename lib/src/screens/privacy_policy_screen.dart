import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/global_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static const routeName = '/privacy-policy';
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen>
    with AlertsMixin {
  bool _isLoading = false;
  String _policies;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchPolicies();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _fetchPolicies() async {
    _policies = Provider.of<GlobalData>(context, listen: false).policies;
    _isLoading = true;
    try {
      await Provider.of<GlobalData>(context, listen: false).fetchPolicies();
    } on HttpException catch (error) {
      showErrorDialog(context, error.toString());
    } catch (error) {
      showErrorDialog(context, 'Something went wrong!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).privacyPolicy, style: TextStyle(color: Colors.black),),
      ),
      body: _isLoading && _policies == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( 
            child: 
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                Provider.of<GlobalData>(context, listen: false).policies ?? '',
                style: TextStyle(height: 1.7),
              ),
            ),
          ),
    );
  }
}
