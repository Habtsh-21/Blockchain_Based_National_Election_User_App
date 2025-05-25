

import 'package:flutter/material.dart';

Drawer buildDrawer({
  required String email,
  required bool isVerified,
  required VoidCallback onEditProfile,
  required VoidCallback onLogout,
}) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
          ),
          accountName: Row(
            children: [
              Text(
                isVerified ? "Verified" : "Unverified",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 6),
              Icon(
                isVerified ? Icons.verified : Icons.error_outline,
                color: isVerified ? Colors.greenAccent : Colors.redAccent,
                size: 18,
              )
            ],
          ),
          accountEmail: Text(email),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
          ),
        ),

        // Settings button
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Edit Profile"),
          onTap: onEditProfile,
        ),

        // Logout button
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: onLogout,
        ),

        // Other options
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("About App"),
          onTap: () {
            // Add your action
          },
        ),
      ],
    ),
  );
}
