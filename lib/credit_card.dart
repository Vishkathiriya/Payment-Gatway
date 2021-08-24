import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stripe_demo/PaypalPayment.dart';
import 'package:stripe_demo/bloc/creadit_card_bloc.dart';
import 'package:stripe_demo/global.dart';
// import 'package:stripe_demo/make_paymentBy_paypal.dart';
import 'package:stripe_demo/payment_info.dart';



class CreditCard extends StatefulWidget {
  final String paySELECTED; 
CreditCard({this.paySELECTED});
  @override
  _CreditCardState createState() => _CreditCardState(paySELECTED);
}

class _CreditCardState extends State<CreditCard> {
  String paySELECTED;
_CreditCardState(this.paySELECTED);
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cvvCodeController = TextEditingController();
  var maskFormatterNumber;
  var maskFormatterExpiryDate;
  var maskFormatterCvv;
  bool cvv = false;

  @override
  void initState() {
    print(paySELECTED);
    
    super.initState();
    maskFormatterNumber = MaskTextInputFormatter(mask: '#### #### #### ####');
    maskFormatterExpiryDate = MaskTextInputFormatter(mask: '##/####');
    maskFormatterCvv = MaskTextInputFormatter(mask: '###');
    // _expiryDateController = MaskedTextController(mask: '00/00');
    // _cardHolderNameController = TextEditingController();
    // _cvvCodeController = MaskedTextController(mask: '0000');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "PAYMENT",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),

        actions: [

              InkWell(
                onTap: (){
                    Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                              onFinish: (number) async {

                                // payment done
                                print('order id: '+number);

                              },
                            ),
                          ),
                        );
                },
                child: Center(child: Text('Paypal',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))),
                SizedBox(width: 15,),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _creditCradWidget(),
            Container(height: 10.0),
            _cardNumber(),
            Container(height: 10.0),
            _expiryDate(),
            Container(height: 10.0),
            _cvvNumber(),
            Container(height: 10.0),
            _cardHolderNmae(),
            _payNow(),
          ],
        ),
      ),
    );
  }

  Widget _creditCradWidget() {
    return StreamBuilder<String>(
        stream: creditCardBloc.numberStream,
        initialData: "",
        builder: (context, number) {
          return StreamBuilder<String>(
              stream: creditCardBloc.expiryDateStream,
              initialData: "",
              builder: (context, expiryDate) {
                return StreamBuilder<String>(
                    stream: creditCardBloc.nameStream,
                    initialData: "",
                    builder: (context, name) {
                      return StreamBuilder<String>(
                          stream: creditCardBloc.cvvStream,
                          initialData: "",
                          builder: (context, cvvNumber) {
                            return CreditCardWidget(
                              cardNumber: number.data,
                              expiryDate: expiryDate.data,
                              cardHolderName: name.data,
                              cvvCode: cvvNumber.data,
                              showBackView:
                                  cvv, //true when you want to show cvv(back) view
                            );
                          });
                    });
              });
        });
  }

  Widget _cardNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _cardNumberController,
        textInputAction: TextInputAction.done,
        inputFormatters: [maskFormatterNumber],
        onChanged: (text) {
          creditCardBloc.numberSink(text);
          // setState(() {});
        },
        onTap: () {
          setState(() {
            cvv = false;
          });
        },
        hintText: "CARD NUMBER",
        keyboardType: TextInputType.number,
        prefixIcon: Icon(Icons.credit_card, color: Colors.blue),
      ),
    );
  }

  Widget _expiryDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _expiryDateController,
        inputFormatters: [maskFormatterExpiryDate],
        textInputAction: TextInputAction.done,
        onChanged: (text) {
          creditCardBloc.expiryDateSink(text);
        },
        onTap: () {
          setState(() {
            cvv = false;
          });
        },
        hintText: "EXPIRY DATE",
        keyboardType: TextInputType.number,
        prefixIcon: Icon(Icons.date_range, color: Colors.blue),
      ),
    );
  }

  Widget _cardHolderNmae() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _cardHolderNameController,
        textInputAction: TextInputAction.done,
        
        onChanged: (text) {
          creditCardBloc.nameSink(text);
        },
        onTap: () {
          setState(() {
            cvv = false;
          });
        },
        hintText: "CARD HOLDER NAME",
        prefixIcon: Icon(Icons.person, color: Colors.blue),
      ),
    );
  }

  Widget _cvvNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _cvvCodeController,
        textInputAction: TextInputAction.done,
        onChanged: (text) {
          creditCardBloc.cvvSink(text);
        },
        onTap: () {
          setState(() {
            cvv = true;
          });
        },
        hintText: "CVV",
        keyboardType: TextInputType.number,
        inputFormatters: [maskFormatterCvv],
        prefixIcon: Icon(Icons.dialpad, color: Colors.blue),
      ),
    );
  }

  Widget _payNow() {
    return Row(
      children: <Widget>[
        Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 0.0,left: 15,right: 15),
            child: SizedBox(
              height: 45,
              // width: 200,
              child: RaisedButton(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Colors.blue,
                child: Text(
                  "NEXT",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () {
                  // print(_cardNumberController.text);
                  // print(_expiryDateController.text);
                  // print(_cardHolderNameController.text);
                  // print(_cvvCodeController.text);
                  
                  
                  String month;
                  String year;
                 bool warning =false;
                  if(maskFormatterExpiryDate.getMaskedText().toString().contains('/') && maskFormatterExpiryDate.getMaskedText().toString().contains('/'))
                  {
                           month = maskFormatterExpiryDate
                                      .getMaskedText()
                                      .toString()
                                      .split("/")[0];
                                   year = maskFormatterExpiryDate
                                      .getMaskedText()
                                      .toString()
                                      .split("/")[1];
                  }
                  else
                  {
                      warning =true;
                           showAlert(
                                        context: context,
                                        title: "Sorry",
                                        content: "Input Expiry Duration");
                  }
                                     
                  if(_cardHolderNameController != null && _cardHolderNameController.text.isNotEmpty)
                    
                  {
              
                                  if (int.parse(month) > 12) {

                                    showAlert(
                                        context: context,
                                        title: "Sorry",
                                        content: "You write invalid input");
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => PaymentInformation(
                                                  pay:paySELECTED,
                                                  number: maskFormatterNumber
                                                      .getUnmaskedText()
                                                      .toString(),
                                                  month: month,
                                                  year: year,
                                                  cvc: maskFormatterCvv.getUnmaskedText().toString(),
                                                  cardHolder: _cardHolderNameController.text,
                                                  
                                                )));
                                  }
                  }
                  else
                  {  if(!warning)
                                   showAlert(
                                        context: context,
                                        title: "Sorry",
                                        content: "All fields are required");
                  }
             
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  showAlert({BuildContext context, String title, String content}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 160,
            ),
            child: Container(
                width: MediaQuery.of(context).size.width - 30,
                // height: MediaQuery.of(context).size.height - 300,
                child: SingleChildScrollView(
                  child: _buildAlertContainer(context, title, content),
                )),
          ),
        ),
      ),
    ),
  );
}

Widget _buildAlertContainer(
    BuildContext context, String title, String content) {
  return Container(
    height: 300,
    width: MediaQuery.of(context).size.width - 100,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        Container(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
        Container(height: 20),
        SizedBox(
          width: 130,
          height: 45,
          child: OutlineButton(
            child: Text("OK"),
            borderSide: BorderSide(color: Colors.black),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
}
