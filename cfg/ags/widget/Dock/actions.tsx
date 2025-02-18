import { App } from "astal/gtk3";
import { iconPath } from "../../utils";
import { DOCK_SPACING } from "./globals";

function DashboardAction() {
  const handleClick = () => {
    App.toggle_window("ActionSidebar");
  };

  return (
    <button onClicked={handleClick} className="dashboard-action">
      <icon icon={iconPath("droplet")} className="settings-icon" />
    </button>
  );
}

export function DockActions() {
  return (
    <box spacing={DOCK_SPACING} className="actions-dock-container">
      <DashboardAction />
    </box>
  );
}
