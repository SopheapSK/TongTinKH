
class TongTinItem {
  int id;
  String title;
  int createOn;
  int startOn;
  int people;
  int paidMonth;
  double amount;
  double interest;
  String listTrack;
  bool isDead;

  TongTinItem(
      { this.id, this.people, this.paidMonth, this.createOn, this.startOn, this.title , this.interest, this.listTrack, this.isDead, this.amount});

  TongTinItem.fromMap(Map<String, dynamic> snapshot)
      :
        id =  snapshot['id'] ?? 0,
        paidMonth = snapshot['paidmonth'] ?? 0,
        createOn = snapshot['createon'] ??  0,
        startOn = snapshot['starton'] ??  0,
        title = snapshot['title'] ?? '',

        isDead = snapshot['isdead'] != null ?? false,
        listTrack = snapshot['listtrack'] ?? '',
        people  = snapshot['people'] ?? 0,
        amount = snapshot['amount'] ??  0.0,
        interest =  snapshot['interest'] ?? 0.0;




  toJson() {
    return {
      "totalPeople" : people,
      "amount": amount,
      "interest": interest,
      "createOn" : createOn,
      "startOn" : startOn,
      "title" :title,

      "listtrack" : listTrack,
      "isDead" : isDead

    };
  }

  Map<String, dynamic> toMap() {



    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['people'] = people;
    map['amount'] = amount;
    map['createon'] = createOn;
    map['starton'] = startOn;
    map['title'] = title;
    map['isdead'] = isDead ?? false;
    map['listtrack'] = listTrack ?? '';
    map['interest'] = interest ?? 0.0;



    return map;

  }

}