## Itelligence menu scraper
Scraping interface for https://speiseplan.app.itelligence.org/
Usage:

```
ItelligenceMenuClient it = ItelligenceMenuClient();
// Await the items in the stream
List<MenuEntry> entries = await it.getMenuEntries().toList();
// Or listen to the stream
it.getMenuEntries().listen((entry) {
    // Handle the current entry
});
```
