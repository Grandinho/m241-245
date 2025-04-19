import type { ISensorReading } from "./ISensorReading";
import axios from 'axios'
import apiClient from "@/services/HttpService";

export class SensorReadingApi {

    async getSensorReadingsByDeviceId(id: number): Promise<ISensorReading[]> {

        try {
            const response = await apiClient.get('/sensorreading/device/' + id)
            const sensorReadings: ISensorReading[] = response.data
            return sensorReadings
        } catch (error) {
            console.error(error)
            throw error
        }
    }
}