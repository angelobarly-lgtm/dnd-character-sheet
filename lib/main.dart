import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const DndApp());

const abilities = ['FOR', 'DES', 'COS', 'INT', 'SAG', 'CAR'];
const standardArray = [15, 14, 13, 12, 10, 8];

int mod(int score) => ((score - 10) / 2).floor();
String sign(int n) => n >= 0 ? '+$n' : '$n';

const monkFeaturesByLevel = <int, List<String>>{
  1: ['Difesa Senza Armatura', 'Arti Marziali'],
  2: ['Ki', 'Movimento Senza Armatura'],
  3: ['Deviare Proiettili'],
  4: ['Caduta Lenta'],
  5: ['Attacco Extra', 'Colpo Stordente'],
  6: ['Colpi Ki Potenziati'],
  7: ['Elusione', 'Mente Lucida'],
  9: ['Miglioramento del Movimento Senza Armatura'],
  10: ['Purezza del Corpo'],
  13: ['Lingua del Sole e della Luna'],
  14: ['Anima Adamantina'],
  15: ['Corpo Senza Tempo'],
  18: ['Corpo Vuoto'],
  20: ['Perfezione Interiore'],
};

const subclassDescriptions = <String, String>{
  'Via della Mano Aperta':
      'Una tradizione focalizzata sul controllo del combattimento senz’armi. In V0.2 la scelta viene prima mostrata in anteprima e confermata solo dopo.',
  'Via dell’Ombra':
      'Una tradizione legata a furtività e tecniche d’ombra. Le descrizioni complete restano segnaposto finché non vengono verificate sulle fonti fornite.',
  'Via dei Quattro Elementi':
      'Una tradizione che unisce disciplina monastica e tecniche elementali. Le descrizioni complete restano segnaposto finché non vengono verificate sulle fonti fornite.',
};

const subclassFeaturesByLevel = <String, Map<int, List<String>>>{
  'Via della Mano Aperta': {
    3: ['Tecnica della Mano Aperta'], 6: ['Integrità del Corpo'],
    11: ['Tranquillità'], 17: ['Palmo Tremante'],
  },
  'Via dell’Ombra': {
    3: ['Arti dell’Ombra'], 6: ['Passo d’Ombra'],
    11: ['Manto d’Ombra'], 17: ['Opportunista'],
  },
  'Via dei Quattro Elementi': {
    3: ['Discepolo degli Elementi'], 6: ['Discipline Elementali Aggiuntive'],
    11: ['Discipline Elementali Aggiuntive'], 17: ['Discipline Elementali Aggiuntive'],
  },
  'Via del Maestro Ubriaco': {
    3: ['Competenza Bonus', 'Tecnica dell’Ubriaco'], 6: ['Ondeggiamento Barcollante'],
    11: ['Fortuna dell’Ubriaco'], 17: ['Frenesia Intossicata'],
  },
  'Via del Kensei': {
    3: ['Via del Kensei'], 6: ['Uno con la Lama'],
    11: ['Affilare la Lama'], 17: ['Precisione Infallibile'],
  },
  'Via dell’Anima Solare': {
    3: ['Dardo Solare Radiante'], 6: ['Colpo ad Arco Bruciante'],
    11: ['Esplosione Solare Rovente'], 17: ['Scudo Solare'],
  },
  'Via del Sé Astrale': {
    3: ['Braccia del Sé Astrale'], 6: ['Volto del Sé Astrale'],
    11: ['Corpo del Sé Astrale'], 17: ['Sé Astrale Risvegliato'],
  },
  'Via della Misericordia': {
    3: ['Strumenti della Misericordia', 'Mani della Guarigione', 'Mani del Dolore'],
    6: ['Tocco del Medico'], 11: ['Raffica di Guarigione e Dolore'],
    17: ['Mano della Misericordia Suprema'],
  },
};

class HeroData {
  HeroData({
    required this.name,
    required this.baseScores,
    this.level = 1,
    this.hpRolls = const [],
    this.currentHp = -1,
    this.tempHp = 0,
    this.ki = 0,
    this.hitDiceUsed = 0,
    this.subclass,
    this.feat,
    this.deathSuccess = 0,
    this.deathFail = 0,
    this.race = 'Umano',
    this.subrace,
  });

  String name;
  String race;
  String? subrace;
  Map<String, int> baseScores;
  int level, currentHp, tempHp, ki, hitDiceUsed, deathSuccess, deathFail;
  List<int> hpRolls;
  String? subclass, feat;

