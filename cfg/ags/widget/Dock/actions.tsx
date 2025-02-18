import { iconPath } from "../../utils";
import { DOCK_SPACING } from "./globals";

function DashboardAction() {
  const handleClick = () => {
    console.log("dashboard");
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
