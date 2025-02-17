import { Gdk, Astal, App } from "astal/gtk3";
import { Workspaces } from "./";
import { Config, MonitorDisplay } from "../../services";
import { getPrimaryMonitor } from "../../utils";

export function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
  const MAX_WORKSPACES = 6;

  return (
    <window
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <box homogeneous spacing={12} className="workspaces">
        <Workspaces maxWorkspaces={MAX_WORKSPACES} />
      </box>
    </window>
  );
}

/// Renders the bar in the appropiate monitor depending in what the user
/// has set on their configuration, either it's in every monitor or the primary one.
export function renderBar() {
  const config = Config.instance.getConfig();
  const showInAll = config.panel.showOnMonitor === MonitorDisplay.ALL;

  if (showInAll) {
    App.get_monitors().forEach((monitor) => Bar(monitor));
    return;
  }

  Bar(getPrimaryMonitor());
}