  Map<String, int> get scores {
    final out = Map<String, int>.from(baseScores);
    if (race == 'Umano') {
      for (final a in abilities) { out[a] = out[a]! + 1; }
    } else if (race == 'Nano') {
      out['COS'] = out['COS']! + 2;
      if (subrace == 'Nano delle Colline') out['SAG'] = out['SAG']! + 1;
      if (subrace == 'Nano delle Montagne') out['FOR'] = out['FOR']! + 2;
    }
    return out;
  }
  String get raceLabel => race == 'Nano' && subrace != null ? subrace! : race;
  int get prof =>
      level < 5 ? 2 : level < 9 ? 3 : level < 13 ? 4 : level < 17 ? 5 : 6;
  int get maxKi => level >= 2 ? level : 0;
  int get hitDiceAvailable => max(0, level - hitDiceUsed);
  String get martialDie =>
      level < 5 ? 'd4' : level < 11 ? 'd6' : level < 17 ? 'd8' : 'd10';
  int get maxHp {
    final con = mod(scores['COS']!);
    final dwarvenToughness =
        race == 'Nano' && subrace == 'Nano delle Colline' ? level : 0;
    return (max(1, 8 + con) +
            hpRolls.fold<int>(0, (s, r) => s + max(1, r + con).toInt()) +
            dwarvenToughness)
        .toInt();
  }

  int get ac => 10 + mod(scores['DES']!) + mod(scores['SAG']!);
  int get initiative => mod(scores['DES']!);
  int get speed {
    final base = race == 'Nano' ? 7.5 : 9.0;
    final bonus = level >= 2 ? (level >= 18 ? 9 : level >= 14 ? 7.5 : level >= 10 ? 6 : level >= 6 ? 4.5 : 3) : 0;
    return (base + bonus).round();
  }

  List<String> get features {
    final out = <String>[];
    for (var l = 1; l <= level; l++) {
      out.addAll(
        (monkFeaturesByLevel[l] ?? const []).where(
          (f) =>
              f != 'Aumento dei Punteggi di Caratteristica' &&
              f != 'Tradizione Monastica' &&
              f != 'Privilegio della Tradizione Monastica',
        ),
      );
      if (subclass != null) {
        out.addAll(subclassFeaturesByLevel[subclass]?[l] ?? const []);
      }
    }
    return out;
  }

  List<String> featuresAtLevel(int targetLevel) {
    final out = <String>[...?monkFeaturesByLevel[targetLevel]];
    if (subclass != null) {
      out.addAll(subclassFeaturesByLevel[subclass]?[targetLevel] ?? const []);
    }
    return out;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'baseScores': baseScores,
        'level': level,
        'hpRolls': hpRolls,
        'currentHp': currentHp,
        'tempHp': tempHp,
        'ki': ki,
        'hitDiceUsed': hitDiceUsed,
        'subclass': subclass,
        'feat': feat,
        'deathSuccess': deathSuccess,
        'deathFail': deathFail,
        'race': race,
        'subrace': subrace,
      };

  factory HeroData.fromJson(Map<String, dynamic> j) => HeroData(
        name: j['name'],
        baseScores: Map<String, int>.from(j['baseScores']),
        level: j['level'],
        hpRolls: List<int>.from(j['hpRolls'] ?? []),
        currentHp: j['currentHp'] ?? -1,
        tempHp: j['tempHp'] ?? 0,
        ki: j['ki'] ?? 0,
        hitDiceUsed: j['hitDiceUsed'] ?? 0,
        subclass: j['subclass'],
        feat: j['feat'],
        deathSuccess: j['deathSuccess'] ?? 0,
        deathFail: j['deathFail'] ?? 0,
        race: j['race'] ?? 'Umano',
        subrace: j['subrace'],
      );
}

class Store {
  static const legacyKey = 'hero_v01';
  static const heroesKey = 'heroes_v04';

  static Future<List<HeroData>> loadAll() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString(heroesKey);
    if (saved != null) {
      final decoded = jsonDecode(saved);
      if (decoded is List) {
        return decoded
            .map((e) => HeroData.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }
    final legacy = p.getString(legacyKey);
    if (legacy != null) {
      final hero = HeroData.fromJson(
        Map<String, dynamic>.from(jsonDecode(legacy)),
      );
      await saveAll([hero]);
      return [hero];
    }
    return [];
  }

  static Future<void> saveAll(List<HeroData> heroes) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      heroesKey,
      jsonEncode(heroes.map((h) => h.toJson()).toList()),
    );
  }

  static Future<void> save(HeroData hero) async {
    final heroes = await loadAll();
    final index = heroes.indexWhere((h) => h.name == hero.name);
    if (index >= 0) {
      heroes[index] = hero;
    } else {
      heroes.add(hero);
    }
    await saveAll(heroes);
  }

  static Future<HeroData?> load() async {
    final heroes = await loadAll();
    return heroes.isEmpty ? null : heroes.first;
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(heroesKey);
    await p.remove(legacyKey);
  }
}

