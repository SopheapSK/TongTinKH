
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ton_tin_local/items/Items.dart';
import 'package:ton_tin_local/util/database_helper.dart';
import 'package:ton_tin_local/util/share_pref.dart';

import '../../util/utils.dart';
import 'home_list.dart';

class DetailTongTinPage extends StatefulWidget {
  final TongTinItem tonTin;

  DetailTongTinPage({Key key, this.tonTin}) : super(key: key);

  @override
  _DetailTongTinPageState createState() => _DetailTongTinPageState();
}

class _DetailTongTinPageState extends State<DetailTongTinPage> {
  List<TextEditingController> _controllers = new List();
  TongTinItem tongTinItem;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    if(mounted)
      tongTinItem = widget.tonTin;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((c)=> c.dispose());

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            tongTinItem.title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ],
    );

    final topContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),

      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            _confirmDoneBid(context,tongTinItem);
           // Navigator.pop(context);
          },
          icon: Icon(Icons.cloud_done, color: Colors.white),
        ),
      ),
      Container(
        margin: EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () {
            _confirmDelete(context, 1, widget.tonTin);
          },
          icon: Icon(Icons.delete_forever, color: Colors.white),
        ),
      ),
    ],);



    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [

                  Color(0xFF1b1e44).withOpacity(1),
                  Color(0xFF2d3447).withOpacity(1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Column(
          children: <Widget>[

            SizedBox(
              height: 26.0,
            ),
            topContent,
            topContentText,
            headerInfo(context, tongTinItem),
            Expanded(child: _buildList(context, tongTinItem))
          ],
        ),
      ),
    );
  }

  Widget labelWithText(IconData iconData, String info) {
    final fontX = info.length > 16 ? 13.0 : 15.0;
    return Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                  onPressed: null,
                  disabledColor: Colors.white12,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  color: Colors.white10,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        iconData,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: new Text(
                          info,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontX,
                              fontWeight: FontWeight.normal),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ))
            ]));
  }

  Widget headerInfo(BuildContext context, TongTinItem tongTin) {
    var totalInterest = 0.0;
    var lastMonthInterst = 0.0;
    var listTrack = Utils.listTrackHelper(tongTin.listTrack);
    listTrack.forEach((k, v){
      lastMonthInterst = double.parse( v.toString());
      totalInterest+= lastMonthInterst;
    });
    return Container(

      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      color: Color.fromRGBO(58, 66, 86, 0.0),
      child: new Center(
        child: Column(
          children: <Widget>[


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(
                        Icons.people, 'សរុប ${tongTin.people.toString()} នាក់')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: labelWithText(Icons.monetization_on,
                      '១ក្បាល​: \$${tongTin.amount.toStringAsFixed(2)} '),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(Icons.person,
                        'ដេញហើយ ${Utils.listTrackHelper(tongTin.listTrack).length} ក្បាល')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                    child: labelWithText(Icons.date_range,
                        'ថ្ងៃលេង ${Utils.dateConvert(tongTin.startOn)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: labelWithText(Icons.monetization_on, 'ការសរុប \$ ${totalInterest.toStringAsFixed(2)}')),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                    child: labelWithText(Icons.monetization_on,
                        'ការខែមុន \$${lastMonthInterst.toStringAsFixed(2)}')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, TongTinItem tongTin) {
    List<String> list = new List();
    for (var i = 0; i < tongTin.people; i++) {
      list.add('${i + 1}');
    }

    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          var isCurrentMonth = Utils.isDateMatch(Utils.addMonth(tongTin.startOn, index));
          return makeListItem(context, index, list[index], tongTin, isCurrentMonth);
        },
      ),
    );
  }

  Widget makeListItem(BuildContext context, int index, String info, TongTinItem tongTin, bool isCurrentMonth) {
    return Container(
        color: isCurrentMonth ? Color.fromRGBO(58, 66, 86, 0.9) : index % 2 == 0 ? Color.fromRGBO(58, 66, 86, .1)  : Color.fromRGBO(58, 66, 86, .4) ,
        child: makeListTile(context,index,  info, tongTin));
  }

  ListTile makeListTile(BuildContext context, int index, String info, TongTinItem tongTin) {

    var listTrack = Utils.listTrackHelper(tongTin.listTrack);

    var isInterestAvailable = listTrack.containsKey('month$index');
    var interest = isInterestAvailable ? listTrack['month$index']??0.00.toStringAsFixed(2) : ' N/A';
    var amountToPay = isInterestAvailable ? (tongTin.amount - ( listTrack['month$index']??0.0)).toStringAsFixed(2) : ' N/A';
    if(tongTin.isDead) {
      if (index >= tongTin.listTrack.length) {
        amountToPay = tongTin.amount.toStringAsFixed(2);
        interest = '0.00';
      }
    }

    _controllers.add(new TextEditingController());
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      leading: Container(
        padding: EdgeInsets.only(right: 8.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Text('$info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      title: Text(
        'ខែ ${Utils.addMonth(tongTin.startOn, index).substring(3)}',
        style: TextStyle(color: Colors.lightBlue, fontSize: 12.0, fontWeight: FontWeight.normal),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: Text(
                    ' ការ​: \$$interest \n ដេញហើយ $info/${tongTin.people} នាក់. \n បង់លុយ: \$ $amountToPay',
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing: IconButton(
          onPressed: ()=> _showBottomSheet(context, index, tongTin)
          , icon: Icon(Icons.edit, color: Colors.white, size: 20.0)),

      onLongPress: () {
       // print('tap for more');
        _confirmRemoveInterest(context, index, tongTin);

      },
    );


  }

  void _showBottomSheet(BuildContext context, int index, TongTinItem tongTin){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('ការប្រាក់សម្រាប់ខែទី ${index + 1}', style: TextStyle(color: Colors.white),)

                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0),
                      child: new TextField(

                        keyboardType: TextInputType.number,
                        controller: _controllers[index],
                        style:  TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.attach_money, size: 14.0, color: Colors.white,),
                          hintText: '(ex: 12.5\$ ) ',
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(width: 1,color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                        ),


                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    _buttonSubmit(context,index, tongTin),


                    SizedBox(height: 32),


                  ],
                ),
              ),
            ),
          );
        });
  }
  Widget _buttonBid( BuildContext context, TongTinItem tonTin){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/create');
              updateDoneBid(tonTin);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Colors.blueAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.cloud_done,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t យល់ព្រម  \t  \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
  Widget _buttonSubmit( BuildContext context,int index,TongTinItem tongTin){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              updateData(index, tongTin);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Colors.blueAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.donut_large,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  ' \t យល់ព្រម \t \t \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }

  Widget _buttonDeleteInterest( BuildContext context,int index, TongTinItem tongTin){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              // Navigator.pushNamed(context, '/create');
              updateRemoveInterest(index, tongTin);
              Navigator.pop(context);

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color(0xFFff6e6e),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.delete_sweep,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t យល់ព្រម \t \t \t \t \t ' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }
  Widget _buttonDeleteTongTin( BuildContext context,int index, TongTinItem tongTin){
    return new Center(
        child: new RaisedButton(
            onPressed: () async {
              deleteThisTongTin(tongTin);
              Navigator.pop(context);

            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color(0xFFff6e6e),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 24.0,
                ),
                SizedBox(
                  width: 16.0,
                ),
                new Text(
                  '\t \t យល់ព្រម \t  \t \t \t \t' ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )));
  }


  void deleteThisTongTin(TongTinItem tongTin){
    print('start Delete');

    var dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      var result = databaseHelper.deleteTongTin(tongTin.id);

      result.then((res) {
        SharedPreferences.getInstance().then((sharePref){
          var isDesc = sharePref.getBool(PrefUtil.KEY_SORT_DECS);
          if(isDesc == null) isDesc = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>ListPage(title : 'Persona ', isDecs: isDesc,)));
        });
      });
    });





  }

  void updateData( int index, TongTinItem tongTin){
    String interest = _controllers[index].text;
    print('$index=> interst $interest');
    if(interest.isEmpty) return;

    var listTrack = Utils.listTrackHelper(tongTin.listTrack);


    listTrack['month$index'] = double.parse(interest);


    tongTin.listTrack = Utils.listTrackMapToString(listTrack);


    setState(() {
      tongTinItem = tongTin;

    });

    var dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      var result = databaseHelper.updateTongTin(tongTin);

      result.then((res) {
        setState(() {
          print('inserr data : $res');
        });
      });
    });

  }
  void updateDoneBid( TongTinItem tongTin){
    tongTin.isDead = !tongTin.isDead;
    setState(() {
      tongTinItem = tongTin;
    });

    var dbFuture = databaseHelper.initializeDatabase();

    dbFuture.then((database) {
      var result = databaseHelper.updateTongTin(tongTin);

      result.then((res) {
        setState(() {
          print('inserr data : $res');
        });
      });
    });
  }
  void updateRemoveInterest( int index, TongTinItem tonTin){
    
    var listTrack = Utils.listTrackHelper(tonTin.listTrack);

    if(listTrack.containsKey('month$index')){
      listTrack.remove('month$index');
      tonTin.listTrack = Utils.listTrackMapToString(listTrack);
      setState(() {
        tongTinItem = tonTin;
      });

      var dbFuture = databaseHelper.initializeDatabase();

      dbFuture.then((database) {
        var result = databaseHelper.updateTongTin(tonTin);

        result.then((res) {
          setState(() {
            print('inserr data : $res');
          });
        });
      });

    }



  }

  void _confirmDelete(BuildContext context, int index, TongTinItem tongTin){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('លុបតុងទីននេះចោល?', style: TextStyle(color: Colors.white),)

                  ),
                  SizedBox(height: 10),
                  _buttonDeleteTongTin(context, index, tongTin),
                  SizedBox(height: 10),

                ],
              ),
            ),
          );
        });
  }
  void _confirmDoneBid(BuildContext context, TongTinItem tt){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('បើអ្នកដេញរួចហើយ សុមចុចប៊ូតុង យល់ព្រម ខាងក្រោមនេះ',style: TextStyle(color: Colors.white),)

                  ),
                  SizedBox(height: 10.0),
                  _buttonBid(context, tt),
                  SizedBox(height: 10.0),

                ],
              ),
            ),
          );
        });
  }
  void _confirmRemoveInterest(BuildContext context, int index, TongTinItem tongTin){

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),

                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('លុបការប្រាក់សម្រាប់ខែទី ${index + 1} ចោល?', style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(height: 10.0),
                  _buttonDeleteInterest(context, index, tongTin),
                  SizedBox(height: 10.0),

                ],
              ),
            ),
          );
        });
  }
}

