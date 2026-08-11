# Spell Definition Quality Standard

Ogni incantesimo inserito in `lib/data/spell_data.dart` deve contenere una definizione completa, non solo un riassunto.

## Campi obbligatori

Ogni `SpellDefinition` deve includere:

- nome italiano dell'incantesimo
- livello
- scuola
- tempo di lancio
- gittata
- componenti, incluse componenti materiali quando presenti
- durata, inclusa concentrazione o rituale quando applicabile
- bersaglio, area o tipo di effetto
- classi che possono usare l'incantesimo
- descrizione breve (`summary`)
- descrizione dettagliata (`details`)

## Funzionamento obbligatorio

La descrizione dettagliata deve spiegare:

- cosa fa l'incantesimo
- come viene scelto il bersaglio o l'area
- tiro per colpire o tiro salvezza, quando presente
- danni, guarigione, condizioni o bonus/malus
- durata pratica dell'effetto
- limitazioni, eccezioni e casi speciali
- cosa succede ai livelli superiori, quando presente
- scaling da trucchetto, quando presente
- oggetti/creature/effetti creati, quando presenti
- regole di fine effetto, ricast o concentrazione

## Regola di lavoro

Non aggiungere incantesimi sintetici o incompleti.
Ogni blocco deve essere verificato con audit, analyze e test prima del commit.