class DndApp extends StatelessWidget {
  const DndApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'D&D Character Sheet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff7b1f1f),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xfff4efe3),
          cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(vertical: 5)),
        ),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HeroData> heroes = [];
  bool loading = true;

  static const parchment = Color(0xffeee3c7);
  static const ink = Color(0xff211d19);
  static const wine = Color(0xff6f1d1b);
  static const gold = Color(0xff9a793e);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final loaded = await Store.loadAll();
    if (!mounted) return;
    setState(() {
      heroes = loaded;
      loading = false;
    });
  }

  Future<void> _createHero() async {
    final h = await Navigator.push<HeroData>(
      context,
      MaterialPageRoute(builder: (_) => const CreatorPage()),
    );
    if (h == null) return;
    await Store.save(h);
    await _reload();
  }

  Future<void> _openHero(HeroData h) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SheetPage(hero: h)),
    );
    await Store.save(h);
    await _reload();
  }

  Widget _ornament() => const Row(
        children: [
          Expanded(child: Divider(color: gold, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.auto_awesome, size: 18, color: gold),
          ),
          Expanded(child: Divider(color: gold, thickness: 1)),
        ],
      );

  Widget _heroCard(HeroData h) => InkWell(
        onTap: () => _openHero(h),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xfff7f0dd),
            border: Border.all(color: ink, width: 1.5),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 2),
                color: Color(0x33000000),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: ink,
                child: Text(
                  h.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xfff4ead0),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Text(
                      'Monaco ${h.level} · ${h.raceLabel}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (h.subclass != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          h.subclass!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    const Divider(height: 22),
                    Row(
                      children: [
                        Expanded(child: _HomeMetric('PF', '${h.currentHp < 0 ? h.maxHp : h.currentHp}/${h.maxHp}')),
                        Expanded(child: _HomeMetric('CA', '${h.ac}')),
                        Expanded(child: _HomeMetric('KI', '${h.ki}/${h.maxKi}')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'TOCCA PER APRIRE LA SCHEDA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: parchment,
        body: SafeArea(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfff4ecd8), Color(0xffe8d9b8)],
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 30),
                    children: [
                      const Icon(Icons.shield_outlined, size: 44, color: wine),
                      const SizedBox(height: 8),
                      const Text(
                        'CRONACHE DEGLI EROI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ink,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Text(
                        'D&D · Scheda Personaggio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff5c5144),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ornament(),
                      const SizedBox(height: 22),
                      Text(
                        heroes.isEmpty ? 'INIZIA UNA NUOVA AVVENTURA' : 'I TUOI PERSONAGGI',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...heroes.map(_heroCard),
                      if (heroes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(14, 10, 14, 24),
                          child: Text(
                            'Ogni leggenda comincia da un nome. Crea il tuo personaggio e prepara la sua scheda per l’avventura.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: _createHero,
                        icon: const Icon(Icons.add, color: wine),
                        label: Text(
                          heroes.isEmpty ? 'CREA IL TUO PRIMO PG' : 'CREA NUOVO PG',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ink,
                          backgroundColor: const Color(0xfff7f0dd),
                          side: const BorderSide(color: wine, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}

class _HomeMetric extends StatelessWidget {
  const _HomeMetric(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      );
}

enum StatMethod { standard, pointBuy, dice, manual }


class FantasySection extends StatelessWidget {
  const FantasySection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xfff7f0dd),
          border: Border.all(color: const Color(0xff2b2722), width: 1.3),
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 2),
              color: Color(0x22000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xff211d19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xfff4ead0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: Color(0xffd9c8a5),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ],
        ),
      );
}

class SheetBox extends StatelessWidget {
  const SheetBox({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xfffbf6e9),
            border: Border.all(color: const Color(0xff2b2722), width: 1.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff211d19),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ],
          ),
        ),
      );
}

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});
  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final name = TextEditingController();
  StatMethod method = StatMethod.standard;
  Map<String, int?> assigned = {for (final a in abilities) a: null};
  List<List<int>> rolls = [];
  Map<String, int> manual = {for (final a in abilities) a: 8};
  String race = 'Umano';
  String? subrace;

  int racialBonus(String a) {
    if (race == 'Umano') return 1;
    if (race == 'Nano') {
      if (a == 'COS') return 2;
      if (subrace == 'Nano delle Colline' && a == 'SAG') return 1;
      if (subrace == 'Nano delle Montagne' && a == 'FOR') return 2;
    }
    return 0;
  }
  String bonusText(String a) {
    final b = racialBonus(a);
    return b == 0 ? 'nessun bonus' : '${race == 'Nano' ? (subrace ?? race) : race} +$b';
  }

  int pointCost(int s) =>
      const {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9}[s] ??
      99;
  int get used => manual.values.fold(0, (x, y) => x + pointCost(y));

  List<int> roll4d6() {
    final r = Random();
    return List.generate(4, (_) => r.nextInt(6) + 1)..sort();
  }

  void reroll() {
    setState(() {
      rolls = List.generate(6, (_) => roll4d6());
      assigned = {for (final a in abilities) a: null};
    });
  }

  List<int> get dicePool =>
      rolls.map((d) => d.skip(1).fold(0, (a, b) => a + b)).toList();

  List<int> availablePool() {
    final src = method == StatMethod.standard ? standardArray : dicePool;
    final left = [...src];
    for (final v in assigned.values) {
      if (v != null) left.remove(v);
    }
    return left;
  }

  String methodTitle(StatMethod m) => switch (m) {
        StatMethod.standard => 'Valori standard',
        StatMethod.pointBuy => 'Acquisto punti',
        StatMethod.dice => 'Tiro 4d6',
        StatMethod.manual => 'Inserimento manuale',
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Creazione · V0.4')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Crea il personaggio',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Text(
                  'V0.4: creazione del personaggio con scelte più leggibili e stile coerente con la scheda.'),
              const SizedBox(height: 14),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Nome del personaggio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: race,
                decoration: const InputDecoration(labelText: 'Razza', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Umano', child: Text('Umano (2014)')),
                  DropdownMenuItem(value: 'Nano', child: Text('Nano (2014)')),
                ],
                onChanged: (v) => setState(() { race = v ?? 'Umano'; subrace = null; }),
              ),
              if (race == 'Nano') ...[
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: subrace,
                  decoration: const InputDecoration(labelText: 'Sottorazza', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Nano delle Colline', child: Text('Nano delle Colline')),
                    DropdownMenuItem(value: 'Nano delle Montagne', child: Text('Nano delle Montagne')),
                  ],
                  onChanged: (v) => setState(() => subrace = v),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Nano: +2 COS · Colline: +1 SAG · Montagne: +2 FOR · velocità base 7,5 m.'),
                ),
              ],
              const InfoTile('Classe', 'Monaco'),
              const InfoTile(
                  'Background', 'Soldato · dati completi nelle versioni successive'),
              const Divider(height: 28),
              Text('Caratteristiche',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SegmentedButton<StatMethod>(
                segments: StatMethod.values
                    .map((m) => ButtonSegment(value: m, label: Text(methodTitle(m))))
                    .toList(),
                selected: {method},
                showSelectedIcon: false,
                onSelectionChanged: (s) {
                  final v = s.first;
                  setState(() {
                    method = v;
                    assigned = {for (final a in abilities) a: null};
                    if (v == StatMethod.pointBuy) {
                      manual = {for (final a in abilities) a: 8};
                    }
                    if (v == StatMethod.dice) reroll();
                  });
                },
              ),
              if (method == StatMethod.dice) ...[
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Tira 6 gruppi da 4d6. In ogni gruppo il dado più basso viene scartato; il totale rimasto va poi assegnato a una caratteristica.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                ...rolls.asMap().entries.map((e) {
                  final d = e.value;
                  final total = d.skip(1).fold(0, (a, b) => a + b);
                  return Card(
                    child: ListTile(
                      title: Text('Risultato ${e.key + 1}: $total',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Wrap(
                        spacing: 6,
                        children: d.asMap().entries.map((x) {
                          final discarded = x.key == 0;
                          return Chip(
                            avatar: const Icon(Icons.casino, size: 16),
                            label: Text('${x.value}${discarded ? ' · scartato' : ''}'),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: reroll,
                  icon: const Icon(Icons.casino),
                  label: const Text('TIRA DI NUOVO I 6 GRUPPI'),
                ),
              ],
              if (method == StatMethod.pointBuy)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: LinearProgressIndicator(
                    value: min(used / 27, 1),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              if (method == StatMethod.pointBuy)
                Text('Punti spesi: $used / 27',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: used > 27 ? Colors.red : null)),
              const SizedBox(height: 8),
              ...abilities.map((a) {
                if (method == StatMethod.standard || method == StatMethod.dice) {
                  final avail = availablePool();
                  final current = assigned[a];
                  final opts = <int>{...?current == null ? null : [current], ...avail}
                      .toList()
                    ..sort((x, y) => y.compareTo(x));
                  return Card(
                    child: ListTile(
                      title: Text(a,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(current == null
                          ? 'Tocca “Scegli” e assegna uno dei valori disponibili'
                          : 'Base $current  →  ${bonusText(a)}  →  ${current + racialBonus(a)}  (${sign(mod(current + racialBonus(a)))})'),
                      trailing: DropdownButton<int>(
                        value: current,
                        hint: const Text('Scegli'),
                        items: opts
                            .map((v) =>
                                DropdownMenuItem(value: v, child: Text('$v')))
                            .toList(),
                        onChanged: (v) => setState(() => assigned[a] = v),
                      ),
                    ),
                  );
                }
                final val = manual[a]!;
                return Card(
                  child: ListTile(
                    title: Text(a,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Base $val  →  ${bonusText(a)}  →  ${val + racialBonus(a)}  (${sign(mod(val + racialBonus(a)))})'),
                    leading: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        final minv = method == StatMethod.pointBuy ? 8 : 1;
                        if (val > minv) setState(() => manual[a] = val - 1);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$val',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            final maxv = method == StatMethod.pointBuy ? 15 : 30;
                            if (val < maxv) setState(() => manual[a] = val + 1);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.check),
                onPressed: () {
                  Map<String, int>? base;
                  if (method == StatMethod.standard ||
                      method == StatMethod.dice) {
                    if (assigned.values.any((v) => v == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Assegna tutti e sei i valori.')),
                      );
                      return;
                    }
                    base = {for (final a in abilities) a: assigned[a]!};
                  } else {
                    if (method == StatMethod.pointBuy && used > 27) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Hai superato i 27 punti.')),
                      );
                      return;
                    }
                    base = Map.of(manual);
                  }
                  if (race == 'Nano' && subrace == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scegli la sottorazza del Nano.')));
                    return;
                  }
                  final h = HeroData(
                    race: race,
                    subrace: subrace,
                    name: name.text.trim().isEmpty
                        ? 'Monaco senza nome'
                        : name.text.trim(),
                    baseScores: base,
                  );
                  h.currentHp = h.maxHp;
                  Navigator.pop(context, h);
                },
                label: const Text('CREA PERSONAGGIO'),
              ),
            ],
          ),
        ),
      );
}

class InfoTile extends StatelessWidget {
  const InfoTile(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      );
}

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.hero});
  final HeroData hero;
  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  HeroData get h => widget.hero;
  int tab = 0;

  Future<void> persist() async {
    await Store.save(h);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (h.currentHp < 0) h.currentHp = h.maxHp;
  }

  Widget statBox(String a) => Container(
        width: 104,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(a, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${h.scores[a]}', style: const TextStyle(fontSize: 25)),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(sign(mod(h.scores[a]!)),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

  Future<void> levelUp() async {
    if (h.level >= 20) return;
    final next = h.level + 1;
    final hp = await showDialog<int>(
      context: context,
      builder: (ctx) =>
          HpDialog(nextLevel: next, conMod: mod(h.scores['COS']!)),
    );
    if (hp == null || !mounted) return;

    String? chosenSubclass;
    if (next == 3) {
      chosenSubclass = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => const SubclassPage()),
      );
      if (chosenSubclass == null || !mounted) return;
    }

    if (next == 4) {
      final ok = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => AsiPage(hero: h)),
      );
      if (ok != true || !mounted) return;
    }

    if (chosenSubclass != null) h.subclass = chosenSubclass;
    h.hpRolls = [...h.hpRolls, hp];
    h.level = next;
    h.ki = h.maxKi;
    h.currentHp = h.maxHp;
    await persist();

    if (!mounted) return;
    final newFeatures = h.featuresAtLevel(next);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Monaco $next'),
        content: Text(
          newFeatures.isEmpty
              ? 'Avanzamento completato.'
              : 'Avanzamento completato.\n\nNovità del livello $next:\n• ${newFeatures.join('\n• ')}',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  void ability(String name, int cost, String desc) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            Text(cost == 0 ? 'Nessun costo' : 'Costo: $cost Ki'),
            const SizedBox(height: 10),
            Text(desc),
            const SizedBox(height: 10),
            const Text(
                'Fonte: Manuale del Giocatore 5e 2014 · pagina da inserire dopo verifica del materiale fornito.'),
            if (cost > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: h.ki >= cost
                      ? () {
                          setState(() => h.ki -= cost);
                          Navigator.pop(ctx);
                          Store.save(h);
                        }
                      : null,
                  child: Text(h.ki >= cost
                      ? 'USA CAPACITÀ'
                      : 'KI INSUFFICIENTE'),
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Future<void> shortRest() async {
    final available = h.hitDiceAvailable;
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => HitDiceDialog(available: available),
    );
    if (result == null) return;

    h.ki = h.maxKi;
    if (result > 0) {
      final con = mod(h.scores['COS']!);
      final rolls = List.generate(result, (_) => Random().nextInt(8) + 1);
      final heal = rolls.fold(0, (sum, roll) => sum + max(0, roll + con));
      h.hitDiceUsed += result;
      h.currentHp = min(h.maxHp, h.currentHp + heal);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '🎲 ${rolls.join(', ')} · COS ${sign(con)} per dado · recuperi $heal PF'),
          ),
        );
      }
    }
    await persist();
  }

  Future<void> longRest() async {
    h.ki = h.maxKi;
    h.currentHp = h.maxHp;
    h.tempHp = 0;
    h.deathFail = 0;
    h.deathSuccess = 0;
    final recover = max(1, h.level ~/ 2);
    h.hitDiceUsed = max(0, h.hitDiceUsed - recover);
    await persist();
  }

  Widget sheetTab() => ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Text(h.name.toUpperCase(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text('Monaco ${h.level} · ${h.raceLabel} · ${h.subclass ?? 'Tradizione non scelta'}'),
                Text('Bonus competenza ${sign(h.prof)}'),
              ]),
            ),
          ),
          Wrap(alignment: WrapAlignment.center, spacing: 6, runSpacing: 6, children: abilities.map(statBox).toList()),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Metric('CA', '${h.ac}')),
            Expanded(child: Metric('INIZ.', sign(h.initiative))),
            Expanded(child: Metric('VELOCITÀ', '${h.speed} m')),
            Expanded(child: Metric('PERCEZ.', '${10 + mod(h.scores['SAG']!)}')),
          ]),
          Row(children: [
            Expanded(child: CounterCard(title: 'PUNTI FERITA', value: h.currentHp, maxValue: h.maxHp, onMinus: () { h.currentHp=max(0,h.currentHp-1); persist(); }, onPlus: () { h.currentHp=min(h.maxHp,h.currentHp+1); persist(); })),
            Expanded(child: CounterCard(title: 'PF TEMP.', value: h.tempHp, maxValue: 99, onMinus: () { h.tempHp=max(0,h.tempHp-1); persist(); }, onPlus: () { h.tempHp++; persist(); })),
          ]),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('TIRI SALVEZZA', style: Theme.of(context).textTheme.titleMedium),
            Wrap(spacing: 10, children: abilities.map((a) => Chip(label: Text('$a ${sign(mod(h.scores[a]!) + ((a=='FOR'||a=='DES') ? h.prof : 0))}'))).toList()),
            const Divider(),
            Text('ABILITÀ', style: Theme.of(context).textTheme.titleMedium),
            const Text('Acrobazia (DES) · Addestrare Animali (SAG) · Arcano (INT) · Atletica (FOR) · Furtività (DES) · Indagare (INT) · Inganno (CAR) · Intimidire (CAR) · Intrattenere (CAR) · Intuizione (SAG) · Medicina (SAG) · Natura (INT) · Percezione (SAG) · Persuasione (CAR) · Rapidità di Mano (DES) · Religione (INT) · Sopravvivenza (SAG) · Storia (INT)'),
            const SizedBox(height: 4),
            const Text('Le competenze selezionabili verranno collegate al flusso classe/background nella prossima iterazione.'),
          ]))),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DADI VITA · d8', style: Theme.of(context).textTheme.titleMedium),
            Text('${h.hitDiceAvailable} / ${h.level} disponibili'),
            const SizedBox(height: 8),
            Text('TS CONTRO MORTE', style: Theme.of(context).textTheme.titleMedium),
            DeathRow(label: 'Successi', value: h.deathSuccess, onChanged: (v) { h.deathSuccess=v; persist(); }),
            DeathRow(label: 'Fallimenti', value: h.deathFail, onChanged: (v) { h.deathFail=v; persist(); }),
          ]))),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton(onPressed: shortRest, child: const Text('RIPOSO BREVE')),
            OutlinedButton(onPressed: longRest, child: const Text('RIPOSO LUNGO')),
            FilledButton(onPressed: h.level < 20 ? levelUp : null, child: Text(h.level < 20 ? 'SALI AL LIVELLO ${h.level+1}' : 'LIVELLO 20')),
          ]),
        ],
      );

  Widget abilitiesTab() => ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Capacità',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              KiCounter(
                value: h.ki,
                maxValue: h.maxKi,
                onMinus: h.ki > 0
                    ? () {
                        h.ki--;
                        persist();
                      }
                    : null,
                onPlus: h.ki < h.maxKi
                    ? () {
                        h.ki++;
                        persist();
                      }
                    : null,
              ),
            ],
          ),
          Text('Arti Marziali: ${h.martialDie}'),
          const SizedBox(height: 8),
          ...h.features.map(
            (f) => Card(
              child: ListTile(
                title: Text(f),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ability(
                  f,
                  0,
                  subclassFeaturesByLevel[h.subclass]?.values
                              .expand((x) => x)
                              .contains(f) ==
                          true
                      ? 'Capacità della sottoclasse ${h.subclass}.'
                      : 'Capacità del Monaco ottenuta con la progressione di classe.',
                ),
              ),
            ),
          ),
          if (h.level >= 2) ...[
            AbilityActionTile(
                title: 'Raffica di Colpi',
                subtitle: '1 Ki',
                onTap: () =>
                    ability('Raffica di Colpi', 1, 'Tecnica Ki del Monaco.')),
            AbilityActionTile(
                title: 'Difesa Paziente',
                subtitle: '1 Ki',
                onTap: () =>
                    ability('Difesa Paziente', 1, 'Tecnica Ki del Monaco.')),
            AbilityActionTile(
                title: 'Passo del Vento',
                subtitle: '1 Ki',
                onTap: () =>
                    ability('Passo del Vento', 1, 'Tecnica Ki del Monaco.')),
          ],
          const SizedBox(height: 80),
        ],
      );

  Widget equipmentTab() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Equipaggiamento',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.backpack),
              title: Text('Sezione attiva'),
              subtitle: Text(
                  'La navigazione ora funziona. Inventario, monete, armi e oggetti verranno popolati nelle prossime versioni.'),
            ),
          ),
        ],
      );

  Widget profileTab() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Profilo', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(title: const Text('Nome'), subtitle: Text(h.name)),
                ListTile(title: const Text('Razza'), subtitle: Text('${h.raceLabel} (2014)')),
                ListTile(
                    title: const Text('Classe'),
                    subtitle: Text('Monaco ${h.level}')),
                ListTile(
                    title: const Text('Tradizione'),
                    subtitle: Text(h.subclass ?? 'Non ancora scelta')),
                ListTile(
                    title: const Text('Talento'),
                    subtitle: Text(h.feat ?? 'Nessuno')),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final pages = [sheetTab(), abilitiesTab(), equipmentTab(), profileTab()];
    return Scaffold(
      appBar: AppBar(
        title: Text(h.name),
        actions: [
          IconButton(
              onPressed: levelUp,
              icon: const Icon(Icons.upgrade),
              tooltip: 'Sali di livello')
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.description), label: 'Scheda'),
            NavigationDestination(
                icon: Icon(Icons.auto_awesome), label: 'Capacità'),
            NavigationDestination(icon: Icon(Icons.backpack), label: 'Equip.'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profilo'),
          ],
        ),
      ),
      body: SafeArea(bottom: false, child: pages[tab]),
    );
  }
}

