
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stripe_demo/bloc/bloc.dart';
import 'package:stripe_demo/stripe/apply_charges.dart';
import 'package:stripe_demo/stripe/create_customer.dart';
import 'package:stripe_demo/stripe/get_token_api.dart';

class PaymentInformation extends StatefulWidget {

  final String pay;
  final String number;
  final String month;
  final String year;
  final String cvc;
  final String cardHolder;

  PaymentInformation(
      {
      this.pay,  
      this.number,
      this.month,
      this.year,
      this.cvc,
      this.cardHolder,
      });
  @override
  _PaymentInformationState createState() => _PaymentInformationState(pay,
      number, month, year, cvc, cardHolder);
}

class _PaymentInformationState extends State<PaymentInformation> {

  GlobalKey _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldsKey = GlobalKey<ScaffoldState>(); 
  final String pay;
  final String number;
  final String month;
  final String year;
  final String cvc;
  final String cardHolder;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  // final Map userData;
  _PaymentInformationState(this.pay,this.number,
      this.month, this.year, this.cvc, this.cardHolder);
  
  File _imageFile;
  int flag =0;
  TextEditingController _amount = TextEditingController();
  @override
  void initState() {
    
    super.initState();
    _amount.text = '40';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          
          backgroundColor: Colors.white,
          appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        "PAYMENT INFORMATION",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context)),
      centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
        child: Column(
              children: <Widget>[
                
                _buildTitle("PAYABLE AMOUNT"),
                _payNow(context),
         
              ],
        )),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Center(
            child: StreamBuilder<bool>(
              stream: blocdata.loadingSTREAM,
              initialData: false,
              builder: (context, snapshot) {
                return snapshot.data ?
                 SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator()) : SizedBox();
              }
            ),
          )
        ],)
            ],
          )
          
          
        );
  }

  Widget _buildTitle(String title) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width: 15,),
          Expanded(
                        child: Text(
              title,
              style: TextStyle(
                  color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: amount()),
          SizedBox(width: 2,),
          Text('\$',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
          SizedBox(width: 15,)
        ],
      ),
    );
  }
  Widget _payNow(BuildContext contextss) {
    return Row(
      children: <Widget>[
        Expanded(
                  child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 0.0,left: 15,right: 15),
            child: SizedBox(
              height: 45,
              // width: 200,
              child: RaisedButton(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Colors.blue,
                child: Text(
                  "PAY NOW",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () {
                  if(_amount.text.isNotEmpty)
                 blocdata.lodingSINK(true);
                  // if (classDetails != null) {
                    String amount = _amount.text;
                    print(double.parse(amount));
                    // classDetails.classPrice;
                    String totalAmount = "${int.parse(amount) * 100}";
                    getCardToken
                        .getCardToken(number, month, year, cvc,
                            cardHolder, context)
                        .then((onValue) {
                      print(onValue["id"]);
                      createCutomer
                          .createCutomer(
                              onValue["id"], cardHolder, context)
                          .then((cust) {
                        print(cust["id"]);
                        applyCharges
                            .applyCharges(
                          cust["id"],
                          context,
                          totalAmount,
                        )
                            .then((_) {
  
                            blocdata.lodingSINK(false);  
                            customAlert(context: context,title: 'Payment Verification',content: 'payment has been done',flag: 0,ontap: (){
                                          Navigator.pop(context);//contextss
                                          Navigator.pop(contextss);
                                        
         
                                    });
                });
                          
                        });
                      });

                },
              ),
            ),
          ),
        ),


      ],
    );
  }
  Widget download()
  {
    return  Row(
      children: <Widget>[
        Expanded(
                      child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 0.0,left: 15,right: 15),
                child: SizedBox(
                  height: 45,
                  // width: 200,
                  child: RaisedButton(
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.blue,
                    child: Text(
                      "DOWNLOAD NOW",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    onPressed: () {
             
                                  },
                  ),
                ),
              ),
            ),
      ],
    );
  }



  customAlert({BuildContext context,String title,String content,int flag,Function ontap})
{
  return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 140,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0,left: 12.0,right: 12.0,bottom: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                  topwidget(title, content),
                  // flag == 1 ?  Icon(Icons.check_circle_outline,size: 65,color: Colors.green,) : flag == 2 ? Icon(Icons.account_balance,size: 65,color: Colors.red,) : Icon(Icons.remove_circle_outline,size: 65,color: Colors.red,),
                  flag == 0 ? SizedBox(
                          width: 320.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            onPressed: ontap,
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                        ) :

                        Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  // height: 45,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    child: Text('CANCEL',style: TextStyle(color: Colors.white),),
                    onPressed: ontap,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                  // height: 45,
                                child: RaisedButton(
                    color: Colors.blue,              
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),              
                    child: Text('CONFIRM',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      
                    },
                  ),
                ),
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
    });
}

Widget topwidget(String title,String content,)
{
  return Column(
    children: <Widget>[
         Center(child: Text('$title'),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text('$content',textAlign: TextAlign.center,)),
                    ),
    ],
  );
}

    amount()
  {
    return Container(
        // width: MediaQuery.of(context).size.width /2.15,
        // color: Colors.grey,
        height: 50,
        child: TextField(
              textInputAction: TextInputAction.done,
              controller: _amount,
              autocorrect: false,
              keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
              inputFormatters: [
       
            LengthLimitingTextInputFormatter(10),
             WhitelistingTextInputFormatter.digitsOnly
          ],
              onTap: () {
              
              },
              onChanged: (text){
                
                
              },
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                
                  hintText: '0.0',
                
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.transparent,
                  ))),
              textAlign: TextAlign.right,
            ),
      );
  }
}
