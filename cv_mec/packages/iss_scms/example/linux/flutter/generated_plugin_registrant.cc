//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <iss_scms/iss_scms_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) iss_scms_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "IssScmsPlugin");
  iss_scms_plugin_register_with_registrar(iss_scms_registrar);
}
