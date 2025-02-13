import { App, Astal, Gdk, Gtk, hook, Widget } from "astal/gtk3";
import { addClassIf, toggleClass } from "../utils";
import { bind } from "astal";

import Hyprland from "gi://AstalHyprland";

type WorkspaceItemProps = {
  workspaceId: number;
};

function WorkspaceItem({ workspaceId }: WorkspaceItemProps) {
  const hyprland = Hyprland.get_default();
  const focusedWorkspace = bind(hyprland, "focusedWorkspace");
  const clients = bind(hyprland, "clients");

  const updateActive = (self: Widget.Button) => {
    const active = focusedWorkspace.get()?.id === workspaceId + 1;
    addClassIf(self, active, "active");
  };

  const updateOccupied = (self: Widget.Button) => {
    const occupied = clients
      .get()
      ?.some((client) => client.workspace.id === workspaceId + 1);

    addClassIf(self, occupied, "occupied");
  };

  const updateButtonState = (self: Widget.Button) => {
    updateActive(self);
    updateOccupied(self);
  };

  const setupButton = (self: Widget.Button) => {
    updateButtonState(self);
    focusedWorkspace.subscribe(() => updateButtonState(self));
    clients.subscribe(() => updateButtonState(self));
  };

  return (
    <button
      halign={Gtk.Align.CENTER}
      onClicked={() => hyprland.dispatch("workspace", String(workspaceId + 1))}
      setup={setupButton}
      className="workspace-item"
    />
  );
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
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
        {Array.from({ length: MAX_WORKSPACES }).map((_, i) => (
          <WorkspaceItem workspaceId={i} />
        ))}
      </box>
    </window>
  );
}
