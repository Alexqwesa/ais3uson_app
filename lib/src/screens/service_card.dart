import 'package:ais3uson_app/src/data_classes/from_json/service_entry.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final ServiceEntry service;
  final double width;

  const ServiceCard({
    required Key key,
    required this.service,
    required this.width,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool enabled = true;

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.width * 1.2,
      width: widget.width * 1.0,
      child: Stack(
        children: [
          Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset("images/${widget.service.image}"),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: widget.width * 1.2 - 102,
                    width: 200,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              widget.service.shortText,
                              textScaleFactor: 1.1,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                            child: Text(
                              widget.service.servTextAdd,
                              softWrap: true,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
