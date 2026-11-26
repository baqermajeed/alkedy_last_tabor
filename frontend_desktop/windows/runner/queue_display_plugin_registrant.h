#ifndef RUNNER_QUEUE_DISPLAY_PLUGIN_REGISTRANT_H_
#define RUNNER_QUEUE_DISPLAY_PLUGIN_REGISTRANT_H_

#include <flutter/plugin_registry.h>

// Plugins safe to load on the queue-display engine.
// Do not register printing / camera / audio here: several of those plugins
// keep a process-wide method channel and would steal it from the main window.
void RegisterQueueDisplayPlugins(flutter::PluginRegistry* registry);

#endif  // RUNNER_QUEUE_DISPLAY_PLUGIN_REGISTRANT_H_
