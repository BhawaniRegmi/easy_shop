import 'package:flutter/material.dart';

import '../common_widget/appbar_widget.dart';
import '../common_widget/bottom_nav_bar_widget.dart';
import '../common_widget/search_widget.dart';
import '../components/brand_home_page.dart';
import '../components/category_slider.dart';
import '../components/stay_home_page.dart';

class SubCategoryScreen extends StatelessWidget {
  String slug;

  SubCategoryScreen({required this.slug});
//    SubCategoryScreen({Key key, @required this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Supper"),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SearchWidget(),
              SizedBox(
                height: 10,
                child: Container(
                  color: Color(0xFFf5f6f7),
                ),
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'Sub Categories',
                    ),
                    Tab(
                      text: 'Brands',
                    ),
                    Tab(
                      text: 'Shops',
                    )
                  ], // list of tabs
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  color: Color(0xFFf5f6f7),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.white24,
                      child: CategoryPage(
                          slug: 'categories/?parent=' + slug, isSubList: true),
                    ),
                    Container(
                      color: Colors.white24,
                      child: BrandHomePage(
                        slug: 'brands/?limit=20&page=1&category=' + slug,
                        isSubList: true,
                      ),
                    ),
                    Container(
                      color: Colors.white24,
                      child: ShopHomePage(
                        slug: 'category/shops/' + slug + '/?page=1&limit=15',
                        isSubList: true,
                      ),
                    ) // class name
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBarWidget(),
      ),
    );
  }
}
