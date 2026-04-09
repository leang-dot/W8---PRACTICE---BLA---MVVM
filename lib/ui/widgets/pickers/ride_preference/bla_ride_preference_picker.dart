import 'package:flutter/material.dart';
import '/ui/widgets/buttons/bla_button.dart';
import '/ui/widgets/display/bla_divider.dart';

import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import '../../../../services/ride_prefs_service.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../theme/theme.dart';
import '../../buttons/bla_icon_button.dart';
import '../location/bla_location_picker.dart';
import '../seat/bla_seat_picker.dart';

///
/// A RidePreference Picker is a view to pick a RidePreference:
///   - A departure location
///   - An arrival location
///   - A date
///   - A number of seats
///
class BlaRidePreferencePicker extends StatefulWidget {
  final RidePreference? initRidePreference;

  const BlaRidePreferencePicker({
    super.key,
    this.initRidePreference,
    required this.onRidePreferenceSelected,
  });

  final ValueChanged<RidePreference> onRidePreferenceSelected;

  @override
  State<BlaRidePreferencePicker> createState() =>
      _BlaRidePreferencePickerState();
}

class _BlaRidePreferencePickerState extends State<BlaRidePreferencePicker> {
  Location? departure;
  Location? arrival;
  DateTime departureDate = DateTime.now();
  int requestedSeats = 1;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(BlaRidePreferencePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  void init() {
    if (widget.initRidePreference != null) {
      RidePreference pref = widget.initRidePreference!;

      departure = pref.departure;
      arrival = pref.arrival;
      departureDate = pref.departureDate;
      requestedSeats = pref.requestedSeats;
    } else {
      departure = null;
      arrival = null;
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void onDeparturePressed() async {
    Location? result = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: departure),
      ),
    );

    if (result != null) {
      setState(() {
        departure = result;
      });
    }
  }

  void onArrivalPressed() async {
    Location? result = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: arrival),
      ),
    );

    if (result != null) {
      setState(() {
        arrival = result;
      });
    }
  }

  void onSeatNumberPressed() async {
    int? result = await Navigator.of(context).push<int>(
      AnimationUtils.createRightToLeftRoute(
        BlaSeatPicker(
          initSeats: requestedSeats,
          maxSeat: RidePrefsService.maxAllowedSeats,
        ),
      ),
    );

    if (result != null && result != requestedSeats) {
      setState(() {
        requestedSeats = result;
      });
    }
  }

  void onSearch() {
    bool hasDeparture = departure != null;
    bool hasArrival = arrival != null;

    // validate
    if (!hasDeparture || !hasArrival) {
      return;
    }

    RidePreference newPref = RidePreference(
      departure: departure!,
      departureDate: departureDate,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );

    widget.onRidePreferenceSelected(newPref);
  }

  void onSwappingLocationPressed() {
    setState(() {
      if (departure != null || arrival != null) {
        Location? temp = departure;

        if (arrival != null) {
          departure = Location.copy(arrival!);
        } else {
          departure = null;
        }

        if (temp != null) {
          arrival = Location.copy(temp);
        } else {
          arrival = null;
        }
      }
    });
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  String get departureLabel {
    if (departure != null) {
      return departure!.name;
    } else {
      return "Leaving from";
    }
  }

  String get arrivalLabel {
    if (arrival != null) {
      return arrival!.name;
    } else {
      return "Going to";
    }
  }

  bool get showDeparturePLaceHolder {
    return departure == null;
  }

  bool get showArrivalPLaceHolder {
    return arrival == null;
  }

  String get dateLabel {
    return DateTimeUtils.formatDateTime(departureDate);
  }

  String get numberLabel {
    return requestedSeats.toString();
  }

  bool get switchVisible {
    return departure != null || arrival != null;
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
          child: Column(
            children: [
              // 1 - Departure
              RidePrefInput(
                isPlaceHolder: showDeparturePLaceHolder,
                title: departureLabel,
                leftIcon: Icons.location_on,
                onPressed: onDeparturePressed,
                rightIcon: switchVisible ? Icons.swap_vert : null,
                onRightIconPressed: switchVisible
                    ? onSwappingLocationPressed
                    : null,
              ),
              const BlaDivider(),

              // 2 - Arrival
              RidePrefInput(
                isPlaceHolder: showArrivalPLaceHolder,
                title: arrivalLabel,
                leftIcon: Icons.location_on,
                onPressed: onArrivalPressed,
              ),
              const BlaDivider(),

              // 3 - Date
              RidePrefInput(
                title: dateLabel,
                leftIcon: Icons.calendar_month,
                onPressed: () {},
              ),
              const BlaDivider(),

              // 4 - Seats
              RidePrefInput(
                title: numberLabel,
                leftIcon: Icons.person_2_outlined,
                onPressed: onSeatNumberPressed,
              ),
            ],
          ),
        ),

        // 5 - Search button
        BlaButton(text: 'Search', onPressed: onSearch),
      ],
    );
  }
}

class RidePrefInput extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leftIcon;

  final bool isPlaceHolder;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;

  const RidePrefInput({
    super.key,
    required this.title,
    required this.onPressed,
    required this.leftIcon,
    this.rightIcon,
    this.onRightIconPressed,
    this.isPlaceHolder = false,
  });

  Color get textColor {
    if (isPlaceHolder) {
      return BlaColors.textLight;
    } else {
      return BlaColors.textNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(leftIcon, color: BlaColors.iconLight),

      title: Text(
        title,
        style: BlaTextStyles.button.copyWith(fontSize: 14, color: textColor),
      ),

      trailing: rightIcon != null
          ? BlaIconButton(icon: rightIcon, onPressed: onRightIconPressed)
          : null,
    );
  }
}
