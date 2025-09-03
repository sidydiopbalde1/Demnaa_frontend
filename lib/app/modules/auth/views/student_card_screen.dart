import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'phone_verification_screen.dart';

class StudentCardScreen extends StatefulWidget {
  final String profileType;

  const StudentCardScreen({super.key, required this.profileType});

  @override
  State<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends State<StudentCardScreen> {
  final _cardNumberController = TextEditingController();
  String _selectedFonction = 'Étudiant/Élève';
  String? _selectedFileName;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          _selectedFileName = result.files.first.name;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fichier sélectionné: ${_selectedFileName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF2E5BBA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'INSCRIPTION',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5BBA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Contenu principal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Fonction
                      const Text(
                        'Fonction',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedFonction,
                        items: ['Étudiant/Élève', 'Professionnel', 'Autre'].map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFonction = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Carte étudiant/scolaire
                      const Text(
                        'Carte étudiant/ Carte scolaire',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cardNumberController,
                        decoration: InputDecoration(
                          hintText: 'Saisir le numéro d\'étudiant ou fichier',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Certificat d'inscription
                      const Text(
                        'Certificat d\'inscription en cours d\'année',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Zone d'upload de fichier
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _selectedFile != null ? const Color(0xFF4ECDC4) : Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedFile != null 
                                ? const Color(0xFF4ECDC4)
                                : Colors.grey[50],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _selectedFile != null ? Icons.check_circle : Icons.cloud_upload_outlined,
                                size: 40,
                                color: _selectedFile != null ? const Color(0xFF4ECDC4) : Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _selectedFile != null 
                                    ? 'Fichier sélectionné: $_selectedFileName'
                                    : 'Cliquer ici pour télécharger un fichier',
                                style: TextStyle(
                                  color: _selectedFile != null ? const Color(0xFF4ECDC4) : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: _selectedFile != null ? FontWeight.w500 : FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_selectedFile == null) ...[
                                const SizedBox(height: 5),
                                Text(
                                  'Formats acceptés: PDF, JPG, PNG',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      // Bouton pour changer de fichier
                      if (_selectedFile != null) ...[
                        const SizedBox(height: 10),
                        Center(
                          child: TextButton.icon(
                            onPressed: _pickFile,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Changer de fichier'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Bouton suivant
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validation simple
                            if (_cardNumberController.text.trim().isEmpty && _selectedFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Veuillez remplir le numéro de carte ou télécharger un fichier'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhoneVerificationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4ECDC4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Suivant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }
}
