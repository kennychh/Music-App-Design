class Note {

  int _id;
  String _title;
  String _description;
  String _date;

  Note(this._title, this._date, [this._description]);

  Note.widthId(this._title, this._date, [this._description]);

  int get id => _id;

  String get title => _title;

  String get date => _date;

  String get description => _description;


  set title(String newTitle) {
    this._title = newTitle;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set description(String newDescription) {
    this._description= newDescription;
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['date'] = _date;
    map['description'] = _description;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {

    this._id = map['id'] ;
    this._title = map['title'];
    this._date = map['date'];
    this._description = map['description'];
  }
}
