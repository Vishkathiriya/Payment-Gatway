import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CreditCardBloc {
  final _numberController = PublishSubject<String>();
  final _expiryDateController = PublishSubject<String>();
  final _nameController = PublishSubject<String>();
  final _cvvController = PublishSubject<String>();

  Observable<String> get numberStream => _numberController.stream;
  Observable<String> get expiryDateStream => _expiryDateController.stream;
  Observable<String> get nameStream => _nameController.stream;
  Observable<String> get cvvStream => _cvvController.stream;

  numberSink(String number) {
    _numberController.sink.add(number);
  }

  expiryDateSink(String number) {
    _expiryDateController.sink.add(number);
  }

  nameSink(String name) {
    _nameController.sink.add(name);
  }
  
  cvvSink(String cvv) {
    _cvvController.sink.add(cvv);
  }

  dispose() {
    _numberController.close();
    _expiryDateController.close();
    _nameController.close();
    _cvvController.close();
  }
}

final creditCardBloc = CreditCardBloc();
