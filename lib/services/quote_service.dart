

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'as http;
import 'package:quote/model/quote_model.dart';
class QuoteService{
  final String _baseUrl=dotenv.get('BASE_URL');
  final String _quoteOfDayUrl=dotenv.get('QUOTE_OF_THE_DAY_URL');
  final String _generateRandomQuote=dotenv.get('GENERATE_RANDOM_QUOTE');

  Future<List<QuoteModel>?> getQuotes()async{
    try{
      final response = await http.get(Uri.parse(_baseUrl));
      if(response.statusCode==200){
        List<dynamic> json = jsonDecode(response.body);
        return json.map((data)=>QuoteModel.fromJson(data)).toList();
      }
    }catch(e){throw Exception(e);}
  }

  Future<List<QuoteModel>?> quoteOfTheDay()async{
    try{
        final response = await http.get(Uri.parse(_quoteOfDayUrl));
        if(response.statusCode==200){
          List<dynamic> json =jsonDecode(response.body);
          return json.map((data)=>QuoteModel.fromJson(data)).toList();
        }
    }catch(e){print("Error in QuoteService>quoteOfTheDay:$e");}
  }

  Future<List<QuoteModel>?> generateRandomQuote()async{
    try{
      final response=await http.get(Uri.parse(_generateRandomQuote));
      if(response.statusCode==200){
        List<dynamic> json = jsonDecode(response.body);
        return json.map((data)=>QuoteModel.fromJson(data)).toList();
      }
    }catch(e){print("Error in QuoteService>generateRandomQuote:$e");}
  }

}