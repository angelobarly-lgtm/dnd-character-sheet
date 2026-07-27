import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const DndApp());

class DndApp extends StatelessWidget {
  const DndApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D&D Character Sheet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B1D1D)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Character {
  Character({
    required this.name,
    required this.scores,
    this.level = 1,
  }) {
    maxHp = 8 + modifier(scores['COS']!);
    currentHp = maxHp;
  }

  final String name;
  final Map<String, int> scores;
  int level;
  late int maxHp;
  late int currentHp;
  int tempHp = 0;
  int currentKi = 0;
  int deathSuccesses = 0;
  int deathFailures = 0;

  static int modifier(int score) => ((score - 10) / 2).floor();
  int get proficiency => level < 5 ? 2 : level < 9 ? 3 : level < 13 ? 4 : level < 17 ? 5 : 6;
  int get maxKi => level >= 2 ? level : 0;
  String get martialArtsDie => level < 5 ? 'd4' : level < 11 ? 'd6' : level < 17 ? 'd8' : 'd10';

  void levelUp() {
    if (level >= 20) return;
    level++;
    currentKi = maxKi;
  }

  void shortRest() => currentKi = maxKi;
  void longRest() {
    currentKi = maxKi;
    currentHp = maxHp;
    tempHp = 0;
    deathSuccesses = 0;
    deathFailures = 0;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Character? character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('D&D Character Sheet · V0.1')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: character == null
            ? Center(
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Nuovo personaggio'),
                  onPressed: () async {
                    final created = await Navigator.push<Character>(
                      context,
                      MaterialPageRoute(builder: (_) => const CreatorPage()),
                    );
                    if (created != null) setState(() => character = created);
                  },
                ),
              )
            : Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(character!.name),
                  subtitle: Text('Umano · Monaco ${character!.level}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SheetPage(character: character!)),
                    );
                    setState(() {});
                  },
                ),
              ),
      ),
    );
  }
}

