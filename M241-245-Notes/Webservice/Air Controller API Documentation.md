

## Overview

Base URL: `http://RaspberryPIIp:8080`

## Authentication

Most endpoints require authentication using JWT (JSON Web Token).

### Authentication Flow:

1. Obtain a token via the login endpoint
2. Include the token in subsequent requests using the Authorization header: `Authorization: Bearer {token}`

## Endpoints

### User Management

#### Register User

Creates a new user account.

- **URL**: `/register`
- **Method**: `POST`
- **Authentication Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "username": "string",
    "password": "string"
}
```

**Response:**

- **Status Code**: 201 (Created)
- **Body**: Empty

**Error Responses:**

- **Status Code**: 400 (Bad Request) - Invalid registration data
- **Status Code**: 409 (Conflict) - Username already exists

#### Login

Authenticates a user and returns a JWT token.

- **URL**: `/login`
- **Method**: `POST`
- **Authentication Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "username": "string",
    "password": "string"
}
```

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
{
    "token": "string"
}
```

**Error Responses:**

- **Status Code**: 400 (Bad Request) - Invalid credentials

### Device Management

#### Get All Devices

Retrieves a list of all registered devices.

- **URL**: `/device`
- **Method**: `GET`
- **Authentication Required**: No

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
[
    {
        "id": 1,
        "macAddress": "AA:BB:CC:DD:EE:01",
        "name": "Wohnzimmer-Sensor",
        "localization": "Wohnzimmer",
        "createdAt": "2025-04-20T15:30:00Z"
    },
    ...
]
```

#### Get Device by MAC Address

Retrieves a device by its MAC address.

- **URL**: `/device/{macAddress}`
- **Method**: `GET`
- **Authentication Required**: No

**URL Parameters:**

- `macAddress`: MAC address of the device

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
{
    "id": 1,
    "macAddress": "AA:BB:CC:DD:EE:01",
    "name": "Wohnzimmer-Sensor",
    "localization": "Wohnzimmer",
    "createdAt": "2025-04-20T15:30:00Z"
}
```

**Error Responses:**

- **Status Code**: 404 (Not Found) - Device not found

#### Create Device

Registers a new device in the system.

- **URL**: `/device`
- **Method**: `POST`
- **Authentication Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "macAddress": "string",
    "name": "string",
    "localization": "string"
}
```

**Response:**

- **Status Code**: 201 (Created)
- **Body**: Empty

**Error Responses:**

- **Status Code**: 400 (Bad Request) - Invalid device data
- **Status Code**: 500 (Internal Server Error) - Server error

#### Request Device Registration

Requests registration for a device, allowing it to send data.

- **URL**: `/device/request`
- **Method**: `POST`
- **Authentication Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "macAddress": "string"
}
```

**Response:**

- **Status Code**: 201 (Created)
- **Body**: Empty

**Error Responses:**

- **Status Code**: 409 (Conflict) - Device already requested/registered

#### Get Requested Devices

Retrieves a list of all devices that have requested registration.

- **URL**: `/device/request/`
- **Method**: `GET`
- **Authentication Required**: Yes

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
[
    {
        "id": 1,
        "macAddress": "AA:BB:CC:DD:EE:06",
        "createdAt": "2025-04-20T15:30:00Z",
        "active": true
    },
    ...
]
```

#### Decline Device Registration

Declines a device registration request.

- **URL**: `/device/request/decline`
- **Method**: `POST`
- **Authentication Required**: Yes
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "macAddress": "string"
}
```

**Response:**

- **Status Code**: 200 (OK)
- **Body**: Empty

**Error Responses:**

- **Status Code**: 400 (Bad Request) - Invalid MAC address

### Sensor Readings

#### Get All Sensor Readings

Retrieves all sensor readings from all devices.

- **URL**: `/sensorreading`
- **Method**: `GET`
- **Authentication Required**: No

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
[
    {
        "id": 1,
        "deviceId": 1,
        "temperature": 21.5,
        "airQualityIndex": 125,
        "humidity": 45.2,
        "carbondioxide": 850,
        "createdAt": "2025-04-20T15:30:00Z"
    },
    ...
]
```