class Metric extends StatelessWidget {
  const Metric(this.label, this.value, {super.key});
  final String label, value;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      );
}

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.onMinus,
    required this.onPlus,
  });
  final String title;
  final int value, maxValue;
  final VoidCallback onMinus, onPlus;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$value / $maxValue',
                  style: const TextStyle(fontSize: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: onMinus,
                      icon: const Icon(Icons.remove_circle_outline)),
                  IconButton(
                      onPressed: onPlus,
                      icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
            ],
          ),
        ),
      );
}

class KiCounter extends StatelessWidget {
  const KiCounter({
    super.key,
    required this.value,
    required this.maxValue,
    this.onMinus,
    this.onPlus,
  });
  final int value, maxValue;
  final VoidCallback? onMinus, onPlus;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onMinus, icon: const Icon(Icons.remove_circle)),
          Text('Ki $value/$maxValue',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(onPressed: onPlus, icon: const Icon(Icons.add_circle)),
        ],
      );
}

class DeathRow extends StatelessWidget {
  const DeathRow(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged});
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: 85, child: Text(label)),
          ...List.generate(3, (i) {
            final n = i + 1;
            return IconButton(
              onPressed: () => onChanged(value == n ? n - 1 : n),
              icon: Icon(n <= value ? Icons.circle : Icons.circle_outlined),
            );
          }),
        ],
      );
}


