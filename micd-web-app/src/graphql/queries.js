/* eslint-disable */
// this is an auto generated file. This will be overwritten
export const getAllObjects = /* GraphQL */ `
  query GetAllObjects($limit: Int, $nextToken: String) {
    getAllObjects(limit: $limit, nextToken: $nextToken) {
      items {
        ObjectId
        Version
        DetailType
        Source
        FilePath
        AccountId
        CreatedAt
        Region
        CurrentBucket
        OriginalBucket
        ObjectSize
        SourceIPAddress
        LifecycleConfig
      }
      nextToken
    }
  }
`;
export const getAllObjectsPaginated = /* GraphQL */ `
  query GetAllObjectsPaginated($limit: Int, $nextToken: String) {
    getAllObjectsPaginated(limit: $limit, nextToken: $nextToken) {
      items {
        ObjectId
        Version
        DetailType
        Source
        FilePath
        AccountId
        CreatedAt
        Region
        CurrentBucket
        OriginalBucket
        ObjectSize
        SourceIPAddress
        LifecycleConfig
      }
      nextToken
    }
  }
`;
export const getOneObject = /* GraphQL */ `
  query GetOneObject($DeviceId: String!) {
    getOneBittle(ObjectId: $ObjectId) {
      ObjectId
      Version
      DetailType
      Source
      FilePath
      AccountId
      CreatedAt
      Region
      CurrentBucket
      OriginalBucket
      ObjectSize
      SourceIPAddress
      LifecycleConfig
    }
  }
`;

// - MICD Devices -
export const listIoTDevices = /* GraphQL */ `
  query ListIoTDevices($limit: Int, $nextToken: String) {
    listIoTDevices(limit: $limit, nextToken: $nextToken) {
      devices {
        DeviceId
        DeviceName
        DeviceStatus
        SerialNumber
        ShortName
        Manufacturer
        Model
        RegisteredPatient
        FloorNumber
        RoomNumber
      }
      nextToken
    }
  }
`;

export const getIoTDevice = /* GraphQL */ `
  query GetIoTDevice($DeviceId: String!) {
    getIoTDevice(DeviceId: $DeviceId) {
      DeviceId
      DeviceName
      DeviceStatus
      SerialNumber
      ShortName
      Manufacturer
      Model
      RegisteredPatient
      FloorNumber
      RoomNumber
    }
  }
`;

// - IoT Messages -
export const listIoTMessages = /* GraphQL */ `
  query ListIoTMessages($limit: Int, $nextToken: String) {
    listIoTMessages(limit: $limit, nextToken: $nextToken) {
      messages {
        MessageId
        Timestamp
        DeviceId
        SerialNumber
        DeviceName
        ShortName
        Manufacturer
        Model
        RegisteredPatient
        FloorNumber
        RoomNumber
        Message
      }
      nextToken
    }
  }
`;
// - IoT Messages -
export const listIoTMessagesByDeviceId = /* GraphQL */ `
  query ListIoTMessagesByDeviceId($DeviceId: String!, $limit: Int, $nextToken: String) {
    listIoTMessagesByDeviceId(DeviceId: $DeviceId, limit: $limit, nextToken: $nextToken) {
      messages {
        MessageId
        Timestamp
        DeviceId
        SerialNumber
        DeviceName
        ShortName
        Manufacturer
        Model
        RegisteredPatient
        FloorNumber
        RoomNumber
        Message
      }
      nextToken
    }
  }
`;

export const getIoTMessage = /* GraphQL */ `
  query GetIoTMessage($MessageId: String!) {
    getIoTMessage(MessageId: $MessageId) {
        MessageId
        Timestamp
        DeviceId
        SerialNumber
        DeviceName
        ShortName
        Manufacturer
        Model
        RegisteredPatient
        FloorNumber
        RoomNumber
        Message
    }
  }
`;
