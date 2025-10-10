import 'package:utils/date_time/format_date_utils.dart';
import 'package:core/data/models/artist_model.dart';
import 'package:core/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

class ScheduleAppointmentInput extends StatefulWidget {
  final UserModel? client;
  final ArtistModel? artist;
  final bool isClient;
  const ScheduleAppointmentInput({
    super.key,
    this.client,
    this.artist,
    this.isClient = false,
  });

  @override
  State<ScheduleAppointmentInput> createState() =>
      _ScheduleAppointmentInputState();
}

class _ScheduleAppointmentInputState extends State<ScheduleAppointmentInput> {
  Moment date = Moment.now();

  void updateDate(int? increment, DateTime? newDate) {
    print(increment);
    if (increment != null) {
      date = date.add(Duration(days: increment));
      // if (increment > 0) {
      // } else if (increment < 0) {
      //   date = date.subtract(Duration(days: increment));
      // }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  FormatDateUtils.formatToCalendar(date),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => updateDate(-1, null),
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => updateDate(1, null),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableDates.length,
              padding: const EdgeInsets.only(top: 15),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(availableDates[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
