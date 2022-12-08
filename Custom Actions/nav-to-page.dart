// code created by https://www.youtube.com/@flutterflowexpert

import '../../event/event_widget.dart';
import '../../institution/institution_widget.dart';
import '../../person/person_widget.dart';

Future navFromSearch(
  BuildContext context,
  String type,
  String id,
) async {
  if (type == 'Performances') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventWidget(
          eventID: id,
        ),
      ),
    );
    print(['Performances', id]);
  } else if (type == 'People') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonWidget(
          peopleID: id,
        ),
      ),
    );
    print(['People', id]);
  } else if (type == 'Institutions') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstitutionWidget(
          institutionID: id,
        ),
      ),
    );
    print(['Institution', id]);
  }
}