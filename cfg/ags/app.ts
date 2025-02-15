import { App, Gdk } from "astal/gtk3";
import style from "./style.scss";
import { Config, MonitorDisplay } from "./services";

import { Bar } from "./widget/Bar";

function renderBar() {
  const config = Config.instance.getConfig();
  if (config.panel.showOnMonitor === MonitorDisplay.ALL) {
    App.get_monitors().map(Bar);
    return;
  }

  // FIXME: Broken: is_primary() is always returning false for any reason.
  let monitor: Gdk.Monitor | undefined = undefined;
  if ((monitor = App.get_monitors().find((monitor) => monitor.is_primary()))) {
    Bar(monitor);
  }
}

App.start({
  css: style,
  main() {
    renderBar();
  },
});
