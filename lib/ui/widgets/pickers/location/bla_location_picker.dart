import 'package:blabla/data/repositories/location/location_repository_mock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/repositories/location/location_repository_mock.dart';
import '/ui/widgets/display/bla_divider.dart';

import '../../../../model/ride/locations.dart';
import '../../../theme/theme.dart';

///
/// A Location Picker is a view to pick a Location:
///
class BlaLocationPicker extends StatefulWidget {
  const BlaLocationPicker({super.key, required this.initLocation});

  final Location? initLocation; // optional initial location

  @override
  State<BlaLocationPicker> createState() => _BlaLocationPickerState();
}

class _BlaLocationPickerState extends State<BlaLocationPicker> {
  String currentSearchText = "";

  @override
  void initState() {
    super.initState();

    // Initialize search text if initial location exists
    if (widget.initLocation != null) {
      currentSearchText = widget.initLocation!.name;
    }
  }

  void onTap(Location location) {
    Navigator.pop(context, location);
  }

  void onBackTap() {
    Navigator.pop(context);
  }

  void onSearchChanged(String search) {
    setState(() {
      currentSearchText = search;
    });
  }

  List<Location> get filteredLocation {
    // If user types less than 2 characters → show nothing
    if (currentSearchText.length < 2) {
      return [];
    }

    // Get all locations from repository
    LocationRepositoryMock repository = context.read<LocationRepositoryMock>();

    List<Location> allLocations = repository.getAllLocations();

    // Filter locations
    List<Location> result = [];

    for (int i = 0; i < allLocations.length; i++) {
      Location location = allLocations[i];

      if (location.name.toLowerCase().contains(
        currentSearchText.toLowerCase(),
      )) {
        result.add(location);
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            LocationSearchBar(
              initSearch: currentSearchText,
              onBackTap: onBackTap,
              onSearchChanged: onSearchChanged,
            ),

            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredLocation.length,
                itemBuilder: (context, index) {
                  return LocationTile(
                    location: filteredLocation[index],
                    onTap: onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationSearchBar extends StatefulWidget {
  const LocationSearchBar({
    super.key,
    required this.onBackTap,
    required this.onSearchChanged,
    required this.initSearch,
  });

  final String initSearch;
  final VoidCallback onBackTap;
  final ValueChanged<String> onSearchChanged;

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initSearch;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void onClearTap() {
    setState(() {
      _searchController.clear();
    });

    // update parent
    widget.onSearchChanged("");
  }

  bool get searchIsNotEmpty {
    return _searchController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BlaColors.greyLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // BACK ICON
          IconButton(
            onPressed: widget.onBackTap,
            icon: Icon(
              Icons.arrow_back_ios,
              color: BlaColors.iconLight,
              size: 16,
            ),
          ),

          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: widget.onSearchChanged,
              style: TextStyle(color: BlaColors.textLight),
              decoration: InputDecoration(
                hintText: "Any city, street...",
                border: InputBorder.none,
              ),
            ),
          ),

          // CLEAR ICON
          if (searchIsNotEmpty)
            IconButton(
              onPressed: onClearTap,
              icon: Icon(Icons.close, color: BlaColors.iconLight, size: 16),
            ),
        ],
      ),
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({super.key, required this.location, required this.onTap});

  final Location location;
  final ValueChanged<Location> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onTap(location);
          },
          leading: Icon(Icons.history, color: BlaColors.iconLight),

          title: Text(location.name, style: BlaTextStyles.body),

          subtitle: Text(
            location.country.name,
            style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
          ),

          trailing: Icon(
            Icons.arrow_forward_ios,
            color: BlaColors.iconLight,
            size: 16,
          ),
        ),
        BlaDivider(),
      ],
    );
  }
}
