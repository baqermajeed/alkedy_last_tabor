#include "queue_display_plugin_registrant.h"

#include <desktop_multi_window/desktop_multi_window_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterQueueDisplayPlugins(flutter::PluginRegistry* registry) {
  DesktopMultiWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopMultiWindowPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