const monkFeatureInfo = <String, String>{
  'Difesa Senza Armatura': 'Senza armatura e scudo, la CA usa Destrezza e Saggezza oltre alla base 10.',
  'Arti Marziali': 'Migliora colpi senz’armi e armi da monaco; il dado cresce ai livelli 5, 11 e 17.',
  'Ki': 'Riserva pari al livello da Monaco, usata per alimentare tecniche speciali e recuperata con il riposo previsto.',
  'Movimento Senza Armatura': 'Aumenta la velocità quando non indossi armatura e non usi uno scudo.',
  'Deviare Proiettili': 'Usa la reazione per ridurre i danni di un attacco a distanza con arma e, in certe condizioni, rilanciare il proiettile.',
  'Caduta Lenta': 'Usa la reazione per ridurre i danni da caduta in funzione del livello.',
  'Attacco Extra': 'Quando usi l’azione Attacco, puoi effettuare due attacchi.',
  'Colpo Stordente': 'Dopo un colpo in mischia puoi spendere Ki per tentare di stordire il bersaglio.',
  'Colpi Ki Potenziati': 'I colpi senz’armi contano come magici per superare resistenze e immunità appropriate.',
  'Elusione': 'Migliora la difesa contro effetti basati su tiri salvezza su Destrezza.',
  'Mente Lucida': 'Permette di terminare su di te un effetto di affascinato o spaventato.',
  'Purezza del Corpo': 'Conferisce immunità alle malattie e ai veleni.',
  'Lingua del Sole e della Luna': 'Permette di comprendere le lingue parlate e farsi comprendere da chi conosce una lingua.',
  'Anima Adamantina': 'Conferisce competenza in tutti i tiri salvezza e consente di usare Ki per ritentare un fallimento.',
  'Corpo Senza Tempo': 'Il Ki protegge il corpo dagli effetti debilitanti dell’età e riduce alcuni bisogni fisici.',
  'Corpo Vuoto': 'Tecnica di alto livello che usa Ki per ottenere potenti difese e accedere alla proiezione astrale.',
  'Perfezione Interiore': 'Al livello 20 permette di recuperare una piccola riserva di Ki entrando in combattimento senza Ki.',
  'Tecnica della Mano Aperta': 'Aggiunge effetti di controllo ai colpi della Raffica di Colpi.',
  'Integrità del Corpo': 'Permette di recuperare punti ferita con un’azione; l’uso è limitato.',
  'Tranquillità': 'Dopo un riposo lungo fornisce una protezione che ostacola gli attacchi finché l’effetto non viene interrotto.',
  'Palmo Tremante': 'Tecnica culminante della Mano Aperta che imprime vibrazioni letali attivabili successivamente.',
};

