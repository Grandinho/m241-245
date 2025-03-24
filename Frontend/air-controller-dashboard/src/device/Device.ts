import { serverURL } from "@/api/request";
import type { IDevice } from "./IDevice";
import axios from 'axios'

export class DeviceApi {

    async getDevices(): Promise<IDevice[]> {

        try {
            const response = await axios.get(serverURL + '/device')
            const devices: IDevice[] = response.data
            return devices
        } catch (error) {
            console.error(error)
            throw error
        }
    }
}