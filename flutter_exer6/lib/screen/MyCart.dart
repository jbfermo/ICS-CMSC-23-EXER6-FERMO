import 'package:flutter/material.dart';
import '../model/Item.dart';
import "package:provider/provider.dart";
import "../provider/shoppingcart_provider.dart";
import 'package:flutter_exer6/screen/Checkout.dart';

class MyCart extends StatelessWidget {
  const MyCart({Key? key}) : super(key: key);

  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return Text("Total: ${cart.cartTotal}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Consumer<ShoppingCart>(
        builder: (context, cart, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getItems(context),
              computeCost(),
              const Divider(height: 4, color: Colors.black),
              Flexible(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();
                        },
                        child: const Text("Reset"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.cart.isNotEmpty) {
                            Navigator.pushNamed(context, "/checkout");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Checkout(noItemsToCheckout: true)),
                            );
                          }
                        },
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                child: const Text("Go back to Product Catalog"),
                onPressed: () {
                  Navigator.pushNamed(context, "/products");
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    String productname = "";
    return products.isEmpty
        ? const Text('No Items yet!')
        : Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.food_bank),
                        title: Text(products[index].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            productname = products[index].name;
                            context.read<ShoppingCart>().removeItem(productname);

                            if (products.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("$productname removed!"),
                                duration: const Duration(seconds: 1, milliseconds: 100),
                              ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Cart Empty!"),
                                duration: Duration(seconds: 1, milliseconds: 100),
                              ));
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
