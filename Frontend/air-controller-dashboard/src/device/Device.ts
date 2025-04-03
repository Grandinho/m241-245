import { serverURL } from "@/api/request";
import type { IDevice } from "./IDevice";
import axios from 'axios'
import type { IRequestedDevice } from "./IRequestedDevice";

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

    async getRequestedDevices(): Promise<IRequestedDevice[]> {
        try {
            const response = await axios.get(serverURL + '/device/request')
            const requestedDevices: IRequestedDevice[] = response.data
            return requestedDevices
        } catch (error) {
            console.error(error)
            throw error
        }
    }

    async createDevice(requestedDevice: IRequestedDevice) {
        try {
            
        }
        catch (error) {
            console.error(error)
            throw error
        }
    }
}