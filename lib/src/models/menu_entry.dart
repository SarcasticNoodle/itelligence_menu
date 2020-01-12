class MenuEntry {
  final DateTime date;
  final String selectionOne;
  final String selectionTwo;
  final String campaignMeal;
  final List<String> supplements;

  MenuEntry({this.date, this.selectionOne, this.selectionTwo, this.campaignMeal, this.supplements});

  @override
  String toString() {
    return 'Date: $date\nselectionOne: $selectionOne\nselectionTwo: $selectionTwo\ncampaign: $campaignMeal\nsupplements: $supplements\n\n';
  }
}