class AbilityActionTile extends StatelessWidget {
  const AbilityActionTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap});
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.play_arrow),
          onTap: onTap,
        ),
      );
}

class HpDialog extends StatefulWidget {
  const HpDialog(
      {super.key, required this.nextLevel, required this.conMod});
  final int nextLevel, conMod;
  @override
  State<HpDialog> createState() => _HpDialogState();
}

class _HpDialogState extends State<HpDialog> {
  int? rolled;
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('PF · livello ${widget.nextLevel}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scegli come determinare i PF del nuovo livello.'),
            const SizedBox(height: 10),
            if (rolled != null)
              Text(
                '🎲 d8 = $rolled · COS ${sign(widget.conMod)} → +${max(1, rolled! + widget.conMod)} PF',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, max(1, 5 + widget.conMod)),
            child: Text('VALORE MEDIO: ${max(1, 5 + widget.conMod)} PF'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => rolled = Random().nextInt(8) + 1);
            },
            child: const Text('TIRA d8'),
          ),
          if (rolled != null)
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, max(1, rolled! + widget.conMod)),
              child: const Text('USA QUESTO TIRO'),
            ),
        ],
      );
}

class HitDiceDialog extends StatefulWidget {
  const HitDiceDialog({super.key, required this.available});
  final int available;
  @override
  State<HitDiceDialog> createState() => _HitDiceDialogState();
}

