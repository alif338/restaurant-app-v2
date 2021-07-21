import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/providers/detail_providers.dart';
import 'package:restaurant_app/review_page.dart';

import 'detail_page.dart';

class AddReviewPage extends StatefulWidget {
  final ListRestaurants listRestaurants;
  const AddReviewPage({
    Key? key, required this.listRestaurants
  }) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl = 'https://restaurant-api.dicoding.dev/images/small/${widget.listRestaurants.pictureId}';
    final id = widget.listRestaurants.id;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Add Review", style: TextStyle(
          color: Colors.black,
          fontFamily: 'ChivoRegular'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imgUrl),
          )
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Your Name"),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Nama",
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Colors.black26,
                    hintStyle: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
                  ),
                  onTap: (){
                    print("READY to EDIT");
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16,),
                Text("Your Review"),
                TextFormField(
                  controller: _reviewController,
                  style: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Review Anda",
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: Colors.black26,
                    hintStyle: TextStyle(color: Colors.white, fontFamily: 'ChivoRegular'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field tidak boleh kosong";
                    }
                    return null;
                  },
                  onTap: (){
                    print("READY to EDIT");
                  },
                ),
                SizedBox(height: 32,),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.width * 0.2,
                                    child: CircularProgressIndicator(),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                );
                              }
                            );
                            await Provider.of<DetailProviders>(context, listen: false).addReview(
                              id,
                              _nameController.text,
                              _reviewController.text
                            ).then((value) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                              //     create: (context) => DetailProviders(id: id),
                              //     child: DetailPage(listRestaurants: widget.listRestaurants))
                              // ));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.pop(context);
                            })
                            .catchError((e) => print(e));
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
