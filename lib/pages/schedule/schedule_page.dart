import 'package:flutter/material.dart';

import 'calender/calender_edit.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  Size size;

// Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Schedule',
              style: TextStyle(color: Color(0xff323643), fontSize: 20),
              textAlign: TextAlign.left,
            ),
            IconButton(
                icon: Image.asset('assets/menu-icon.png'), onPressed: () {})
          ],
        ),
      ),
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _getAppbar,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            // Container(
            //     height: size.height * 0.10,
            //     width: size.width,
            //     child: ListView(
            //       scrollDirection: Axis.horizontal,
            //       children: months.map(
            //         (f) {
            //           return ToggleButtonsTheme(
            //             child: Text(' ${f} '),
            //             data: ToggleButtonsThemeData(color: Colors.amber),
            //           );
            //         },
            //       ).toList(),
            //     )),
            Container(
              height: size.height * 0.50,
              child: ScheduleCalendar(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ButtonTheme(
                minWidth: size.width * 0.80,
                height: 50,
                child: RaisedButton(
                  onPressed: () {},
                  // onPressed: () =>
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => ConfirmPage(
                  //               phoneNumber: _phoneNumber.text,
                  //             ))),
                  child: Text(
                    'Add Expenses',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: MonthViewSettings(
          dayFormat: 'EEE',
          agendaStyle: AgendaStyle(backgroundColor: Colors.black),
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }

  List<Meeting> _getDataSource() {
    var meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
