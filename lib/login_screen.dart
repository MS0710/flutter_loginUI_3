import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreen();
  }

}

class _LoginScreen extends State<LoginScreen>{
  late String animationURL;
  late Artboard _teddyArtboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? numLook;
  bool _isChecked = false;

  StateMachineController? stateMachineController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationURL = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS
        ? 'assets/animations/login.riv'
        : 'animations/login.riv';

    rootBundle.load(animationURL).then(
          (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(artboard, "Login Machine");
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);

          for (var e in stateMachineController!.inputs) {
            debugPrint(e.runtimeType.toString());
            debugPrint("name${e.name}End");
          }

          for (var element in stateMachineController!.inputs) {
            if (element.name == "trigSuccess") {
              successTrigger = element as SMITrigger;
            } else if (element.name == "trigFail") {
              failTrigger = element as SMITrigger;
            } else if (element.name == "isHandsUp") {
              isHandsUp = element as SMIBool;
            } else if (element.name == "isChecking") {
              isChecking = element as SMIBool;
            } else if (element.name == "numLook") {
              numLook = element as SMINumber;
            }
          }
        }

        setState(() => _teddyArtboard = artboard);
      },
    );
  }

  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBalls(val) {
    numLook?.change(val.length.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              if (_teddyArtboard != null)
              SizedBox(
                width: 400,
                height: 300,
                child: Rive(
                  artboard: _teddyArtboard,
                  fit: BoxFit.fitWidth,
                ),
              ),

              Container(
                alignment: Alignment.center,
                width: 400,
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.only(bottom: 15 * 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          const SizedBox(height: 15 * 2),
                          TextField(
                            controller: _emailController,
                            onTap: lookOnTheTextField,
                            onChanged: moveEyeBalls,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: const Color(0xffb04863),
                            decoration: const InputDecoration(
                              hintText: "Email",
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusColor: Color(0xffb04863),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffb04863),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),
                          TextField(
                            controller: _passwordController,
                            //onTap: handsOnTheEyes,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            cursorColor: const Color(0xffb04863),
                            decoration: const InputDecoration(
                              hintText: "Password",
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusColor: Color(0xffb04863),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffb04863),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: _isChecked,
                                      onChanged: (value){
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      },
                                  ),
                                  const Text(
                                    "Remember me",
                                  ),
                                ],
                              ),

                              ElevatedButton(
                                onPressed: (){
                                  login();
                                  //login2(1);
                                  //failTrigger?.fire();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffb04863),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



  void login() {
    print("login");
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (_emailController.text == "admin@gmail.com" &&
        _passwordController.text == "admin") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }

  void login2(int input) {
    print("login2");
    if(input == 0){
      successTrigger?.fire();
    }else{
      failTrigger?.fire();
    }

  }

}