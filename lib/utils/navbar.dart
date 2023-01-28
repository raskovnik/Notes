import 'package:flutter/material.dart';
import 'package:keep_notes/utils/trash.dart';
import 'archived.dart';
import 'favorites.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    SnackBar snackBar = SnackBar(
      elevation: 1,
      width: MediaQuery.of(context).size.width * 0.5,
      behavior: SnackBarBehavior.floating,
      content: const Center(child: Text("To be implemented soon!😜")),
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Adelaide"),
            accountEmail: const Text("adelaide@test.dev"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.blue,
                image:  DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border_sharp),
            title: const Text("Favorites"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favorites())
              ).then((res) => setState(() {}));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text("Archive"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Archives())
              ).then((res) => setState(() {}));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Trash"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Trash())
              ).then((_) => setState(() {}));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_sharp),
            title: const Text("Settings"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help & Feedback"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }
}
