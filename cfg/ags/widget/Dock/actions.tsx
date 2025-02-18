import { DOCK_SPACING } from "./globals";

function DashboardAction() {
  const handleClick = () => {
    console.log("dashboard");
  };

  return (
    <button onClicked={handleClick} className="dashboard-action">
      <icon
        icon="/home/alpha/.config/ags/icons/sliders.svg"
        className="settings-icon"
      />
    </button>
  );
}

export function DockActions() {
  return (
    <box spacing={DOCK_SPACING} className="dock-actions-container">
      <DashboardAction />
    </box>
  );
}
