import { exec, readFile, writeFile } from "astal";
import { existsDir, existsFile } from "../utils";

export enum MonitorDisplay {
  ALL = "all",
  PRIMARY = "primary",
}

export interface ConfigSchema {
  palette: {
    darkMode: boolean;
  };
  panel: {
    showOnMonitor: MonitorDisplay;
  };
}

const DEBUG = false;

const DEFAULT_CONFIG: ConfigSchema = {
  palette: {
    darkMode: true,
  },
  panel: {
    showOnMonitor: MonitorDisplay.ALL,
  },
};

export class ConfigService {
  private static _instance: ConfigService | undefined = undefined;

  constructor(
    private _configDir = "duskbloom",
    private _configFile = "config.json",
  ) {}

  public static get instance(): ConfigService {
    if (ConfigService._instance === undefined) {
      return (ConfigService._instance = new ConfigService());
    }

    return ConfigService._instance;
  }

  private get _userHome(): string {
    return exec(["bash", "-c", "echo $HOME"]);
  }

  private get _confdirpath(): string {
    return [this._userHome, ".config", this._configDir].join("/");
  }

  private get _conffilepath(): string {
    return [this._confdirpath, this._configFile].join("/");
  }

  private get _confContent(): string {
    return readFile(this._conffilepath);
  }

  private get _parsedContent(): ConfigSchema | undefined {
    const content = this._confContent;
    if (content === "") return undefined;

    try {
      return JSON.parse(content) as ConfigSchema;
    } catch {
      return undefined;
    }
  }

  public getConfig(): ConfigSchema {
    let config: ConfigSchema | undefined = undefined;
    if ((config = this._parsedContent) === undefined) {
      this._initialBootstrap();
      return (config = this._parsedContent as ConfigSchema);
    }

    return config;
  }

  private writeDefaultContent(): void {
    const conf: string = JSON.stringify(DEFAULT_CONFIG, null, 2);
    writeFile(this._conffilepath, conf);
    if (DEBUG) console.log("[config] wrote", conf);
  }

  private _initialBootstrap() {
    const existsConfDir = existsDir(this._confdirpath);
    if (!existsConfDir) exec(["mkdir", "-p", this._confdirpath]);
    const existsConfFile = existsFile(this._conffilepath);
    if (!existsConfFile) exec(["touch", this._conffilepath]);

    if (this._parsedContent === undefined) {
      this.writeDefaultContent();
    }
  }
}
