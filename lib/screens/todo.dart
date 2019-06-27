import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter_app/widgets/round_corner_bottom_sheet.dart';

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> with SingleTickerProviderStateMixin{
  List<String> _todoItems = [];
  List<String> _completedItems = [];
  bool _showToDoList = true;
  bool check = false;
  AssetImage image1;

  int selectedTabIndex = 2;
  AnimationController _controller;
  Animation<Offset> _animation;
  Animation<double> _fadeAnimation;

  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if(task.length > 0) {
      // Putting our code inside "setState" tells the app that our state has changed, and
      // it will automatically re-render the list
      setState(() => _todoItems.add(task));
    }
  }

  @override
  void initState() {
    image1 = AssetImage('assets/images/1271.png');
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<Offset>(begin: Offset(0,0), end: Offset(0,0)).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _modalBottomSheetMenu(){
    showRoundedModalBottomSheet(
        context: context,
        radius: 15.0,  // This is the default
        color: Colors.white,
        builder: (builder){
          return new Container(
            height: 125.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0))
              ),
              child: Padding (
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodoItem(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'New Task',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                  )
              ),
            ),
          );
        }
    );
  }

  void _removeTodoItem(int index) {
    _completedItems.add(_todoItems[index]);
    setState(() => _todoItems.removeAt(index));
  }

  _promptRemoveCompletedItem() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Permanently delete ${_completedItems.length} completed tasks?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Cancel'),
                    textColor: Colors.blueAccent,
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () {
                      Navigator.of(context).pop();
                      check = false;
                      return false;
                    }),
                new FlatButton(
                    child: new Text('Delete'),
                    textColor: Colors.blueAccent,
                    onPressed: () {
                      setState(() {
                        _completedItems.clear();
                      });
                      Navigator.of(context).pop();
                      check = true;
                      return true;
                    }
                )
              ]);
        }
    );
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.white,
      ),
    );
  }


  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(
        color: Colors.transparent,
          width: 2.3,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(15.0) //         <--- border radius here
      ),
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new Dismissible(
      onDismissed: (direction) =>  _removeTodoItem(index),
        key: new Key(_todoItems[index]),
        child: new Container(
            padding: const EdgeInsets.all(10.0),
            decoration: myBoxDecoration(),
            child: new ListTile(
              dense: true,
              leading: IconButton(
                icon: Icon(Icons.panorama_fish_eye),
                onPressed: () {
                  setState(() {
                    _removeTodoItem(index);
                  }
                  );
                },
              ),
              title: new Text(todoText,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                ),),
            )
        )
    );
  }

  playAnimation() {
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
            'My Tasks',
            style: TextStyle(
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.w500,
            )
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Container (
                width: 370,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.pink[100].withOpacity(0.8),
                       // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Center (
                      child:
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        child: Image(
                          width: 370,
                          image: image1,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 130,
                        child: Align(
                          alignment: FractionalOffset(0.17, 0.3),
                          child:
                          Text('Focus on the task\nat hand',
                            style: TextStyle(
                              color: Colors.deepPurple[600],
                              fontSize: 22,
                              fontFamily: 'Product Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: new Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 85,
                    width: 370,
                    child: new ListTile(
                      dense: true,
                      leading: IconButton(
                        icon: Icon(Icons.check_circle_outline),
                        color: Colors.deepPurple[400],
                        onPressed: () {
                        },
                      ),
                      title: new Text('Completed Tasks ',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple[400],
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      subtitle: new Text(
                          _completedItems.length.toString(),
                        style: TextStyle(
                          color: Colors.deepPurple[300],
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0) //         <--- border radius here
                      ),
                    ),
                  )
              )
            ],
          ),
          new Expanded(
              child:
              _buildTodoList(),
          ),
        ],
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add a task'),
        onPressed: _modalBottomSheetMenu,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showMenu();
              },
            ),
            IconButton(
              icon: Icon(Icons.menu,
              color: Colors.white,),
              splashColor: Colors.transparent,
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showMore();
              },
            ),
          ],
        ),
      ),
    );
  }

  showMenu() {
    showRoundedModalBottomSheet(
        radius: 15.0,
        context: context,
        builder: (context) {
          return RoundConnerBototmSheet(Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.account_circle),
                  ),
                  title: Text(
                    'Kenny Chan',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  subtitle: Text(
                    'hoiyat0210@gmail.com',
                    style: TextStyle(color:  Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      margin:
                      EdgeInsets.only(right: 16.0, top: 16.0, bottom: 16.0),
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        ' My Task',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(23.0),
                            bottomRight: Radius.circular(23.0)
                          //         <--- border radius here
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
                ListTile(
                  leading: Icon(Icons.add, color:  Colors.black,),
                  title: Text(
                    'Create new list',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
              ],
            ),
          ));
        });
  }

  showMore() {
    showRoundedModalBottomSheet(
        context: context,
        radius: 15,
        builder: (context) {
          return RoundConnerBototmSheet(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Sort by',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.black87),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'My order',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      Icon(Icons.check)
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black26,
                height: 1.0,
              ),
              FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Rename list',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black87),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )),
              FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Delete list',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black87),
                        textAlign: TextAlign.start,
                      )
                    ],
                  )),
              FlatButton(
                  onPressed: () {
                    _promptRemoveCompletedItem();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Delete all completed tasks',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black87),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ))
            ],
          ));
        });
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text('Add a new task')
                  ),
                  body: new TextField(
                    autofocus: true,
                    onSubmitted: (val) {
                      _addTodoItem(val);
                      Navigator.pop(context); // Close the add todo screen
                    },
                    decoration: new InputDecoration(
                        hintText: 'Enter something to do...',
                        contentPadding: const EdgeInsets.all(16.0)
                    ),
                  )
              );
            }
        )
    );
  }
}