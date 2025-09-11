import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String? userName;
  final String? userSubname;
  final String? userImagePath;
  final double size;

  const UserProfileWidget({
    super.key,
    this.userName,
    this.userSubname,
    this.userImagePath,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Photo de profil
          Container(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E5BBA), width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  userImagePath ?? 'assets/images/user_map_icone.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2E5BBA),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: size * 0.5,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Nom de l'utilisateur
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Text(
                  userName ?? 'Demnaa',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E5BBA),
                  ),
                ),
                if (userSubname != null)
                  Text(
                    userSubname!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E5BBA),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}