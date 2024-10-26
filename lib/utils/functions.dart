double calculatePercentage(double currentPrice, double previousClose) {
  return (currentPrice - previousClose) / previousClose * 100;
}

String removeBeforeColon(String input) {
  int colonIndex = input.indexOf(':');
  if (colonIndex == -1) {
    // If no colon is found, return the original string
    return input;
  }
  return input.substring(colonIndex + 1).trim();
}
