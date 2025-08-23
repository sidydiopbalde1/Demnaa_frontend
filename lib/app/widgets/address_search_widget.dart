import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressSuggestionWidget extends StatelessWidget {
  final List<AddressSuggestion> suggestions;
  final Function(AddressSuggestion) onSuggestionSelected;
  final bool isVisible;

  const AddressSuggestionWidget({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isVisible ? (suggestions.length * 72.0).clamp(0, 200) : 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              color: Color(0xFFE5E7EB),
            ),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return _SuggestionTile(
                suggestion: suggestion,
                onTap: () => onSuggestionSelected(suggestion),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final AddressSuggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5BBA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF2E5BBA),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.address,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF9CA3AF),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe pour les suggestions d'adresses (à ajouter dans votre controller)
class AddressSuggestion {
  final String displayName;
  final double lat;
  final double lon;
  final String address;

  AddressSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.address,
  });

  @override
  String toString() {
    return 'AddressSuggestion(address: $address, lat: $lat, lon: $lon)';
  }
}