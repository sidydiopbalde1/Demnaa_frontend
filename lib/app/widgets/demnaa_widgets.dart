import 'package:flutter/material.dart';
import 'package:get/get.dart';

// =============================================================================
// CUSTOM APP BAR
// =============================================================================
class DemNaaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;

  const DemNaaAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// =============================================================================
// USER PROFILE CARD
// =============================================================================
class DemNaaUserProfileCard extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onTap;

  const DemNaaUserProfileCard({
    super.key,
    required this.name,
    required this.phone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFB8E6D3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Informations
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            
            // Flèche
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9CA3AF),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MENU ITEM CARD
// =============================================================================
class DemNaaMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showArrow;
  final bool showBorder; // Nouvelle option pour masquer l'ombre
  final bool isLast; // Nouvelle option pour le dernier élément

  const DemNaaMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.showArrow = true,
    this.showBorder = true,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isLast ? EdgeInsets.zero : EdgeInsets.only(bottom: showBorder ? 8 : 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: showBorder ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ) : null,
          child: Row(
            children: [
              // Icône
              Icon(
                icon,
                color: iconColor ?? _getDefaultIconColor(title),
                size: 20,
              ),
              
              const SizedBox(width: 16),
              
              // Titre
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? const Color(0xFF3B82F6),
                  ),
                ),
              ),
              
              // Flèche
              if (showArrow)
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

  Color _getDefaultIconColor(String title) {
    switch (title.toLowerCase()) {
      case 'mes conducteurs':
        return const Color(0xFF10B981);
      case 'modifier le numéro':
        return const Color(0xFFEAB308);
      case 'devenir conducteur':
        return const Color(0xFF10B981);
      case 'devenir propriétaire de moto':
        return const Color(0xFF10B981);
      case 'paramètres':
        return const Color(0xFF10B981);
      case 'informations':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

// =============================================================================
// LOGO DEMNAA
// =============================================================================
class DemNaaLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const DemNaaLogo({
    super.key,
    this.fontSize = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'DemNaa',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? const Color(0xFF3B82F6),
      ),
    );
  }
}

// =============================================================================
// BOTTOM NAVIGATION
// =============================================================================
class DemNaaBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showCentralButton;

  const DemNaaBottomNavigation({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.showCentralButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Historique
              _DemNaaNavItem(
                icon: Icons.assessment_outlined,
                label: 'Historique',
                isActive: currentIndex == 0,
                onTap: () => onTap?.call(0),
              ),
              
              // Espace pour le bouton central
              if (showCentralButton) const SizedBox(width: 80),
              
              // Mon Compte
              _DemNaaNavItem(
                icon: Icons.person_outline,
                label: 'Mon Compte',
                isActive: currentIndex == 2,
                onTap: () => onTap?.call(2),
              ),
            ],
          ),
          
          // Bouton central
          if (showCentralButton) _buildCentralButton(),
        ],
      ),
    );
  }

  Widget _buildCentralButton() {
    return Positioned(
      top: -25,
      left: MediaQuery.of(Get.context!).size.width / 2 - 40,
      child: GestureDetector(
        onTap: () => onTap?.call(1),
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'D',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'DemNaa',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigation Item privé
class _DemNaaNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _DemNaaNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// BUTTON PRINCIPAL
// =============================================================================
class DemNaaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;

  const DemNaaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50,
    this.borderRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFF10B981),
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

// =============================================================================
// FORM FIELD
// =============================================================================
class DemNaaFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? hintText;

  const DemNaaFormField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.keyboardType,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? const Color(0xFF10B981) : Colors.grey[300]!,
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixIconTap,
                      child: Icon(
                        suffixIcon,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================
class DemNaaEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const DemNaaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFFB8E6D3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF10B981),
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 24),
            DemNaaButton(
              text: buttonText!,
              onPressed: onButtonPressed!,
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// CARD CONTAINER
// =============================================================================
class DemNaaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color? backgroundColor;

  const DemNaaCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}