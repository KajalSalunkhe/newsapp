import 'package:flutter/material.dart';
import 'package:newsapp/bloc/news_bloc.dart';
import 'package:newsapp/bloc/news_event.dart';
import 'package:newsapp/view/cateogires_screen.dart';
import 'package:provider/provider.dart';

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

FilterList? selectedMenu;

class HomeAppBarWidget extends StatelessWidget {
  HomeAppBarWidget({Key? key}) : super(key: key);

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategoriesScreen()));
        },
        icon: Image.asset(
          'images/category_icon.png',
          height: 30,
          width: 30,
        ),
      ),
      title: const Text(
        'News',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
      actions: [
        Switch(
          value: themeProvider.isDarkTheme,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
        PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }

              if (FilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }

              context.read<NewsBloc>().add(FetchNewsChannelHeadlines(name));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                  const PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text('BBC News'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.aryNews,
                    child: Text('Ary News'),
                  ),
                  const PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text('Al-Jazeera News'),
                  ),
                ])
      ],
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}
