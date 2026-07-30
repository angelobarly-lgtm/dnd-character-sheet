# Rule Icons

Icone originali dell'interfaccia dei contenuti regolamentari.

Convenzioni:
- formato PNG con trasparenza;
- pittogramma monocromatico;
- il colore di sfondo NON appartiene all'asset;
- il colore viene applicato da RuleVisualTheme;
- il nome del file deve derivare dall'iconId semantico;
- gli asset devono essere registrati in ruleIconAssets.

Esempio:

iconId: dagger
asset: assets/icons/rules/dagger.png

Se un asset non esiste, RuleIconGlyph usa automaticamente
l'icona fallback della famiglia visuale.
