import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../buttons/bla_circle_button.dart';
import '../../buttons/bla_icon_button.dart';

class BlaSeatPicker extends StatefulWidget {
  const BlaSeatPicker({super.key, this.initSeats, required this.maxSeat});

  final int? initSeats;
  final int maxSeat;

  @override
  State<BlaSeatPicker> createState() => _BlaSeatPickerState();
}

class _BlaSeatPickerState extends State<BlaSeatPicker> {
  int selectedSeat = 1;

  @override
  void initState() {
    super.initState();

    // Initialize selected seat
    if (widget.initSeats != null) {
      selectedSeat = widget.initSeats!;
    } else {
      selectedSeat = 1;
    }
  }

  void onBackTap() {
    Navigator.pop(context);
  }

  void onSubmit() {
    Navigator.pop(context, selectedSeat);
  }

  void onMinus() {
    if (selectedSeat > 1) {
      setState(() {
        selectedSeat = selectedSeat - 1;
      });
    }
  }

  void onPlus() {
    if (selectedSeat < widget.maxSeat) {
      setState(() {
        selectedSeat = selectedSeat + 1;
      });
    }
  }

  bool get minusDisabled {
    return selectedSeat == 1;
  }

  bool get plusDisabled {
    return selectedSeat == widget.maxSeat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(BlaSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            BlaIconButton(onPressed: onBackTap, icon: Icons.close),

            SizedBox(height: BlaSpacings.m),

            // Title
            Text(
              "Number of seats to book",
              style: BlaTextStyles.title.copyWith(color: BlaColors.textNormal),
            ),

            SizedBox(height: BlaSpacings.l),

            // Seat selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minus button
                BlaCircleButton(
                  icon: Icons.remove,
                  type: CircleButtonType.secondary,
                  disabled: minusDisabled,
                  onPressed: onMinus,
                ),

                // Seat number
                Text(
                  selectedSeat.toString(),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                    color: BlaColors.textNormal,
                  ),
                ),

                // Plus button
                BlaCircleButton(
                  icon: Icons.add,
                  type: CircleButtonType.secondary,
                  disabled: plusDisabled,
                  onPressed: onPlus,
                ),
              ],
            ),

            Spacer(),

            // Submit button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlaCircleButton(icon: Icons.arrow_forward, onPressed: onSubmit),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
