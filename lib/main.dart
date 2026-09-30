import 'package:flutter/material.dart';

void main() {
  runApp(SportyBetApp());
}

class SportyBetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportyBet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF00C853),
        scaffoldBackgroundColor: Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _betslip = [];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomePage(onAddToBetslip: _addToBetslip),
      LivePage(),
      BetslipPage(betslip: _betslip, onRemove: _removeFromBetslip, onClear: _clearBetslip),
      MyBetsPage(),
      AccountPage(),
    ]);
  }

  void _addToBetslip(Map<String, dynamic> bet) {
    setState(() {
      if (!_betslip.any((b) => b['id'] == bet['id'])) {
        _betslip.add(bet);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${bet['selection']} added to betslip'),
        backgroundColor: Color(0xFF00C853),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeFromBetslip(String id) {
    setState(() {
      _betslip.removeWhere((b) => b['id'] == id);
    });
  }

  void _clearBetslip() {
    setState(() {
      _betslip.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border(top: BorderSide(color: Colors.grey[800]!)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF00C853),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Live'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.receipt_long),
                  if (_betslip.isNotEmpty)
                    Positioned(
                      right: 0, top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
                        child: Text('${_betslip.length}', style: TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    )
                ],
              ),
              label: 'Betslip',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'My Bets'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
          ],
        ),
      ),
    );
  }
}

// HOME PAGE - MATCH LIST
class HomePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddToBetslip;
  HomePage({required this.onAddToBetslip});

  final List<Map<String, dynamic>> matches = [
    {'league': 'Premier League', 'time': "Today 19:45", 'home': 'Arsenal', 'away': 'Man City', 'odds': {'1': '2.45', 'X': '3.20', '2': '2.85'}},
    {'league': 'La Liga', 'time': "Today 20:00", 'home': 'Barcelona', 'away': 'Real Madrid', 'odds': {'1': '2.10', 'X': '3.40', '2': '3.10'}},
    {'league': 'Serie A', 'time': "Today 18:30", 'home': 'Inter Milan', 'away': 'AC Milan', 'odds': {'1': '2.30', 'X': '3.10', '2': '3.00'}},
    {'league': 'Bundesliga', 'time': "Today 19:30", 'home': 'Bayern Munich', 'away': 'Dortmund', 'odds': {'1': '1.85', 'X': '3.80', '2': '4.20'}},
    {'league': 'Nigeria Premier League', 'time': "Today 16:00", 'home': 'Enyimba', 'away': 'Rangers', 'odds': {'1': '2.00', 'X': '3.00', '2': '3.50'}},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00C853),
        title: Row(
          children: [
            Text('SportyBet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(width: 8),
            Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)), child: Text('NG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: () {}), IconButton(icon: Icon(Icons.notifications_none, color: Colors.white), onPressed: () {})],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF1E1E1E),
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _sportChip('Football', true),
                  _sportChip('Basketball', false),
                  _sportChip('Tennis', false),
                  _sportChip('Live', false),
                  _sportChip('Jackpot', false),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                var m = matches[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m['league'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(m['time'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(m['home'], style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.bar_chart, size: 16, color: Colors.grey)]),
                            SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(m['away'], style: TextStyle(fontWeight: FontWeight.bold)), Text('1X2', style: TextStyle(color: Colors.grey, fontSize: 10))]),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _oddButton(context, m, '1', m['odds']['1'])),
                          Expanded(child: _oddButton(context, m, 'X', m['odds']['X'])),
                          Expanded(child: _oddButton(context, m, '2', m['odds']['2'])),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sportChip(String label, bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: selected ? Color(0xFF00C853) : Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }

  Widget _oddButton(BuildContext context, Map<String, dynamic> match, String sel, String odd) {
    return GestureDetector(
      onTap: () => onAddToBetslip({'id': '${match['home']}-${match['away']}-$sel', 'match': "${match['home']} vs ${match['away']}", 'selection': "$sel - ${match[sel == '1' ? 'home' : sel == '2' ? 'away' : 'Draw']}", 'odd': odd}),
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey[800]!)),
        child: Column(children: [Text(sel, style: TextStyle(color: Colors.grey, fontSize: 11)), SizedBox(height: 2), Text(odd, style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold))]),
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Live Matches'), backgroundColor: Color(0xFF1E1E1E)), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.live_tv, size: 60, color: Colors.grey), SizedBox(height: 10), Text('No live games now', style: TextStyle(color: Colors.grey))]))); 
  }
}

