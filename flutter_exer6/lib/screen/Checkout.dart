import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shoppingcart_provider.dart';

class Checkout extends StatelessWidget {
  final bool noItemsToCheckout;

  const Checkout({Key? key, this.noItemsToCheckout = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<ShoppingCart>();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Item Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (noItemsToCheckout)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "No items to checkout",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          Expanded(
            child: !noItemsToCheckout
                ? ListView.builder(
                    itemCount: cart.cart.length,
                    itemBuilder: (context, index) {
                      final item = cart.cart[index];
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name),
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : SizedBox.shrink(),
          ),
          if (!noItemsToCheckout) Divider(),
          if (!noItemsToCheckout)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 180.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total Cost to Pay: \$${cart.cartTotal.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cart.removeAll();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Payment Successful"),
                            duration: Duration(seconds: 2),
                          ));
                        },
                        child: Text("Pay Now!"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
