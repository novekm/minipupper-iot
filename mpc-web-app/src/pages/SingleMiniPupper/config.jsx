/* eslint-disable camelcase */
/* eslint-disable no-console */
/* eslint-disable react-hooks/exhaustive-deps */
/* eslint-disable no-use-before-define */
/* eslint-disable react/no-array-index-key */
/* eslint-disable react/prop-types */
/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router';
import {
  Box,
  BreadcrumbGroup,
  Button,
  ButtonDropdown,
  ColumnLayout,
  Container,
  Header,
  ProgressBar,
  StatusIndicator,
  SpaceBetween,
  Table,
} from '@cloudscape-design/components';
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
import {
  AWSIoTProvider,
  CONNECTION_STATE_CHANGE,
  // PubSub,
  ConnectionState,
} from '@aws-amplify/pubsub';
import {
  TableEmptyState,
  InfoLink,
} from '../../common/common-components-config';

import { getOneMiniPupper } from '../../graphql/queries';

Hub.listen('pubsub', (data) => {
  const { payload } = data;
  if (payload.event === CONNECTION_STATE_CHANGE) {
    // const connectionState = payload.data.connectionState as ConnectionState;
    // const connectionState = payload.data.connectionState;
    console.log(payload.data.connectionState, payload);
  }
});

export const PageHeader = ({ buttons, singleMiniPupper }) => {
  return (
    <Header
      variant="h1"
      actions={
        <SpaceBetween direction="horizontal" size="xs">
          {buttons.map((button, key) =>
            !button.items ? (
              <Button
                href={button.href || ''}
                disabled={button.disabled || false}
                key={key}
              >
                {button.text}
              </Button>
            ) : (
              <ButtonDropdown items={button.items} key={key}>
                {button.text}
              </ButtonDropdown>
            )
          )}
        </SpaceBetween>
      }
    >
      {/* Reference 'singleMiniPupper' prop passed by SingleMiniPupper component in index.jsx */}
      {singleMiniPupper.DeviceName}
    </Header>
  );
};

// Content/formatting for the MiniPupper Device Details table
export const MiniPupperDeviceDetailsTableConfig = ({
  isInProgress,
  singleMiniPupper,
}) => {
  const minipupperData = singleMiniPupper;
  console.log(minipupperData);

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Device Name</Box>
          <div>{singleMiniPupper.DeviceName}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Device Id</Box>
          <div>{singleMiniPupper.DeviceId}</div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">Short Name</Box>
          <div>{singleMiniPupper.ShortName}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Computer Module</Box>
          <div>{singleMiniPupper.ComputerModule}</div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        {singleMiniPupper.DeviceStatus ? (
          <StatusIndicator
            type={
              singleMiniPupper.DeviceStatus === 'Disconnected' ? 'error' : 'success'
            }
          >
            {singleMiniPupper.DeviceStatus}
          </StatusIndicator>
        ) : (
          <ProgressBar
            value={27}
            label="Battery"
            // description={isInProgress ? 'Update in progress' : undefined}
            variant="key-value"
            resultText="Available"
            status={isInProgress ? 'in-progress' : 'success'}
          />
        )}
        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Device Status</Box>
          <div>Connected</div>
        </div>
      </SpaceBetween>
      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>
  );
};
// OPTION 1 - Content/formatting for the MiniPupper Commands table
export const MiniPupperCommandsTableConfig = ({ singleMiniPupper }) => {
  const singleMiniPupperName = singleMiniPupper.DeviceName;
  console.log(
    'MiniPupperCommandsTableConfig - Single MiniPupper Name:',
    singleMiniPupperName
  );

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Movements</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kwkF' })
              }
            >
              Forward
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kwkL' })
              }
            >
              Forward L
            </Button>
            <Button
              onClick={() => {
                PubSub.publish(`MP1/sub`, { message: 'kwkR' });
                console.log('you clicked me');
              }}
            >
              Forward R
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kbkL' })
              }
            >
              Back L
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kbkR' })
              }
            >
              Back R
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kbk' })
              }
            >
              Back
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, {
                  message: 'kbalance',
                })
              }
              variant="primary"
            >
              Stop
            </Button>
            <Button
              onClick={
                () =>
                  PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'd' })
                // PubSub.publish(`MiniPupper2/sub`, { message: 'd' })
              }
              variant="primary"
            >
              Rest
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">Mode</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'g' })
              }
            >
              Gyro On/Off
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'c' })
              }
            >
              Calibration
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, {
                  message: 'kbalance',
                })
              }
            >
              Balanced
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">Actions</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kwkF' })
              }
            >
              Walk
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'ksit' })
              }
            >
              Sit
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'khi' })
              }
            >
              Hello
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kpee' })
              }
            >
              Pee
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'ktrF' })
              }
            >
              Trot
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kck' })
              }
            >
              Check
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kvtF' })
              }
            >
              Stepping
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kpu' })
              }
            >
              Push Ups
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kstr' })
              }
            >
              Stretch
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, {
                  message: 'kbuttUp',
                })
              }
            >
              Butt Up
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'krnF' })
              }
            >
              Run
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`${singleMiniPupperName}/sub`, { message: 'kcrF' })
              }
            >
              Crawl
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>
  );
};
// OPTION 2 - Content/formatting for the MiniPupper Commands table
export const MiniPupperCommandsTableConfig2 = () => {
  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Actions</Box>
          <div>
            <Button>Walk</Button>
            <Button>Sit</Button>
          </div>
          <div>
            <Button>Hello</Button>
            <Button>Pee</Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label"> More Actions</Box>
          <div>
            <Button>Trot</Button>
            <Button>Check</Button>
          </div>
          <div>
            <Button>Stretch</Button>
            <Button>Push Ups</Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Even MORE Actions</Box>
          <div>
            <Button>Crawl</Button>
            <Button>Buttup</Button>
          </div>
          <div>
            <Button>Run</Button>
            <Button>Stepping</Button>
          </div>
        </div>
      </SpaceBetween>

      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>
  );
};

// May not need this

// export const EmptyTable = props => {
//   const resourceType = props.title || 'Tag';
//   const colDefs = props.columnDefinitions || TAGS_COLUMN_DEFINITIONS;
//   return (
//     <Table
//       empty={<TableEmptyState resourceName={resourceType} />}
//       columnDefinitions={colDefs}
//       items={[]}
//       header={
//         <Header
//           actions={
//             <SpaceBetween size="xs" direction="horizontal">
//               <Button disabled={true}>Edit</Button>
//               <Button disabled={true}>Delete</Button>
//               <Button>Create {resourceType.toLowerCase()}</Button>
//             </SpaceBetween>
//           }
//         >{`${resourceType}s`}</Header>
//       }
//     />
//   );
// };
