import { exec } from "astal";
import { existsFile, getEnv, getHome, iconPath } from "../utils";

/// Singleton service which will help us to fetch data about the
/// logged user, such as the profile photo, name, etc.
export class UserService {
  private static _instance: UserService | undefined = undefined;

  constructor(
    private _pfp: string | undefined = undefined,
    private _username: string | undefined = undefined,
    private _homeDir: string = getHome(),
  ) {}

  public static get instance(): UserService {
    if (UserService._instance === undefined) {
      return (UserService._instance = new UserService());
    }

    return UserService._instance;
  }

  public get pfp(): string {
    if (this._pfp === undefined) {
      return (this._pfp = this._getPfp());
    }

    return this._pfp;
  }

  public get username(): string {
    if (this._username === undefined) {
      return (this._username = this._getUsername());
    }

    return this._username;
  }

  private _getPfp(): string {
    const possiblePaths = ["png", "jpg", "jpeg"].map((fmt) => {
      return [this._homeDir, ".face." + fmt].join("/");
    });

    // TODO: Download default-pfp from feather icons or somewhere
    return (
      possiblePaths.find((path) => existsFile(path)) ?? iconPath("default-pfp")
    );
  }

  private _getUsername(): string {
    return exec("whoami");
  }
}
