//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <file_chooser/file_chooser_plugin.h>
#include <window_size/window_size_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  FileChooserPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileChooserPlugin"));
  WindowSizePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowSizePlugin"));
}
