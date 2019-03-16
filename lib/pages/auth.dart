import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {

  final Map<String, dynamic> _formData = {
    'email':null,
    'password':null,
    'acceptTerms':false,
  };

  String _emailValue;
  String _passwordValue;
  bool _acceptTerms = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
        image: AssetImage("assets/background.jpg"));
  }

  Widget _buildEmailTextField() {

    bool isEmail(String input){
      return RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(input);
    }

    return TextFormField(
      initialValue: "test@test.com",
      decoration: InputDecoration(labelText: "Email", filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      validator: (String value){
        if(value.isEmpty || !isEmail(value)){
          return "Bro please put your real email in";
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }


  Widget _buildPasswordTextField() {
    return TextFormField(
      initialValue: "sdlfjsaldkfjlas",
      decoration: InputDecoration(labelText: "Password", filled: true, fillColor: Colors.white),
      obscureText: true,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      validator: (String value){
        if(value.isEmpty || value.length < 6){
          return "Your password is not long enough";
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text("Accept Terms"),
    );
  }

  void _submitForm(Function login) {
    if(!_formKey.currentState.validate() || _formData['acceptTerms'] == false){
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In to EasyList'),
        ),
        body: Container(
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Container(
                        width: targetWidth,
                        child: Form(
                            key: _formKey,
                            child: Column(
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(height: 20.0),
                            _buildPasswordTextField(),
                            SizedBox(height: 20.0),
                            _buildAcceptSwitch(),
                            ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
                               return RaisedButton(
                                  child: Text("SIGN IN"),
                                  onPressed: () => _submitForm(model.login),
                                  textColor: Colors.white,
                                );
                            })
                          ],
                        )
                      )
                    )
                  )
                )
              )
            );
  }
}