class BetslipPage extends StatelessWidget {
  final List<Map<String, dynamic>> betslip;
  final Function(String) onRemove;
  final VoidCallback onClear;
  BetslipPage({required this.betslip, required this.onRemove, required this.onClear});

  @override
  Widget build(BuildContext context) {
    double totalOdds = betslip.fold(1.0, (prev, b) => prev * double.parse(b['odd']));
    return Scaffold(
      appBar: AppBar(title: Text('Betslip (${betslip.length})'), backgroundColor: Color(0xFF1E1E1E), actions: [if (betslip.isNotEmpty) TextButton(onPressed: onClear, child: Text('Clear All', style: TextStyle(color: Colors.red)))]),
      body: betslip.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long, size: 70, color: Colors.grey[700]), SizedBox(height: 12), Text('Your betslip is empty', style: TextStyle(color: Colors.grey)), Text('Tap odds to add selections', style: TextStyle(color: Colors.grey, fontSize: 12))]))
          : Column(children: [
              Expanded(child: ListView.builder(itemCount: betslip.length, itemBuilder: (c, i) { var b = betslip[i]; return ListTile(tileColor: Color(0xFF1E1E1E), title: Text(b['match'], style: TextStyle(fontSize: 13)), subtitle: Text(b['selection'], style: TextStyle(color: Color(0xFF00C853), fontSize: 12)), trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(b['odd'], style: TextStyle(fontWeight: FontWeight.bold)), IconButton(icon: Icon(Icons.close, size: 18), onPressed: () => onRemove(b['id']))])); })),
              Container(
                padding: EdgeInsets.all(16),
                color: Color(0xFF1E1E1E),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total Odds:'), Text(totalOdds.toStringAsFixed(2), style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold, fontSize: 18))]),
                  SizedBox(height: 12),
                  SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00C853)), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demo mode - No real money. Ready for TestFlight testing!'))); }, child: Text('Place Bet (Demo)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  SizedBox(height: 6),
                  Text('Demo Mode - For TestFlight Testing Only - 18+', style: TextStyle(color: Colors.grey, fontSize: 10)),
                ]),
              )
            ]),
    );
  }
}

class MyBetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('My Bets'), backgroundColor: Color(0xFF1E1E1E)), body: ListView(padding: EdgeInsets.all(8), children: [ _betHistoryTile('Arsenal vs Man City', '1 - Arsenal', '2.45', 'Won', Colors.green), _betHistoryTile('Barcelona vs Real Madrid', 'X - Draw', '3.40', 'Lost', Colors.red), _betHistoryTile('Enyimba vs Rangers', '1 - Enyimba', '2.00', 'Pending', Colors.orange)]));
  }
  Widget _betHistoryTile(String match, String sel, String odd, String status, Color c) {
    return Container(margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(match, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('$sel @ $odd', style: TextStyle(color: Color(0xFF00C853), fontSize: 12))]), Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: c.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text(status, style: TextStyle(color: c, fontSize: 11)))]));
  }
}

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Account'), backgroundColor: Color(0xFF1E1E1E)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)), child: Row(children: [CircleAvatar(radius: 30, backgroundColor: Color(0xFF00C853), child: Icon(Icons.person, size: 30, color: Colors.white)), SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ola Habbey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 4), Text('ID: 8234519', style: TextStyle(color: Colors.grey, fontSize: 12)), SizedBox(height: 4), Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Color(0xFF00C853).withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text('Demo Account - TestFlight', style: TextStyle(color: Color(0xFF00C853), fontSize: 10)))] )])),
        SizedBox(height: 20),
        Text('This app is for TestFlight testing only. No real money gambling.', style: TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
      ]),
    );
  }
}
