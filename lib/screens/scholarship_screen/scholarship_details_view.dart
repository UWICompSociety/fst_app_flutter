import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fst_app_flutter/models/preferences/theme_model.dart';
import 'package:fst_app_flutter/models/from_postgres/scholarship/scholarship.dart';
import 'package:clipboard/clipboard.dart';

class ScholarshipDetailsView extends StatelessWidget {

  final Scholarship current;
  final Map<String, dynamic> theme = {'isDark': null, 'theme': null, 'context': null};

  ScholarshipDetailsView({this.current});
  //TODO documentation  @palmer-matthew
  Widget _buildAppBar(){
    return AppBar(
        title: Text(
          current.name,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.content_copy), 
            onPressed: (){
              FlutterClipboard.copy(current.toString()).then(
                ( value ) => _showDialog(false),
                onError: (error) => _showDialog(true),
              );
            },
            tooltip: "Copy to Clipboard",
          )
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          tabs: [
            _buildTab('Description'),
            _buildTab('Details'),
          ],
        ),
      );
  }

  Tab _buildTab(String text){
    return Tab(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildPage(String zone){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: zone == "Description" ? buildDescriptionContent() : buildDetailContent(),
      ),
    );
  }

  Widget buildListTile(String title, content, bool inList){
    
    if(content == "" && inList){
      return UnorderedListItem(title, theme['isDark']);
    }else if(content is! String){
      return ListTile(
        title: Text(
          title,
        ),
        subtitle: content,
      );
    }

    return ListTile(
      visualDensity: VisualDensity(vertical: -2.0, horizontal: 1.0),
      title: Text(
          title,
        ),
      subtitle: Text(
          content,
        ),
    );
  }

  Widget buildDivider(){
    return Divider(
      //color: theme['isDark'] ? Colors.white30 : Colors.black12,
    );
  }

  Widget buildListingTile(title, content){
    List<Widget> secondaryWidgets = List.empty(growable: true);
    List<String> secondary;

    try {
      if(content.contains(":")){
        List<String> list = content.split(":");
        if(list[1].contains(";") && list.length == 2){
          secondary = list[1].split(";");
          for(String b in secondary){
            if(b != ""){
              secondaryWidgets.add(buildListTile(b, "", true));
              secondaryWidgets.add(SizedBox(height: 5));
            }
          }
          secondaryWidgets.add(SizedBox(height:10));
          return ListBody(
            children: [
              buildListTile(title, list[0]+":", false), 
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  children: secondaryWidgets,
                ),
              ),
            ],
          );
        }else if(list[1].contains(";") && list.length == 3){
          secondary = list[1].split(";");
          for(String b in secondary){
            if(b != ""){
              secondaryWidgets.add(buildListTile(b, "", true));
            }
          }
          return buildListTile(
            title,
            Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: ListBody(
              children: [
                buildListTile(list[0], "", true),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: ListBody(
                    children: secondaryWidgets,
                  ),
                ),
                SizedBox(height: 10.0),
                buildListTile(list[2], "", true),
              ],
            ),
          ),false);
        }else if(list.length == 2 && !list[1].contains(";")){
          return ListBody(
            children: [
              buildListTile(title, list[0]+":", false),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  children: [buildListTile(list[1], "", true), SizedBox(height: 10)],
                ),
              ),
            ],
          );
        }else {
          return buildListTile(title, list[1], false);
        }
      }else if(content.contains(";")){
        List<String> list = content.split(";");
        for(String b in list){
          if(b != ""){
            secondaryWidgets.add(buildListTile(b, "", true));
          }
        }
        return buildListTile(
          title, 
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: ListBody(
              children: secondaryWidgets,
            ),
          ), false);
      }else{
        return buildListTile(title, content, false);
      }
    } on Exception catch (e) {
      print(e);
      return Center(child: Text(title));
    }

  }

  List<Widget> buildDescriptionContent(){
    List<Widget> result = List.empty(growable: true);
    try{
     
      if(current.numAwards != ""){
        result.addAll([buildListTile('Number of Awards', current.numAwards, false), buildDivider()]);
      }

      if(current.value != ""){
        result.addAll([buildListTile('Value', current.value, false), buildDivider()]);
      }

      if(current.tenure != ""){
        result.addAll([buildListTile('Maximum Tenure', current.tenure , false), buildDivider()]);
      }

      if(current.eligible != ""){
        result.add(buildListingTile("Eligibility", current.eligible));
      }

    }on Exception catch(e){
      print(e);
      result = <Widget>[Center(child: Text("Something went wrong")),];
    }
    return result;
  }

  List<Widget> buildDetailContent(){
    List<Widget> result = List.empty(growable: true);

    try{

      if(current.criteria != ""){
        result.addAll([buildListingTile("Criteria", current.criteria), buildDivider()]);
      }

      if(current.method != ""){
        result.addAll([buildListingTile("Method Of Selection", current.method), buildDivider()]);
      }

      if(current.special != ""){
        result.addAll([buildListingTile("Special Requirements", current.special), buildDivider()]);
      }

      if(current.condition != ""){
        result.addAll([buildListingTile("Condition", current.condition), buildDivider()]);
      }
      
      if(current.details != ""){
        result.add(buildListingTile("Additional Details", current.details));
      }
      
    }on Exception catch(e){
      print(e);
      result = <Widget>[Center(child: Text("Something went wrong")),];
    }
    return result;
  }

   void _showDialog(bool error) {
      showDialog(
        context: theme['context'],
        builder: (BuildContext context) {
          return !error ? AlertDialog(
            titlePadding: const EdgeInsets.all(5),
            contentPadding: const EdgeInsets.all(0),
            title: ListTile(
              title: Text("Copied to Clipboard"),
              trailing: Icon(
                Icons.check, 
                color: Colors.green,
              ),
            ),
          ): AlertDialog(
            titlePadding: const EdgeInsets.all(5),
            contentPadding: const EdgeInsets.all(0),
            title: ListTile(
              title: Text("Not Copied to Clipboard"),
              trailing: Icon(
                Icons.clear, 
                color: Colors.red,
              ),
            ),
          );
        },
      );
    }

  
  @override
  Widget build(BuildContext context) {
    theme['context'] = context;
    theme['theme'] = Theme.of(context);
    theme['isDark'] = Provider.of<ThemeModel>(context,listen: false,).isDark;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _buildAppBar(),
          ///Note: Apparently there's a weird bug within the framework, when you select the last index
          ///or tab and switch the orientation of the viewport/change dimensions, it creates an offset of the view, 
          ///which can be reversed by scrolling the view. Hopefully, the fix comes soon =)
          ///[https://github.com/flutter/flutter/issues/60288]
          body: TabBarView(
            children: [
                _buildPage('Description'),
                _buildPage('Details'),
            ],
          ),
        ),
      );
  }
}

class UnorderedListItem extends StatelessWidget {
  UnorderedListItem(this.text, this.isDark);
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 7, right: 8),
          height: 5.0,
          width: 5.0,
          decoration: new BoxDecoration(
            color: isDark ? Colors.white60 : Colors.black45,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
      ],
    );
  }
}