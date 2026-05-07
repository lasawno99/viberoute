import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';

class ApiService {

  Future<List<Destination>> getDestinations() async {
    // Base list of world-class destinations to enrich with live API data
    final List<Map<String, dynamic>> baseData = [
      {
        'id': 'idn',
        'name': 'Bali',
        'country': 'Indonesia',
        'code': 'ID',
        'imageUrl': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=800&q=80',
        'description': 'A tropical paradise known for its volcanic mountains, iconic rice paddies, beaches and coral reefs.',
        'vibe': 'beach',
        'rating': 4.8,
      },
      {
        'id': 'che',
        'name': 'Zermatt',
        'country': 'Switzerland',
        'code': 'CH',
        'imageUrl': 'https://images.unsplash.com/photo-1506905372214-530263f97992?auto=format&fit=crop&w=800&q=80',
        'description': 'A mountain resort renowned for skiing, climbing and hiking. The town lies at the foot of the iconic Matterhorn peak.',
        'vibe': 'mountain',
        'rating': 4.9,
      },
      {
        'id': 'jpn',
        'name': 'Tokyo',
        'country': 'Japan',
        'code': 'JP',
        'imageUrl': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=800&q=80',
        'description': 'Japan’s busy capital, mixes the ultramodern and the traditional, from neon-lit skyscrapers to historic temples.',
        'vibe': 'city',
        'rating': 4.7,
      },
      {
        'id': 'ita',
        'name': 'Positano',
        'country': 'Italy',
        'code': 'IT',
        'imageUrl': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=800&q=80',
        'description': 'A cliffside village on southern Italy\'s Amalfi Coast. It\'s a popular holiday destination with a pebble beachfront.',
        'vibe': 'beach',
        'rating': 4.9,
      },
      {
        'id': 'isl',
        'name': 'Reykjavik',
        'country': 'Iceland',
        'code': 'IS',
        'imageUrl': 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=800&q=80',
        'description': 'The capital and largest city of Iceland, located on the coast. It is home to the National and Saga museums.',
        'vibe': 'nature',
        'rating': 4.8,
      },
      {
        'id': 'egy',
        'name': 'Cairo',
        'country': 'Egypt',
        'code': 'EG',
        'imageUrl': 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?auto=format&fit=crop&w=800&q=80',
        'description': 'Egypt’s sprawling capital, is set on the Nile River. At its heart is Tahrir Square and the vast Egyptian Museum.',
        'vibe': 'culture',
        'rating': 4.8,
      },
      {
        'id': 'fra',
        'name': 'Paris',
        'country': 'France',
        'code': 'FR',
        'imageUrl': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=800&q=80',
        'description': 'France\'s capital, is a major European city and a global center for art, fashion, gastronomy and culture.',
        'vibe': 'city',
        'rating': 4.8,
      },
      {
        'id': 'can',
        'name': 'Banff',
        'country': 'Canada',
        'code': 'CA',
        'imageUrl': 'https://images.unsplash.com/photo-1510312305653-8ed496efae75?auto=format&fit=crop&w=800&q=80',
        'description': 'Banff National Park is famous for its surreal turquoise lakes, majestic mountains and abundant wildlife.',
        'vibe': 'nature',
        'rating': 4.9,
      }
    ];

    List<Destination> destinations = [];

    try {
      for (var item in baseData) {
        // Fetch additional country data
        try {
          final countryResponse = await http.get(
            Uri.parse('https://restcountries.com/v3.1/alpha/${item['code']}'),
          ).timeout(const Duration(seconds: 5));

          if (countryResponse.statusCode == 200) {
            final List countryJson = json.decode(countryResponse.body);
            final countryData = countryJson[0];

            item['capital'] = countryData['capital']?[0] ?? 'N/A';
            item['population'] = countryData['population'] ?? 0;
            item['flagUrl'] = countryData['flags']?['png'] ?? '';

            // Fetch live weather data for the capital
            try {
              final weatherResponse = await http.get(
                Uri.parse('https://wttr.in/${item['capital']}?format=j1'),
              ).timeout(const Duration(seconds: 5));

              if (weatherResponse.statusCode == 200) {
                final weatherJson = json.decode(weatherResponse.body);
                final current = weatherJson['current_condition'][0];
                item['temp'] = '${current['temp_C']}°C';
                item['weather'] = current['weatherDesc'][0]['value'];
              }
            } catch (e) {
              print('Weather API error for ${item['capital']}: $e');
            }
          }
        } catch (e) {
          print('Country API error for ${item['code']}: $e');
        }

        destinations.add(Destination.fromJson(item));
      }
    } catch (e) {
      print('Global API error: $e');
      // If everything fails, still return what we have (even if not enriched)
      return baseData.map((d) => Destination.fromJson(d)).toList();
    }

    return destinations;
  }
}
