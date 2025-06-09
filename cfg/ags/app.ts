import { App } from "astal/gtk3";
import style from "./style.scss";

import { renderBar, renderDock } from "./widget";
import { renderActionSidebar } from "./widget/ActionSidebar";

App.start({
  css: style,
  main() {
    renderBar();
    renderDock();
    renderActionSidebar();
  },
});