class _HitDiceDialogState extends State<HitDiceDialog> {
  int count = 0;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Riposo breve'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Il Ki verrà recuperato. Scegli quanti Dadi Vita spendere.'),
            const SizedBox(height: 12),
            Text('Disponibili: ${widget.available}d8'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: count > 0 ? () => setState(() => count--) : null,
                    icon: const Icon(Icons.remove_circle_outline)),
                Text('$count d8',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: count < widget.available
                        ? () => setState(() => count++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ANNULLA')),
          FilledButton(
              onPressed: () => Navigator.pop(context, count),
              child: Text(count == 0 ? 'SOLO RIPOSO' : 'TIRA $count d8')),
        ],
      );
}

class SubclassPage extends StatelessWidget {
  const SubclassPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Tradizione Monastica')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                  'Tocca una Via per vedere cosa offre. La scelta non viene salvata finché non premi “Scegli questa Via”.'),
              const SizedBox(height: 10),
              ...subclassDescriptions.keys.map(
                (s) => Card(
                  child: ListTile(
                    title: Text(s),
                    subtitle: Text(
                        'Livello 3: ${(subclassFeaturesByLevel[s]?[3] ?? const []).join(', ')}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final confirmed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SubclassPreviewPage(name: s)),
                      );
                      if (confirmed == true && context.mounted) {
                        Navigator.pop(context, s);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class SubclassPreviewPage extends StatelessWidget {
  const SubclassPreviewPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final level3 = subclassFeaturesByLevel[name]?[3] ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(subclassDescriptions[name] ?? ''),
            const SizedBox(height: 18),
            Text('Ottieni al livello 3',
                style: Theme.of(context).textTheme.titleLarge),
            ...level3.map((f) => ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(f),
                )),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.arrow_back),
              label: const Text('INDIETRO · GUARDA LE ALTRE VIE'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.check),
              label: const Text('SCEGLI QUESTA VIA'),
            ),
          ],
        ),
      ),
    );
  }
}

