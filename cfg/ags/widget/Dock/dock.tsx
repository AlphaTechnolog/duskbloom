import { App, Astal, Gdk } from "astal/gtk3";
import { getPrimaryMonitor } from "../../utils";
import { Variable } from "astal";

import AstalApps from "gi://AstalApps";
import AstalHyprland from "gi://AstalHyprland?version=0.1";

import { Application } from "./application";

function Dock(monitor: Gdk.Monitor) {
  const apps = new AstalApps.Apps();
  const list = Variable<AstalApps.Application[]>([]);
  const hyprland = AstalHyprland.get_default();

  const updateApps = () => {
    const hyprClients = hyprland
      .get_clients()
      .sort((a, b) => a.get_workspace().id - b.get_workspace().id)
      .map((client) => client.get_class());

    const appslist = apps.get_list();

    const clients = [...new Set(hyprClients)]
      .map((wmclass) =>
        appslist.find((element) => {
          return (
            element.get_entry() === wmclass + ".desktop" ||
            element.get_wm_class() === wmclass
          );
        }),
      )
      .filter((client) => client !== undefined);

    list.set(clients);
  };

  updateApps();

  // update applications when one opens or closes apps
  hyprland.connect("event", (_, ev: string, payload: string) => {
    const events = ["openwindow", "closewindow", "movewindow"];
    if (!events.includes(ev)) return;
    setTimeout(() => updateApps(), 50);
  });

  return (
    <window
      className="Dock"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.BOTTOM}
      application={App}
    >
      <box className="container" vertical={false} spacing={4}>
        {list((apps) => apps.map((app) => <Application app={app} />))}
      </box>
    </window>
  );
}

/// Renders the dock in the primary monitor
export function renderDock() {
  Dock(getPrimaryMonitor());
}
