# D&D Character Sheet - Project Migrations

Questa cartella contiene tutte le migrazioni del progetto.

Regole:

- Ogni modifica strutturale viene eseguita tramite una migrazione.
- Le migrazioni non vengono mai eliminate.
- Ogni migrazione è numerata in ordine crescente.
- Ogni migrazione deve lasciare il progetto compilabile.
- Dopo ogni migrazione eseguire sempre:

flutter analyze
dart run tool/spell_catalog_audit.dart

Obiettivo finale:

- PHB completo
- Xanathar completo
- Tasha completo
- Talenti completi
- Classi complete
