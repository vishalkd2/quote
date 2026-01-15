import 'package:flutter/material.dart';
import 'package:quote/model/quote_model.dart';
import 'package:quote/services/quote_service.dart';

class QuoteProvider extends ChangeNotifier{
   final QuoteService _service=QuoteService();
   List<QuoteModel> quote=[];
   QuoteModel? randomQuote;
   bool isLoading=false;
   bool isRadomLoading=false;
   String? error;
   String? randomeError;
   String? imageKey = DateTime.now().millisecondsSinceEpoch.toString();
   //Initial load or refresh
Future<void> fetchQuotes({bool isRefresh=false})async{
  if(isLoading)return;

  isLoading=true;
  error=null;
  if(isRefresh)notifyListeners();

  try{
    final result=await _service.getQuotes();
    quote=result!;
  }catch(e){
    if(e.toString().contains('SocketException')){
      error="NO_INTERNET";
    }else{
      error="Something went wrong";
    }
    isLoading=false;
    notifyListeners();
  }
  finally {isLoading = false;notifyListeners();}

}
//Generate Random Quote
Future<void> fetchRandomQuote()async{
  if(isRadomLoading)return;
  isRadomLoading =true;
  randomeError=null;
  notifyListeners();
  try{
    final result = await _service.generateRandomQuote();
    if(result!=null && result.isNotEmpty){
      randomQuote=result.first;
    }
  }catch(e){randomeError='Failed to  load quote';}finally{isRadomLoading=false;notifyListeners();}

}

//Generate Random Image
void refreshImage(){
  imageKey=DateTime.now().millisecondsSinceEpoch.toString();
  notifyListeners();
}

}