import 'package:trader_app/core/models/company.dart';
import 'package:trader_app/core/models/quote.dart';

class TopMover {
  Company company;
  Quote quote;
  TopMover({
    required this.company,
    required this.quote,
  });
}
