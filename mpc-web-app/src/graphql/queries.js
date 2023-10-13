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
    getOneMiniPupprt(ObjectId: $ObjectId) {
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

// New
export const getAllMiniPuppers = /* GraphQL */ `
  query GetAllMiniPuppers($limit: Int, $nextToken: String) {
    getAllMiniPuppers(limit: $limit, nextToken: $nextToken) {
      items {
        DeviceId
        DeviceName
        DeviceStatus
        Battery
        ShortName
        ComputerModule
      }
      nextToken
    }
  }
`;
export const getAllMiniPuppersPaginated = /* GraphQL */ `
  query GetAllMiniPuppersPaginated($limit: Int, $nextToken: String) {
    getAllMiniPuppersPaginated(limit: $limit, nextToken: $nextToken) {
      items {
        DeviceId
        DeviceName
        DeviceStatus
        Battery
        ShortName
        ComputerModule
      }
      nextToken
    }
  }
`;
export const getOneMiniPupper = /* GraphQL */ `
  query GetOneMiniPupper($DeviceId: String!) {
    getOneMiniPupper(DeviceId: $DeviceId) {
      DeviceId
        DeviceName
        DeviceStatus
        Battery
        ShortName
        ComputerModule
    }
  }
`;
