import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:masterstudy_app/data/models/category.dart';
import 'package:masterstudy_app/data/models/course/CourcesResponse.dart';
import 'package:masterstudy_app/theme/theme.dart';
import 'package:masterstudy_app/ui/screen/category_detail/category_detail_screen.dart';
import 'package:masterstudy_app/ui/screen/course/course_screen.dart';

class NewCoursesWidget extends StatelessWidget {
  final String title;
  final List<CoursesBean> courses;

  NewCoursesWidget(
      this.title,
      this.courses, {
        Key key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return (courses.length != 0) ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 30.0, right: 30.0,bottom: 20),
            child: Text(title,
                textScaleFactor: 1.0,
                style:GoogleFonts.cairo(fontSize: 22)
                    .copyWith(color: dark,fontStyle: FontStyle.normal))),
        _buildList(context)
      ],
    ) : Center();
  }

  _buildList(context) {
    return Container(
      decoration: BoxDecoration(color: HexColor.fromHex("#eef1f7")),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: ConstrainedBox(
          constraints:  BoxConstraints(minHeight: 370, maxHeight: 390),
          child:  ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index){
              var item = courses[index];
              print('4444');
              //  print(item.categories_object.length);
              //  print(item.categories_object[index].name);
              //  print(item.categories_object[index].id);
              var padding = (index == 0)? 20.0: 0.0;

              var rating = 0.0;
              var reviews = 0;
              if (item.rating.total != null) {
                rating = item.rating.average.toDouble();
              }
              if (item.rating.total != null) {
                reviews = item.rating.total;
              }
              return  GestureDetector(
                onTap: (){
                  Navigator.pushNamed(
                    context,
                    CourseScreen.routeName,
                    arguments: CourseScreenArgs(item),
                  );
                },
                child: (item.categories_object.isNotEmpty) ? Padding(
                  padding: EdgeInsets.only(right:padding ),
                  child: _buildCard(
                      context,
                      item.images.small,
                      item.categories_object.first,
                      "${item.title}",
                      rating,
                      reviews,
                      item.price.price,
                      item.price.old_price,
                      item.price.free),
                ) : Container(),
              );
            },
            padding: const EdgeInsets.all(8.0),
            scrollDirection: Axis.horizontal,

          ),
        ),
      ),
    );
  }


  _buildCard(context, image, Category category, title, stars, reviews, price, oldPrice, free) {
    var unescape = new HtmlUnescape();

    return SizedBox(
      width: 300,
      child: Card(
        borderOnForeground: true,
        elevation: 3,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  image,
                  width: 320,
                  height: 140,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      if(category != null){
                        Navigator.pushNamed(
                          context,
                          CategoryDetailScreen.routeName,
                          arguments: CategoryDetailScreenArgs(category),
                        );
                      }

                    },
                    child: (category != null) ? Text(
                      "${unescape.convert(category.name)} >",
                      textScaleFactor: 1.0,
                      style: GoogleFonts.cairo(
                          fontSize: 15,
                          color: HexColor.fromHex("#2a3045").withOpacity(0.5)),
                    ) : Text(''),
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 6.0, left: 16.0, right: 16.0),
                    child: Text(
                      unescape.convert(title),
                      textScaleFactor: 1.0,
                      maxLines: 2,
                      style: GoogleFonts.cairo(fontSize: 20, color: dark),
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 5.0, left: 16.0, right: 16.0),
                  child: Divider(
                    color: HexColor.fromHex("#e0e0e0"),
                    thickness: 1.3,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(top: 5.0, left: 15.0, right: 16.0),
                  child: Row(
                    children: <Widget>[
                      RatingBar(
                        initialRating: stars,
                        minRating: 0,
                        direction: Axis.horizontal,
                        tapOnlyMode: true,
                        glow: false,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 19,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          "${stars} (${reviews})",
                          textScaleFactor: 1.0,
                          style: GoogleFonts.cairo(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPrice(context, price, oldPrice, free)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildPrice(context,price, oldPrice, free) {
    if (free) return Center();
    print(444455);
    print(oldPrice.toString());
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Row(
        children: <Widget>[
          Text(
            price,
            textScaleFactor: 1.0,
            style: Theme.of(context).primaryTextTheme.headline.copyWith(
                color: dark,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold
            ),
          ),
          Visibility(
            visible: oldPrice != null,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                oldPrice.toString(),
                textScaleFactor: 1.0,
                style: Theme.of(context).primaryTextTheme.headline.copyWith(
                    color: HexColor.fromHex("#999999"),
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.lineThrough),
              ),
            ),
          )
        ],
      ),
    );
  }
}