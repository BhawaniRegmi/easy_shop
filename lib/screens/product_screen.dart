import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/common_widget/AppBarWidget.dart';
import 'package:flutter_ecommerce_app/common_widget/CircularProgress.dart';
import 'package:flutter_ecommerce_app/common_widget/GridTilesCategory.dart';
import 'package:flutter_ecommerce_app/common_widget/GridTilesProducts.dart';
import 'package:flutter_ecommerce_app/models/ProductsModel.dart';
import 'package:flutter_ecommerce_app/utils/Urls.dart';
import 'package:http/http.dart';

import '../common_widget/circular_progress.dart';

class ProductsScreen extends StatefulWidget {
  String name;
  String slug;

  ProductsScreen({required this.name, required this.slug});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANgry"),
      ),
      body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: ProductListWidget(
            slug: widget.slug,
          )),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  String slug;

  ProductListWidget({Key key, this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProductList(slug, false),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgress();
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );
  }
}

ProductsModels products;

Future<ProductsModels> getProductList(String slug, bool isSubList) async {
  if (isSubList) {
    products = null;
  }
  if (products == null) {
    Response response;
    response = await get(Urls.ROOT_URL + slug);
    int statusCode = response.statusCode;
    final body = json.decode(response.body);
    if (statusCode == 200) {
      products = ProductsModels.fromJson(body);
      return products;
    } else {
      return products = ProductsModels();
    }
  } else {
    return products;
  }
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  ProductsModels values = snapshot.data;
  List<Results> results = values.results;
  return GridView.count(
    crossAxisCount: 2,
//    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.all(1.0),
    childAspectRatio: 8.0 / 12.0,
    children: List<Widget>.generate(results.length, (index) {
      return GridTile(
          child: GridTilesProducts(
        name: results[index].name,
        imageUrl: results[index].imageUrls[0],
        slug: results[index].slug,
        price: results[index].maxPrice,
      ));
    }),
  );
}

class ProductsModels {
  int count;
  String next;
  Null previous;
  List<Results> results;

  ProductsModels({this.count, this.next, this.previous, this.results});

  ProductsModels.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String name;
  String slug;
  List<String> imageUrls;
  String priceType;
  String maxPrice;
  String minPrice;
  String minDiscountedPrice;

  Results(
      {this.name,
      this.slug,
      this.imageUrls,
      this.priceType,
      this.maxPrice,
      this.minPrice,
      this.minDiscountedPrice});

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    imageUrls = json['image_urls'].cast<String>();
    priceType = json['price_type'];
    maxPrice = json['max_price'];
    minPrice = json['min_price'];
    minDiscountedPrice = json['min_discounted_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image_urls'] = this.imageUrls;
    data['price_type'] = this.priceType;
    data['max_price'] = this.maxPrice;
    data['min_price'] = this.minPrice;
    data['min_discounted_price'] = this.minDiscountedPrice;
    return data;
  }
}
