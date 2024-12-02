import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';

class SearchRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const SearchRoutePage({super.key, required this.parentContext});

  @override
  State<SearchRoutePage> createState() => _SearchRoutePageState();
}

class _SearchRoutePageState extends State<SearchRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          titleSpacing: defaultPadding,
          backgroundColor: Colors.transparent,
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                  hintText: 'Search product',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.black)),
                  suffixIcon: InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.close_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                enabled: false,
              ),
            ),
          )),
      body: ListView(
        padding: const EdgeInsets.only(top: 10.0),
        children: const [
          SearchItem(
            title: "shampoo",
          ),
          SearchItem(
            title: "photo",
          ),
          SearchItem(
            title: "colgate",
          ),
          SearchItem(
            title: "karobka",
          )
        ],
      ),
    );
  }
}

class SearchItem extends StatelessWidget {
  final String title;
  const SearchItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.history,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "shampoo",
                    style: TextStyle(
                        color: Color.fromRGBO(71, 71, 71, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0),
                  )
                ],
              ),
              InkWell(onTap: () {}, child: const Icon(Icons.close_outlined))
            ],
          )),
    );
  }
}
