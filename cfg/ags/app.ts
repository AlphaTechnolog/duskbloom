import { App, Gdk } from "astal/gtk3";
import style from "./style.scss";
import { Config, MonitorDisplay } from "./services";

import { renderBar, renderDock } from "./widget";

App.start({
  css: style,
  main() {
    renderBar();
    renderDock();
  },
});
