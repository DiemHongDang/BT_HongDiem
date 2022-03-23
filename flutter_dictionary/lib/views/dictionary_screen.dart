import 'package:flutter/material.dart';
import 'package:flutter_dictionary/databases/dictionary_database.dart';
import 'package:flutter_dictionary/models/word_model.dart';
import 'package:flutter_dictionary/resources/strings.dart';
import 'package:flutter_dictionary/resources/themes.dart';
import 'package:flutter_dictionary/resources/utils/dismiss_keyboard.dart';
import 'package:flutter_dictionary/resources/utils/meaning_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {

  TextEditingController? searchController ;
  final db = DictionaryDatabase();

  //TTS
  FlutterTts? flutterTts ;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool us_voice = true;

  Future<List<WordModel>>? searchResultsFuture;
  int hintWordsLength = 0;
  WordModel? wordModel ;
  String meaning ='';
  String? wordSearch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    initTts();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController!.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _searchWordItem(),
        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      _showMeaning()
                    ],
                  ),
                ),

              ],
            ),
          ),

        )

    );

  }

  _showMeaning(){
    return Stack(
      children: [
        Container(
          child: Column(
            children: [

              wordModel !=null ? Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),


                    ],
                  ),

                  //height: 85,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(wordSearch==null? "Nhập từ cần tra": wordSearch!,
                              style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),

                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(

                                children: [
                                  wordSearch !="" ? IconButton(
                                      icon: Icon( Icons.volume_up,
                                        size: 30,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {

                                        if (wordSearch != null) {
                                          if (wordSearch!.isNotEmpty) {
                                            await flutterTts!.speak(wordSearch!);
                                          }

                                        }


                                      }): Container(),

                                ],

                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ) : Container(),
              // horizontal_line(context),
              wordModel !=null ?
              Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.4),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),

                        ],
                      ),
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: formatResultWidget(wordModel!.meaning!, wordSearch!)
                    //child: Text(wordModel.meaning),

                  ),
                ],
              ):
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),


                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                        padding: EdgeInsets.all(5),
                        child: Text(
                          SEARCH_GUIDE,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      //horizontal_line(context),
                      Container(
                        padding: EdgeInsets.only(left: 5, top: 10, bottom: 40),
                        child: Text(
                          meaning,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontFamily: AppTheme.fontName
                          ),

                        ),
                      )
                    ],
                  )
              ),


            ],
          ),
        ),


        (searchResultsFuture !=null && searchResultsFuture !=0 ) ?
        Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 5),

          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
              color: Colors.blue
          ),
          height: hintWordsLength * 50.0 ,
          child: buildSearchResult(),
        ) : Container(),
      ],
    );
  }

  buildSearchResult(){
    return FutureBuilder<List<WordModel>>(
      future: searchResultsFuture,
      builder: (context, snapshot)
      {
        if(!snapshot.hasData) { return Container(); }
        List<WordModel> searchWords = [];
        snapshot.data!.forEach(
                (word){
              searchWords.add(word);
            }
        );
        return ListView.builder(
          itemCount: searchWords.length,
          itemBuilder: (context, index)
          {
            return GestureDetector(
              child: Container(
                height: 50,
                padding: EdgeInsets.all(8),
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        searchWords[index].word!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: AppTheme.fontName
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                    //horizontal_line(context)
                  ],
                ),
              ),
              onTap: (){
                KeyBoard().off(context);
                searchController!.clear();
                setState(() {
                  // searchResultsFuture = null;
                  wordSearch = searchWords[index].word;
                  wordModel = searchWords[index];
                  meaning = searchWords[index].meaning!;
                  searchResultsFuture = null;
                  hintWordsLength = 0;
                });

              },
            );
          },


        );
      },
    );

  }

  AppBar _searchWordItem()
  {
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search,
            color: Colors.white,),
          onPressed: () {
            if(searchController!.text.isNotEmpty)
            {
              fetchWordSearch(searchController!.text);
              searchController!.clear();
            }

          },
        ),
        IconButton(
          icon: Icon(Icons.clear,
            color: Colors.white,
          ),
          onPressed: clearSearch,
        ),
      ],
      title: Column(
        children: [
          Container(
            // padding: EdgeInsets.only( right: 10, top: 10),
            //margin: EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: searchController,
              cursorColor: Colors.white,
              cursorWidth: 3,
              decoration: InputDecoration.collapsed(
                  hintText: SEARCH_HINT,
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )

              ),

              onChanged: handlesearch,
              onFieldSubmitted: handleSearchOnSubmitted,
              style: TextStyle(color: Colors.white,
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              // onFieldSubmitted: handlesearch,

            ),
          ),
        ],
      ),
    );

  }

  handleSearchOnSubmitted(String searchWord) async
  {
    KeyBoard().off(context);
    searchController!.clear();
    if(searchWord.isNotEmpty){
      Future<List<WordModel>> words = db.searchEnglishResults(searchWord) ;
      wordModel = await db.fetchWordByWord(searchWord);
      wordSearch = searchWord;

      String word = "";
      if(wordModel == null){
        word = WORD_NOT_AVAILABLE;
      }else {
        word = wordModel!.meaning!;
      }
      setState(()  {
        wordSearch = searchWord;
        meaning = word;
        searchResultsFuture = null;
        hintWordsLength = 0;
      });
    }
  }

  handlesearch(String searchWord) async
  {
    Future<List<WordModel>> words = db.searchEnglishResults(searchWord) ;
    List<WordModel> list= await words;

    setState(()  {
      if(list.length>0)
      {
        searchResultsFuture = words ;
        hintWordsLength = list.length;
      }
      else{
        searchResultsFuture = null;
        hintWordsLength = 0;
      }
      if(searchController!.text.isEmpty) {
        searchResultsFuture = null;
        hintWordsLength = 0;
      }
    });
  }


  clearSearch()
  {
    searchController!.clear();
    setState(() {
      searchResultsFuture = null;
      hintWordsLength = 0;
    });
    KeyBoard().off(context);
  }

  fetchWordSearch(String string) async {

    setState(() {
      searchResultsFuture = null;
    });
    wordModel = await db.fetchWordByWord(string);

    String word = "";
    if(wordModel == null){
      word = WORD_NOT_AVAILABLE ;
    }else {
      word = wordModel!.meaning!;

    }

    setState(()  {
      wordSearch = string;
      meaning = word;
      hintWordsLength = 0;
    });


  }


  initTts()async {

    flutterTts = FlutterTts();
    await flutterTts!.setVolume(volume);
    await flutterTts!.setSpeechRate(rate);
    await flutterTts!.setPitch(pitch);
    await flutterTts!.setLanguage("en-US");
  }

}
