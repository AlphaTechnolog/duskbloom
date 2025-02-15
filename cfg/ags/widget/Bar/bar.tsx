import { Gdk, Astal, App } from "astal/gtk3";
import { Workspaces } from "./";

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
