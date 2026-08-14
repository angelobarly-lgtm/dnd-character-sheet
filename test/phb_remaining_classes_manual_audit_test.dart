import 'package:flutter_test/flutter_test.dart';

import 'phb_barbarian_catalog_test.dart' as barbarian;
import 'phb_bard_catalog_test.dart' as bard;
import 'phb_cleric_catalog_test.dart' as cleric;
import 'phb_druid_catalog_test.dart' as druid;
import 'phb_fighter_catalog_test.dart' as fighter;
import 'phb_rogue_catalog_test.dart' as rogue;
import 'phb_wizard_catalog_test.dart' as wizard;

void main() {
  group(
    'Audit manuale PHB 2014 - Barbaro',
    barbarian.main,
  );

  group(
    'Audit manuale PHB 2014 - Bardo',
    bard.main,
  );

  group(
    'Audit manuale PHB 2014 - Chierico',
    cleric.main,
  );

  group(
    'Audit manuale PHB 2014 - Druido',
    druid.main,
  );

  group(
    'Audit manuale PHB 2014 - Guerriero',
    fighter.main,
  );

  group(
    'Audit manuale PHB 2014 - Ladro',
    rogue.main,
  );

  group(
    'Audit manuale PHB 2014 - Mago',
    wizard.main,
  );
}
