import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/bloc/news_bloc.dart';
import 'package:newsapp/bloc/news_event.dart';
import 'package:newsapp/bloc/news_state.dart';
import 'package:newsapp/widgets/headlines_widget.dart';
import 'package:newsapp/widgets/home_app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// const spinkit2 = SpinKitFadingCircle(
//   color: Colors.amber,
//   size: 50.0,
// );

class _HomeScreenState extends State<HomeScreen> {
  final format = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NewsBloc>()..add(FetchNewsChannelHeadlines('bbc-news'));
    context.read<NewsBloc>()..add(NewsCategories('general'));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 59), child: HomeAppBarWidget()),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (BuildContext context, state) {
                print(state);
                switch (state.status) {
                  case Status.initial:
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                        // SpinKitCircle(
                        //   size: 50,
                        //   color: Colors.blue,
                        // ),
                        );
                  case Status.failure:
                    return Text(state.message.toString());
                  case Status.success:
                    return ListView.builder(
                        itemCount: state.newsList!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(state
                              .newsList!.articles![index].publishedAt
                              .toString());
                          return HeadlinesWidget(
                            dateAndTime: format.format(dateTime),
                            index: index,
                          );
                        });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (BuildContext context, state) {
                switch (state.categoriesStatus) {
                  case Status.initial:
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    )
                        //  SpinKitCircle(
                        //   size: 50,
                        //   color: Colors.blue,
                        // ),
                        );
                  case Status.failure:
                    return Text(state.categoriesMessage.toString());
                  case Status.success:
                    return ListView.builder(
                        itemCount: state.newsCategoriesList!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(state
                              .newsCategoriesList!.articles![index].publishedAt
                              .toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: state.newsCategoriesList!
                                        .articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width: width * .3,
                                    placeholder: (context, url) => Container(
                                      child: const Center(
                                          // child: SpinKitCircle(
                                          //   size: 50,
                                          //   color: Colors.blue,
                                          // ),
                                          ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: height * .18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          state.newsCategoriesList!
                                              .articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                state
                                                    .newsCategoriesList!
                                                    .articles![index]
                                                    .source!
                                                    .name
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
