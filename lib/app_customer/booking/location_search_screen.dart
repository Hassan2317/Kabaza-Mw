import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';

class LocationSearchResult {
  final String displayName;
  final LatLng coordinates;

  LocationSearchResult({required this.displayName, required this.coordinates});
}

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationSearchResult> _results = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    if (query.length < 3) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isLoading = true);
    
    // We append Malawi to improve regional search accuracy for Kabaza
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query Malawi&format=json&limit=5');
    
    try {
      final response = await http.get(url, headers: {'User-Agent': 'KabazaApp/1.0'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _results = data.map((jsonItem) {
            return LocationSearchResult(
              displayName: jsonItem['display_name'],
              coordinates: LatLng(double.parse(jsonItem['lat']), double.parse(jsonItem['lon'])),
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Where to in Malawi?',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Simple debounce by waiting briefly, though in a raw implementation we just call it.
            // For production, use a Debouncer. For this mockup, direct call is fine if typing is slow.
            _performSearch(value);
          },
          onSubmitted: _performSearch,
        ),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(color: AppColors.primary),
          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final result = _results[index];
                // Clean up long display names
                final splitName = result.displayName.split(',');
                final title = splitName.first;
                final subtitle = splitName.skip(1).join(',').trim();
                
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.background,
                    child: Icon(Icons.location_on, color: AppColors.secondary),
                  ),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    // Return the result back to the previous screen
                    Navigator.pop(context, result);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
