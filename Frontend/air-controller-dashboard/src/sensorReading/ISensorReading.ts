export interface ISensorReading {
    id: number;
    deviceId: number;
    temperature: number;
    airQualityIndex: number;
    humidity: number;
    carbondioxide: number;
    createdAt: Date;
}