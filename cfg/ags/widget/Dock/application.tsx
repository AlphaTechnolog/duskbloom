import { bind } from "astal";
import { Gtk } from "astal/gtk3";

import Apps from "gi://AstalApps";
import Hyprland from "gi://AstalHyprland";

export function Application({ app }: { app: Apps.Application }) {
  const hyprland = Hyprland.get_default();

  const hyprClient = bind(hyprland, "clients").as((clients) => {
    return clients.find((client) => {
      const wmClass = client.get_class();
      return (
        app.get_entry() === wmClass + ".desktop" ||
        app.get_wm_class() === wmClass
      );
    });
  });

  const focusedClient = bind(hyprland, "focusedClient").as((client) => {
    if (!Boolean(client)) return false;
    const wmClass = client.get_class();
    return (
      app.get_entry() === wmClass + ".desktop" || app.get_wm_class() === wmClass
    );
  });

  const handleClick = () => {
    hyprClient.get()?.focus();
  };

  return (
    <button className="appButton" onClicked={handleClick}>
      <box vertical expand spacing={4}>
        <icon icon={app.iconName} />
        <box
          halign={Gtk.Align.CENTER}
          className={focusedClient.as((show) =>
            ["indicator", show ? "" : "hide"].join(" "),
          )}
        />
      </box>
    </button>
  );
}
