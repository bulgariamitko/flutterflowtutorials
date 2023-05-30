// code created by https://www.youtube.com/@flutterflowexpert
// video - no
// support my work - https://github.com/sponsors/bulgariamitko

// source - https://developer.simprogroup.com/apidoc/?page=ccdb7bf9d93e5652b57cabcc8c41e061#operation/1e26bec2889a4a629e178d71d4b48ce2

import 'package:syncfusion_flutter_calendar/calendar.dart';

class SuncFusionCalendar extends StatefulWidget {
  const SuncFusionCalendar({
    Key? key,
    this.width,
    this.height,
    this.responseAPI,
  }) : super(key: key);

  final double? width;
  final double? height;
  final List<dynamic>? responseAPI;

  @override
  _SuncFusionCalendarState createState() => _SuncFusionCalendarState();
}

class _SuncFusionCalendarState extends State<SuncFusionCalendar> {
  late List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _getSchedule();
  }

  Future<void> _getSchedule() async {
    print(['data lenght', widget.responseAPI!.length]);
    setState(() {
      _appointments = widget.responseAPI!.map((schedule) {
        String startTimeStr =
            '${schedule["Blocks"][0]["ISO8601StartTime"].substring(0, 10)} ${schedule["Blocks"][0]["StartTime"]}';
        String endTimeStr =
            '${schedule["Blocks"][0]["ISO8601EndTime"].substring(0, 10)} ${schedule["Blocks"][0]["EndTime"]}';

        // Print the date and time strings before parsing
        print('Start time string: $startTimeStr');
        print('End time string: $endTimeStr');

        Appointment appointment = Appointment(
            startTime: DateFormat('yyyy-MM-dd HH:mm').parse(startTimeStr),
            endTime: DateFormat('yyyy-MM-dd HH:mm').parse(endTimeStr),
            subject: schedule["Staff"]["Name"]);

        // Print appointment values
        print('Appointment startTime: ${appointment.startTime}');
        print('Appointment endTime: ${appointment.endTime}');
        print('Appointment subject: ${appointment.subject}');

        return appointment;
      }).toList();
      print(['appointments lenght', _appointments.length]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: AppointmentDataSource(_appointments),
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true),
      ),
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
