import { bind } from "astal";
import { Gtk, Widget } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import { addClassIf } from "../../utils";

export type WorkspaceItemProps = {
  workspaceId: number;
};

export type WorkspacesProps = {
  maxWorkspaces: number;
};

export function WorkspaceItem({ workspaceId }: WorkspaceItemProps) {
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

export function Workspaces(
  { maxWorkspaces }: WorkspacesProps = { maxWorkspaces: 6 },
) {
  return (
    <>
      {Array.from({ length: maxWorkspaces }).map((_, i) => (
        <WorkspaceItem workspaceId={i} />
      ))}
    </>
  );
}
