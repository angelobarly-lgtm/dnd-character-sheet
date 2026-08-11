# CharacterRuleEffect Conventions

## Scopo

`CharacterRuleEffect` rappresenta una regola strutturata del motore di gioco.

L'obiettivo è evitare logica speciale per singoli talenti, razze o classi:
il runtime interpreta esclusivamente gli effetti dichiarati.

---

## Campi

### id

Identificatore univoco.

Esempio:

- observant_passive_perception
- heavy_armor_master_damage_reduction

---

### target

Indica cosa viene modificato.

I target devono essere stabili e riutilizzabili.

Esempi:

| Target | Significato |
|---------|-------------|
| initiative | Bonus iniziativa |
| passive_perception | Percezione passiva |
| passive_investigation | Investigazione passiva |
| armor_class | Classe Armatura |
| damage_reduction | Riduzione danni |
| walking_speed | Velocità |

---

### value

Valore numerico dell'effetto.

Esempi:

initiative -> +5

passive_perception -> +5

armor_class -> +1

damage_reduction -> 3

walking_speed -> +3 metri

Null indica che l'effetto è puramente descrittivo.

---

### condition

Condizione di applicazione.

Esempi:

while_wearing_heavy_armor

detect_secret_door

dim_light

---

## Linee guida

Preferire sempre un nuovo CharacterRuleEffect
rispetto a logica speciale nel runtime.

I nuovi target devono essere riutilizzabili.

Evitare target specifici di un singolo talento.

GOOD

passive_perception

BAD

observant_bonus

---

## Evoluzione futura

Se un giorno saranno necessari operatori diversi
(add, replace, multiply, ecc.)
potranno essere aggiunti senza modificare i target esistenti.
