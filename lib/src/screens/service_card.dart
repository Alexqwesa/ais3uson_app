import 'package:ais3uson_app/src/data_classes/from_json/service_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final ServiceEntry service;

  const ServiceCard({required Key key, required this.service})
      : super(key: key);

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
    return Column(
      children: [
        if (widget.service.total == 1)
          const Divider(
            thickness: 3,
          ),
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Image.asset("images/${widget.service.image}"),
                title: Text(widget.service.shortText),
                enabled: enabled,
                subtitle: Text(widget.service.servTextAdd),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