enum StatMethod { standard, pointBuy, dice, manual }

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});
  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final name = TextEditingController();
  StatMethod method = StatMethod.standard;
  final abilities = ['FOR', 'DES', 'COS', 'INT', 'SAG', 'CAR'];
  Map<String, int> scores = {
    'FOR': 15, 'DES': 14, 'COS': 13, 'INT': 12, 'SAG': 10, 'CAR': 8,
  };

  int pointCost(int score) {
    const costs = {8:0, 9:1, 10:2, 11:3, 12:4, 13:5, 14:7, 15:9};
    return costs[score] ?? 99;
  }

  int get pointsUsed => scores.values.fold(0, (a, b) => a + pointCost(b));
  int rollStat() {
    final r = Random();
    final dice = List.generate(4, (_) => r.nextInt(6) + 1)..sort();
    return dice.skip(1).fold(0, (a, b) => a + b);
  }

  void setMethod(StatMethod m) {
    setState(() {
      method = m;
      if (m == StatMethod.standard) {
        scores = {'FOR':15,'DES':14,'COS':13,'INT':12,'SAG':10,'CAR':8};
      } else if (m == StatMethod.pointBuy) {
        scores = {for (final a in abilities) a: 8};
      } else if (m == StatMethod.dice) {
        scores = {for (final a in abilities) a: rollStat()};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pointBuyValid = method != StatMethod.pointBuy || pointsUsed <= 27;
    return Scaffold(
      appBar: AppBar(title: const Text('Crea personaggio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Nome personaggio')),
          const SizedBox(height: 16),
          const ListTile(title: Text('Razza'), subtitle: Text('Umano · prototipo V0.1')),
          const ListTile(title: Text('Classe'), subtitle: Text('Monaco · livello 1')),
          const ListTile(title: Text('Background'), subtitle: Text('Soldato · prototipo V0.1')),
          const Divider(),
          const Text('Caratteristiche', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          DropdownButtonFormField<StatMethod>(
            initialValue: method,
            items: const [
              DropdownMenuItem(value: StatMethod.standard, child: Text('Valori standard')),
              DropdownMenuItem(value: StatMethod.pointBuy, child: Text('Acquisto punti · 27')),
              DropdownMenuItem(value: StatMethod.dice, child: Text('Tiro 4d6 · scarta il minore')),
              DropdownMenuItem(value: StatMethod.manual, child: Text('Inserimento manuale')),
            ],
            onChanged: (v) { if (v != null) setMethod(v); },
          ),
          if (method == StatMethod.pointBuy)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Punti: $pointsUsed / 27', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: pointsUsed > 27 ? Theme.of(context).colorScheme.error : null,
              )),
            ),
          ...abilities.map((a) => Card(
            child: ListTile(
              title: Text(a),
              subtitle: Text('Modificatore ${fmt(Character.modifier(scores[a]!))}'),
              leading: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: (method == StatMethod.standard || method == StatMethod.dice) ? null : () {
                  setState(() {
                    final min = method == StatMethod.pointBuy ? 8 : 1;
                    if (scores[a]! > min) scores[a] = scores[a]! - 1;
                  });
                },
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('${scores[a]}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (method == StatMethod.standard || method == StatMethod.dice) ? null : () {
                    setState(() {
                      final max = method == StatMethod.pointBuy ? 15 : 30;
                      if (scores[a]! < max) scores[a] = scores[a]! + 1;
                    });
                  },
                ),
              ]),
            ),
          )),
          if (method == StatMethod.dice)
            OutlinedButton.icon(
              onPressed: () => setState(() => scores = {for (final a in abilities) a: rollStat()}),
              icon: const Icon(Icons.casino),
              label: const Text('Ritira tutte le caratteristiche'),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: pointBuyValid ? () {
              final c = Character(
                name: name.text.trim().isEmpty ? 'Monaco senza nome' : name.text.trim(),
                scores: Map.of(scores),
              );
              Navigator.pop(context, c);
            } : null,
            child: const Text('Crea personaggio'),
          ),
        ],
      ),
    );
  }
}

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.character});
  final Character character;
  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  Character get c => widget.character;

  void spendKi(String name, int cost) {
    if (c.currentKi < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Punti Ki insufficienti')));
      return;
    }
    setState(() => c.currentKi -= cost);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name utilizzata · -$cost Ki')));
  }

  void showAbility(String name, String description, int cost) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Costo: $cost Ki'),
          const SizedBox(height: 12),
          Text(description),
          const SizedBox(height: 12),
          const Text('Fonte: Manuale del Giocatore 5e 2014 · pagina da verificare'),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(
            onPressed: c.currentKi >= cost ? () {
              Navigator.pop(context);
              spendKi(name, cost);
            } : null,
            child: Text(c.currentKi >= cost ? 'Usa capacità' : 'Ki insufficiente'),
          )),
        ]),
      ),
    );
  }

  Widget counter(String title, int value, int max, VoidCallback minus, VoidCallback plus) {
    return Card(child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('$value / $max', style: const TextStyle(fontSize: 26)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: minus, icon: const Icon(Icons.remove_circle_outline)),
          IconButton(onPressed: plus, icon: const Icon(Icons.add_circle_outline)),
        ]),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('Umano · Monaco ${c.level}', style: Theme.of(context).textTheme.headlineSmall),
          Text('Bonus competenza ${fmt(c.proficiency)} · Arti Marziali ${c.martialArtsDie}'),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: c.scores.entries.map((e) => Chip(
            label: Text('${e.key} ${e.value} (${fmt(Character.modifier(e.value))})'),
          )).toList()),
          Row(children: [
            Expanded(child: counter('PF', c.currentHp, c.maxHp,
              () => setState(() => c.currentHp = max(0, c.currentHp - 1)),
              () => setState(() => c.currentHp = min(c.maxHp, c.currentHp + 1)))),
            Expanded(child: counter('PF temporanei', c.tempHp, 99,
              () => setState(() => c.tempHp = max(0, c.tempHp - 1)),
              () => setState(() => c.tempHp++))),
          ]),
          const SizedBox(height: 8),
          const Text('Tiri salvezza contro morte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DeathRow(label: 'Successi', value: c.deathSuccesses, onTap: (i) => setState(() => c.deathSuccesses = i)),
          DeathRow(label: 'Fallimenti', value: c.deathFailures, onTap: (i) => setState(() => c.deathFailures = i)),
          const Divider(),
          Text('Ki ${c.currentKi} / ${c.maxKi}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (c.level < 2)
            const Text('Il Ki sarà disponibile dal livello 2.')
          else ...[
            LinearProgressIndicator(value: c.maxKi == 0 ? 0 : c.currentKi / c.maxKi),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Raffica di Colpi'),
              subtitle: const Text('1 Ki'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAbility('Raffica di Colpi', 'Capacità del Monaco. Descrizione completa da popolare dal materiale di riferimento autorizzato.', 1),
            ),
            ListTile(
              title: const Text('Difesa Paziente'),
              subtitle: const Text('1 Ki'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAbility('Difesa Paziente', 'Capacità del Monaco. Descrizione completa da popolare dal materiale di riferimento autorizzato.', 1),
            ),
            ListTile(
              title: const Text('Passo del Vento'),
              subtitle: const Text('1 Ki'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAbility('Passo del Vento', 'Capacità del Monaco. Descrizione completa da popolare dal materiale di riferimento autorizzato.', 1),
            ),
          ],
          const Divider(),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton(onPressed: () => setState(c.shortRest), child: const Text('Riposo breve')),
            OutlinedButton(onPressed: () => setState(c.longRest), child: const Text('Riposo lungo')),
            FilledButton(
              onPressed: c.level < 20 ? () => setState(c.levelUp) : null,
              child: Text(c.level < 20 ? 'Sali al livello ${c.level + 1}' : 'Livello 20'),
            ),
          ]),
        ],
      ),
    );
  }
}

class DeathRow extends StatelessWidget {
  const DeathRow({super.key, required this.label, required this.value, required this.onTap});
  final String label;
  final int value;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 90, child: Text(label)),
      ...List.generate(3, (index) {
        final n = index + 1;
        return IconButton(
          onPressed: () => onTap(value == n ? n - 1 : n),
          icon: Icon(n <= value ? Icons.circle : Icons.circle_outlined),
        );
      }),
    ]);
  }
}

String fmt(int n) => n >= 0 ? '+$n' : '$n';
