import type { IDevice } from "./IDevice";
import axios from 'axios'
import type { IRequestedDevice } from "./IRequestedDevice";
import { server } from "typescript";
import type { IError } from "@/api/IError";
import apiClient from "@/services/HttpService";

export class DeviceApi {

    async getDevices(): Promise<IDevice[]> {

        try {
            const response = await apiClient.get('/device')
            const devices: IDevice[] = response.data
            return devices
        } catch (error) {
            console.error(error)
            throw error
        }
    }

    async getRequestedDevices(): Promise<IRequestedDevice[]> {
        try {
            const response = await apiClient.get('/device/request/')
            const requestedDevices: IRequestedDevice[] = response.data
            return requestedDevices
        } catch (error) {
            console.error(error)
            throw error
        }
    }

    async declineDevice(declinedDevice: IRequestedDevice): Promise<IError | null> {
        const headers = {
            'Content-Type': 'application/json'
        }
        try {
            const data = { "macAddress": declinedDevice.macAddress };
            const response = await apiClient.post('/device/request/decline', data, { headers: headers })
            if (response.status != 200) {
                return {
                    message: response.data,
                    status: response.status
                }
            } else {
                return null
            }
        } catch (error) {
            console.error(error)
            throw error
        }
    }

    async createDevice(device: IDevice): Promise<IError | null> {
        const headers = {
            'Content-Type': 'application/json'
        }
        try {
            const response = await apiClient.post('/device', device, { headers: headers })
            if (response.status != 201) {
                return {
                    message: response.data,
                    status: response.status
                }
            } else {
                return null
            }
        }
        catch (error) {
            console.error(error)
            throw error
        }
    }
}