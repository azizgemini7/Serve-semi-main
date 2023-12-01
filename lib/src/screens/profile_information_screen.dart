import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:Serve_ios/src/helpers/app_translations.dart';
import 'package:Serve_ios/src/helpers/my_flutter_app_icons.dart';
import 'package:Serve_ios/src/mixins/alerts_mixin.dart';
import 'package:Serve_ios/src/mixins/validation_mixin.dart';
import 'package:Serve_ios/src/models/http_exception.dart';
import 'package:Serve_ios/src/providers/auth.dart';
import 'package:Serve_ios/src/screens/registration_done_screen.dart';
import 'package:Serve_ios/src/widgets/custom_form_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileInformationScreen extends StatefulWidget {
  static const routeName = '/profile-information';

  @override
  _ProfileInformationScreenState createState() =>
      _ProfileInformationScreenState();
}

class _ProfileInformationScreenState extends State<ProfileInformationScreen>
    with AlertsMixin, ValidationMixin {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool isRegister = false;
  Map _regData = {};
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  Future<File> _getImageFromCamera() async {
    final picker = ImagePicker();
    File selectedImage;
    var image =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    selectedImage = File(image.path);
    return selectedImage;
  }

  Map _profileData = {'username': '', 'email': '', 'photo': null};
  Future<File> _getImageFromGallery() async {
    final picker = ImagePicker();
    File selectedImage;
    var image =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 600);
    selectedImage = File(image.path);
    return selectedImage;
  }

  _openPickingOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(25.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.pop(context);
                File myFile = await _getImageFromCamera();
                if (isRegister)
                  _regData['photo'] = myFile.path;
                else
                  _profileData['photo'] = myFile.path;
                setState(() {});
              },
              icon: Icon(
                Icons.camera_alt,
                color: Theme.of(context).buttonColor,
              ),
              iconSize: 28.0,
              tooltip: AppLocalizations.of(context).camera,
            ),
            IconButton(
              onPressed: () async {
                Navigator.pop(context);
                File myFile = await _getImageFromGallery();
                if (isRegister)
                  _regData['photo'] = myFile.path;
                else
                  _profileData['photo'] = myFile.path;
                setState(() {});
              },
              icon: Icon(
                Icons.photo_library,
                color: Theme.of(context).buttonColor,
              ),
              iconSize: 28.0,
              tooltip: AppLocalizations.of(context).gallery,
            )
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(26.0), topLeft: Radius.circular(26.0)),
      ),
    );
  }

  bool _isLoading = false;
  bool _isLoading2 = false;
  Future<void> _register(BuildContext context) async {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final regResponse =
            await _authReference.register(json.encode(_regData));
        final parsedRegResponse = json.decode(regResponse);
        print(parsedRegResponse);
        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
        Navigator.of(context).pushNamed(RegistrationDoneScreen.routeName);
        _isLoading = false;
      } on HttpException catch (error) {
        _isLoading = false;
        showErrorDialog(
            context, error.toString(), Duration(milliseconds: 1500));
      } catch (error) {
        _isLoading = false;
        throw error;
      }
      setState(() {});
    }
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await Provider.of<Auth>(context, listen: false)
            .updateProfile(json.encode(_profileData));

        setState(() {
          _isLoading = false;
        });
        final parsedResponse = json.decode(response);
        Navigator.of(context).pop(parsedResponse['message']);
        print(parsedResponse.toString());
      } on HttpException catch (error) {
        _isLoading = false;
        showErrorDialog(
            context, error.toString(), Duration(milliseconds: 1500));
      } catch (error) {
        _isLoading = false;
        throw error;
      }
      setState(() {});
    } else {}
  }

  Auth _authReference;
  @override
  void didChangeDependencies() {
    _authReference = Provider.of<Auth>(context);
    final args = ModalRoute.of(context).settings.arguments as Map;
    if (args != null) {
      isRegister = args['isRegister'];
      if (isRegister) {
        _regData = args;
      }
    } else {
      _profileData['username'] =
          _authReference.user != null ? _authReference.user.username : '';
      _profileData['email'] =
          _authReference.user != null ? _authReference.user.email : '';
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).profileInformation,
        ),
        elevation: 1.5,
      ),
      body: Container(
        padding: const EdgeInsets.only(
            left: 26.0, right: 26.0, top: 21.0, bottom: 31.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 43.0,
                    height: 135.0,
                    color: Color.fromARGB(255, 57, 186, 186).withOpacity(0.85),
                  ),
                  InkWell(
                    onTap: _openPickingOptions,
                    borderRadius: BorderRadius.circular(48.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[350],
                      backgroundImage: (_regData['photo'] == null &&
                              _profileData['photo'] == null)
                          ? (_authReference?.user?.photo == null
                              ? null
                              : CachedNetworkImageProvider(
                                  _authReference.user.photo))
                          : FileImage(
                              File(_regData['photo'] == null
                                  ? _profileData['photo']
                                  : _regData['photo']),
                            ),
                      radius: 48,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openPickingOptions,
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: Color(0xFFF2F1F2).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(MyCustomIcons.upload)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              isRegister
                  ? AppLocalizations.of(context).uploadYourProfilePicture
                  : AppLocalizations.of(context).changeYourProfilePicture,
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
            ),
            SizedBox(
              height: 40.0,
            ),
            Form(
              key: _registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).yourName,
                      style:
                          TextStyle(color: Color(0xFF1A1A1A).withOpacity(0.7)),
                    ),
                  ),
                  MyCustomInput(
                    focusNode: _focusNode1,
                    initialValue: _profileData['username'],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) {
                      _focusNode1.unfocus();
                      FocusScope.of(context).requestFocus(_focusNode2);
                    },
                    inputType: TextInputType.text,
                    onSaved: (val) {
                      if (isRegister)
                        _regData['username'] = val;
                      else
                        _profileData['username'] = val;
                    },
                    validator: validateUsername,
                    prefixIcon: Icon(
                      MyCustomIcons.user,
                      size: 20,
                      color: Colors.black,
                    ),
                    suffixIcon: isRegister
                        ? null
                        : Icon(
                            MyCustomIcons.edit,
                            size: 14,
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).email,
                      style:
                          TextStyle(color: Color(0xFF1A1A1A).withOpacity(0.7)),
                    ),
                  ),
                  MyCustomInput(
                    focusNode: _focusNode2,
                    initialValue: _profileData['email'],
                    validator: validateEmail,
//                    labelText: AppLocalizations.of(context).email,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) {
                      _focusNode2.unfocus();
                      _register(context);
                    },
                    inputType: TextInputType.emailAddress,
                    onSaved: (val) {
                      if (isRegister)
                        _regData['email'] = val;
                      else
                        _profileData['email'] = val;
                    },
                    prefixIcon: Icon(
                      Icons.mail_outline,
                    ),
                    suffixIcon: isRegister
                        ? null
                        : Icon(
                            MyCustomIcons.edit,
                            size: 14,
                          ),
                  ),
                ],
              ),
            ),
            Spacer(),
            isRegister
                ? (_isLoading
                    ? SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        ),
                      )
                    : MyCustomFormButton(
                        buttonText: AppLocalizations.of(context).save,
                        onPressedEvent: () {
                          if (isRegister)
                            _register(context);
                          else
                            _updateProfile(context);
                        },
                      ))
                : ((_isLoading || _isLoading2)
                    ? SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Platform.isIOS
                              ? CupertinoActivityIndicator()
                              : CircularProgressIndicator(),
                        ),
                      )
                    : Row(
                        children: [
                          _isLoading
                              ? SizedBox(
                                  height: 50.0,
                                  child: Center(
                                    child: Platform.isIOS
                                        ? CupertinoActivityIndicator()
                                        : CircularProgressIndicator(),
                                  ),
                                )
                              : MyCustomFormButton(
                                  buttonText: AppLocalizations.of(context).save,
                                  onPressedEvent: () {
                                    if (isRegister)
                                      _register(context);
                                    else
                                      _updateProfile(context);
                                  },
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          _isLoading2
                              ? SizedBox(
                                  height: 50.0,
                                  child: Center(
                                    child: Platform.isIOS
                                        ? CupertinoActivityIndicator()
                                        : CircularProgressIndicator(),
                                  ),
                                )
                              : MyCustomFormButton(
                                  buttonText: AppLocalizations.of(context)
                                      .deleteaccountcon,
                                  backgroundColor: Colors.red,
                                  onPressedEvent: () {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.BOTTOMSLIDE,
                                      dialogType: DialogType.WARNING,
                                      body: Center(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .deleteaccountconf,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      title:
                                          AppLocalizations.of(context).delete,
                                      desc: 'This is also Ignored',
                                      btnCancelColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.6),
                                      btnOkText: AppLocalizations.of(context)
                                          .deleteaccountcon,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15.0),
                                      btnOkColor: Theme.of(context).accentColor,
                                      btnCancelText:
                                          AppLocalizations.of(context).cancel,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        delet();
                                      },
                                    )..show();
                                  },
                                )
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await Provider.of<Auth>(context, listen: false).deleteacc(true);
    } on HttpException catch (e) {
      showErrorDialog(context, e.toString());
    } catch (e) {
      throw e;
    }
  }

  Future<void> delet() async {
    setState(() {
      _isLoading2 = true;
    });
    await _logout();
    // var   response = await http
    //       .get(
    //     Uri.parse( 'https://lazah.net/api/v1/delete-account'),       headers: {
    //       'Authorization': 'Bearer ${Provider.of<Auth>(context, listen: false)?.token}',
    //       'Accept-Language': 'ar'
    //     }
    //   );
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(AppLocalizations.of(context).successfullyDone),
    //   duration: Duration(milliseconds: 2000),
    // ));
    Navigator.pop(context);
  }
}