#### Get Sensor Readings by Device ID

Retrieves all sensor readings for a specific device.

- **URL**: `/sensorreading/device/{deviceId}`
- **Method**: `GET`
- **Authentication Required**: No

**URL Parameters:**

- `deviceId`: ID of the device

**Response:**

- **Status Code**: 200 (OK)
- **Body**:

```json
[
    {
        "id": 1,
        "deviceId": 1,
        "temperature": 21.5,
        "airQualityIndex": 125,
        "humidity": 45.2,
        "carbondioxide": 850,
        "createdAt": "2025-04-20T15:30:00Z"
    },
    ...
]
```

#### Create Sensor Reading

Adds a new sensor reading for a device.

- **URL**: `/sensorreading`
- **Method**: `POST`
- **Authentication Required**: No
- **Content-Type**: `application/json`

**Request Body:**

```json
{
    "deviceMacAddress": "string",
    "temperature": 21.5,
    "airQualityIndex": 125,
    "humidity": 45.2,
    "carbondioxide": 850
}
```

**Response:**

- **Status Code**: 201 (Created)
- **Body**: Empty

**Error Responses:**

- **Status Code**: 400 (Bad Request) - Invalid data or device not found
- **Status Code**: 500 (Internal Server Error) - Server error

## Error Response Format

All error responses follow this format:

```json
{
    "error": "Error message description"
}
```

## Request and Response Examples

### Example: User Registration

**Request:**

```
POST /register
Content-Type: application/json

{
    "username": "test",
    "password": "test"
}
```

**Response:**

```
Status: 201 Created
```

### Example: User Login

**Request:**

```
POST /login
Content-Type: application/json

{
    "username": "test",
    "password": "test"
}
```

**Response:**

```
Status: 200 OK
Content-Type: application/json

{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDUxNTIyOTQsInN1YiI6NH0.USUEg-_P2zToKZPayfDuygEvXm9CmXtnzrBVc1_Y1hs"
}
```

### Example: Get Devices

**Request:**

```
GET /device
```

**Response:**

```
Status: 200 OK
Content-Type: application/json

[
    {
        "id": 1,
        "macAddress": "AA:BB:CC:DD:EE:01",
        "name": "Wohnzimmer-Sensor",
        "localization": "Wohnzimmer",
        "createdAt": "2025-04-20T15:30:00Z"
    },
    {
        "id": 2,
        "macAddress": "AA:BB:CC:DD:EE:02",
        "name": "Küchen-Sensor",
        "localization": "Küche",
        "createdAt": "2025-04-20T15:31:00Z"
    }
]
```

### Example: Send Sensor Reading

**Request:**

```
POST /sensorreading
Content-Type: application/json

{
    "deviceMacAddress": "AA:BB:CC:DD:EE:01",
    "temperature": 23,
    "airQualityIndex": 130,
    "humidity": 45,
    "carbondioxide": 900
}
```

**Response:**

```
Status: 201 Created
```

## Data Types

### User

```json
{
    "id": 0,           // Integer
    "username": "",    // String
    "password": "",    // String (hashed)
    "createdAt": ""    // DateTime
}
```

### Device

```json
{
    "id": 0,             // Integer
    "macAddress": "",    // String
    "name": "",          // String
    "localization": "",  // String
    "createdAt": ""      // DateTime
}
```

### RequestDevice

```json
{
    "id": 0,             // Integer
    "macAddress": "",    // String
    "createdAt": "",     // DateTime
    "active": false      // Boolean
}
```

### SensorReading

```json
{
    "id": 0,                // Integer
    "deviceId": 0,          // Integer
    "temperature": 0.0,     // Float
    "airQualityIndex": 0,   // Integer
    "humidity": 0.0,        // Float
    "carbondioxide": 0.0,   // Float
    "createdAt": ""         // DateTime
}
```