import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

// Widget for sending suggestions and sms
class Suggestion extends StatefulWidget {
  final bool isSuggestion;
  final String contact;

  Suggestion(this.isSuggestion, this.contact);

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _subject.text = '';
    _message.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  _sendEmailSuggestion() async {
    final isValid = _formKey.currentState.validate();
    final prefs = await SharedPreferences.getInstance();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final data = {
        'subject': _subject.text.trim(),
        'message': _message.text.trim(),
      };

      final String token = prefs.getString('token');

      try {
        final response = await http.post(
          Uri.parse('https://tailoringhub.colonkoded.com/api/send/suggestion'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: jsonEncode(data),
        );

        final result = jsonDecode(response.body) as Map<String, dynamic>;

        if (result['success']) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text(
                'Suggestion message sent',
                textAlign: TextAlign.center,
              ),
              backgroundColor: ArgonColors.success,
            ),
          );

          _subject.clear();
          _message.clear();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text(
              'Something went wrong. Please try again!',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  _sendSMSMessage(String contact) async {
    final isValid = _formKey.currentState.validate();
    final prefs = await SharedPreferences.getInstance();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      final data = {
        'contact': '0' + contact,
        'message': _message.text.trim(),
      };

      final String token = prefs.getString('token');

      try {
        final response = await http.post(
          Uri.parse('https://tailoringhub.colonkoded.com/api/send/message'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: jsonEncode(data),
        );

        final result = jsonDecode(response.body) as Map<String, dynamic>;

        if (result['code'] == '1000') {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'],
                textAlign: TextAlign.center,
              ),
              backgroundColor: ArgonColors.success,
            ),
          );
          _message.clear();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text(
              'Something went wrong. Please try again!',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isSuggestion)
          ? Navbar(
              title: "Suggestions",
              bgColor: Colors.blue,
            )
          : null,
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Suggestions"),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/img/tailoringhub.jpg"),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 74.0, right: 18.0, left: 18.0, bottom: 36.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        (widget.isSuggestion)
                            ? TextFormField(
                                controller: _subject,
                                decoration: InputDecoration(
                                  labelText: 'Subject',
                                  icon: Icon(Icons.title),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter subject';
                                  }
                                  return null;
                                })
                            : const Text(''),
                        TextFormField(
                            controller: _message,
                            decoration: InputDecoration(
                              labelText: 'Message',
                              icon: Icon(Icons.message),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter message';
                              }
                              return null;
                            }),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: (_isLoading)
                                ? SizedBox(
                                    width: double.infinity,
                                    child: SpinKitFadingCircle(
                                      color: ArgonColors.bgColorScreen,
                                      size: 20.0,
                                    ),
                                  )
                                : Text(
                                    (widget.isSuggestion)
                                        ? 'Send suggestion'
                                        : 'Send pick up message',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                            onPressed: (widget.isSuggestion)
                                ? _sendEmailSuggestion
                                : () => _sendSMSMessage(widget.contact),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
