import type { IDevice } from "./IDevice";

export abstract class DeviceApi {

    getMovies(): IDevice[] {
        const devices: IDevice[] = [
            {
                id: 1,
                name: "Sensor 1",
                localization: "Zimmer 42",
            }, 
            {
                id: 2,
                name: "Sensor 2",
                localization: "Zimmer 5",
            }, 
            {
                id: 3,
                name: "Sensor 3",
                localization: "Zimmer 1",
            }
        ]
        return devices
    }
}