import { serverURL } from "@/api/request";
import type { ISensorReading } from "./ISensorReading";
import axios from 'axios'

export class SensorReadingApi {

    async getSensorReadingsByDeviceId(id: number): Promise<ISensorReading[]> {

        try {
            const response = await axios.get(serverURL + '/sensorreading/device/' + id)
            const sensorReadings: ISensorReading[] = response.data
            return sensorReadings
        } catch (error) {
            console.error(error)
            throw error
        }
    }
}