import { App, Astal, Gdk, Gtk } from "astal/gtk3";
import { getPrimaryMonitor, iconPath } from "../../utils";

import { DEBUG_MODE } from "./globals";
import { EyecandyHour, EyecandyWeekdays } from "./deco";
import { PowerButtons } from "./powerbuttons";
import { GithubNotifsPanel } from "./github-notifs-panel";

function ActionSidebar(monitor: Gdk.Monitor) {
  return (
    <window
      className="ActionSidebar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.IGNORE}
      anchor={Astal.WindowAnchor.LEFT}
      application={App}
      name="ActionSidebar"
      widthRequest={350}
      heightRequest={monitor.geometry.height - 50}
      visible={DEBUG_MODE} // only visible by default if in debug mode, else user should toggle it.
    >
      <box className="container" vertical>
        <box vertical spacing={18} vexpand>
          <EyecandyHour />
          <EyecandyWeekdays />
        </box>
        <box
          className="bottom-container"
          valign={Gtk.Align.END}
          heightRequest={450}
          vertical
          homogeneous={false}
        >
          <GithubNotifsPanel />
          <box className="footer-container" valign={Gtk.Align.END}>
            <box className="sidebar-footer" hexpand>
              <PowerButtons />
            </box>
          </box>
        </box>
      </box>
    </window>
  );
}

/// Renders the sidebar on the primary monitor.
export function renderActionSidebar() {
  ActionSidebar(getPrimaryMonitor());
}
