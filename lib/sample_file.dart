import 'package:flutter/material.dart';

class SweetTreatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SweetTreatsScreen(),
    );
  }
}

class SweetTreatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.network(
                        "https://midnightcityng.com/public/storage/414/Bs4EwsvDacYkW8inh74VV2AkxACKSq-metaYmFubmVybmV3MTExLmpwZWc=-.jpg"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0, left: 10),
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child:
                                  Icon(Icons.arrow_back, color: Colors.orange),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.favorite_border,
                                      color: Colors.orange),
                                ),
                                SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(width: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: SizedBox(
                              height: 120,
                              width: 100,
                              child: Image.network(
                                  "https://reqres.in/img/faces/7-image.jpg"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image and details
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Text(
                              'Sweet Treats',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Waffles • Pancakes • Crepes • Gelato',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          Text('5.0 Excellent (440+)'),
                        ],
                      ),

                      SizedBox(height: 16),
                      // Search bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search menu items',
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Category buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryButton('Pancakes', true),
                          CategoryButton('Waffles', false),
                          CategoryButton('Crepes', false),
                          CategoryButton('Cake Slices', false),
                          CategoryButton('Gelato', false),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  // Menu section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Pancakes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MenuItem(
                    title: 'Plain Pancakes',
                    description: 'Mini Fluffy Pancakes served with Maple Syrup',
                    price: '₦4,500',
                    imageUrl: 'https://link-to-image.com',
                  ),
                  MenuItem(
                    title: 'Loaded Pancakes',
                    description:
                        'Mini Fluffy Pancakes with toppings of your choice',
                    price: '₦4,500',
                    imageUrl: 'https://link-to-image.com',
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  CategoryButton(this.label, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.orange,
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;

  MenuItem(
      {required this.title,
      required this.description,
      required this.price,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl,
                height: 60, width: 60, fit: BoxFit.cover),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
