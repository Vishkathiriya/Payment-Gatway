import 'package:rxdart/rxdart.dart';

class Bloc {
  
  PublishSubject<bool> loading = PublishSubject<bool>(); 

  
  Observable<bool> get loadingSTREAM => loading.stream;

  lodingSINK(bool yn)
{
    loading.add(yn);
}


  despose() {
    
    loading.close();
    
  }
}

final blocdata = Bloc();