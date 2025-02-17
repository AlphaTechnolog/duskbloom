import { App, Astal, Gdk, Gtk, Widget } from "astal/gtk3";
import { getPrimaryMonitor, toggleClass } from "../../utils";
import { bind, Variable } from "astal";

import AstalApps from "gi://AstalApps";
import AstalHyprland from "gi://AstalHyprland?version=0.1";

function Application({ app }: { app: AstalApps.Application }) {
  const hyprland = AstalHyprland.get_default();

  const focusedClient = bind(hyprland, "focusedClient").as((client) => {
    if (!Boolean(client)) return false;
    const wmClass = client.get_class();
    return (
      app.get_entry() === wmClass + ".desktop" || app.get_wm_class() === wmClass
    );
  });

  return (
    <button className="appButton">
      <box vertical expand spacing={4}>
        <icon icon={app.iconName} />
        <box
          halign={Gtk.Align.CENTER}
          className={focusedClient.as((show) =>
            ["indicator", !show ? "hide" : ""].join(" "),
          )}
        />
      </box>
    </button>
  );
}

export function Dock(monitor: Gdk.Monitor) {
  const apps = new AstalApps.Apps();
  const list = Variable<AstalApps.Application[]>([]);
  const hyprland = AstalHyprland.get_default();

  // TODO: Group applications by their name (don't repeat them)
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

    // clients.sort((a, b) => a.get_name().localeCompare(b.get_name()));
    list.set(clients.filter((client) => client !== undefined));
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
      <box className="container" vertical={false} spacing={7}>
        {list((apps) => apps.map((app) => <Application app={app} />))}
      </box>
    </window>
  );
}

/// Renders the dock in the primary monitor
export function renderDock() {
  Dock(getPrimaryMonitor());
}