class AsiPage extends StatefulWidget {
  const AsiPage({super.key, required this.hero});
  final HeroData hero;
  @override
  State<AsiPage> createState() => _AsiPageState();
}

class _AsiPageState extends State<AsiPage> {
  String mode = 'plus2';
  String? a1, a2;
  String? selectedFeat;

  @override
  void initState() {
    super.initState();
    selectedFeat = widget.hero.feat;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Livello 4 · ASI o Talento')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              RadioGroup<String>(
                groupValue: mode,
                onChanged: (v) { if (v != null) setState(() => mode = v); },
                child: const Column(
                  children: [
                    RadioListTile(
                        value: 'plus2',
                        title: Text('+2 a una caratteristica')),
                    RadioListTile(
                        value: 'split',
                        title: Text('+1 a due caratteristiche diverse')),
                    RadioListTile(
                        value: 'feat', title: Text('Scegli un talento')),
                  ],
                ),
              ),
              if (mode != 'feat') ...[
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Caratteristica'),
                  items: abilities
                      .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text('$a · ${widget.hero.scores[a]}')))
                      .toList(),
                  onChanged: (v) => setState(() {
                    a1 = v;
                    if (a2 == v) a2 = null;
                  }),
                ),
                if (mode == 'split')
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Seconda caratteristica'),
                    items: abilities
                        .where((a) => a != a1)
                        .map((a) => DropdownMenuItem(
                            value: a,
                            child: Text('$a · ${widget.hero.scores[a]}')))
                        .toList(),
                    onChanged: (v) => setState(() => a2 = v),
                  ),
              ] else ...[
                const SizedBox(height: 10),
                const Text(
                    'Talenti V0.2 · selezione iniziale. Le descrizioni complete saranno aggiunte dalle fonti verificate.'),
                RadioGroup<String>(
                  groupValue: selectedFeat,
                  onChanged: (v) => setState(() => selectedFeat = v),
                  child: Column(
                    children: ['Allerta', 'Atleta', 'Fortunato']
                        .map((f) =>
                            RadioListTile<String>(value: f, title: Text(f)))
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (mode == 'feat') {
                    if (selectedFeat == null) return;
                    widget.hero.feat = selectedFeat;
                    Navigator.pop(context, true);
                    return;
                  }
                  if (a1 == null || (mode == 'split' && a2 == null)) return;
                  final inc1 = mode == 'plus2' ? 2 : 1;
                  widget.hero.baseScores[a1!] =
                      min(19, widget.hero.baseScores[a1!]! + inc1);
                  if (mode == 'split') {
                    widget.hero.baseScores[a2!] =
                        min(19, widget.hero.baseScores[a2!]! + 1);
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('CONFERMA SCELTA'),
              ),
            ],
          ),
        ),
      );
}
