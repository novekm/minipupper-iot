/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router';
import { v4 as uuidv4 } from 'uuid';
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
  MixedLineBarChart,
  PieChart
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

import { getIoTDevice } from '../../graphql/queries';

Hub.listen('pubsub', (data) => {
  const { payload } = data;
  if (payload.event === CONNECTION_STATE_CHANGE) {
    // const connectionState = payload.data.connectionState as ConnectionState;
    // const connectionState = payload.data.connectionState;
    console.log(payload.data.connectionState, payload);
  }
});

export const PageHeader = ({ buttons, singleMICDDevice }) => {
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
      {/* Reference 'singleMICDDevice' prop passed by SingleMICDDevice component in index.jsx */}
      {singleMICDDevice.DeviceName}
    </Header>
  );
};

//  - MICD Device Details Table -
// Content/formatting for the MICDDevice Device Details table
export const MICDDeviceDeviceDetailsTableConfig = ({
  isInProgress,
  singleMICDDevice,
}) => {
  // const micdDeviceData = singleMICDDevice;
  // console.log(micdDeviceData);

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Device Name</Box>
          <div>{singleMICDDevice.DeviceName}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Serial Number</Box>
          <div>{singleMICDDevice.SerialNumber}</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">Registered Patient</Box>
          <div>{singleMICDDevice.RegisteredPatient}</div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Device Id</Box>
          <div>{singleMICDDevice.DeviceId}</div>
        </div>

        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Model</Box>
          <div>{singleMICDDevice.Model}</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">Floor Number</Box>
          <div>{singleMICDDevice.FloorNumber}</div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Short Name</Box>
          <div>{singleMICDDevice.ShortName}</div>
        </div>
        {/* TODO - Use PubSub to update this in real-time */}
        {/* {singleMICDDevice.DeviceStatus ? (
          <StatusIndicator
            type={
              singleMICDDevice.DeviceStatus === 'Disconnected' ? 'error' : 'success'
            }
          >
            {singleMICDDevice.DeviceStatus}
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
        )} */}
        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Device Status</Box>
          <div>Connected</div>
        </div>

        {/* Third Item */}
        <div>
          <Box variant="awsui-key-label">Room Number</Box>
          <div>{singleMICDDevice.RoomNumber}</div>
        </div>
      </SpaceBetween>
      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>
  );
};

// - MICD Device Commands Table -
// OPTION 1 - Content/formatting for the MICDDevice Commands table
export const MICDDeviceCommandsTableConfig = ({ singleMICDDevice }) => {
  const singleMICDDeviceName = singleMICDDevice.DeviceName;
  const singleMICDDeviceId = singleMICDDevice.DeviceId;
  const singleMICDDeviceRegisteredPatient = singleMICDDevice.RegisteredPatient;

  let currentTimeObject = new Date();

  // let currentTimeISO = currentTimeObject.toISOString();
  // let currentTimeLocaleString = currentTimeObject.toISOString();
  let currentTimeLocaleString = currentTimeObject.toLocaleString();

  return (
    <ColumnLayout columns={3} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          <Box variant="awsui-key-label">Meals/Comfort</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I am hungry'
                })
                // console.log('UUID', uuidv4())
              }
            >
              I'm Hungry 🥙
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I am thirsty'
                })
              }
            >
              I'm Thirsty 🧃
            </Button>
            <Button
              onClick={() => {
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I am tired'
                });
                // console.log('you clicked me');
              }}
            >
              I'm Tired 😴
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I am cold'
                })
              }
            >
              I'm Cold 🥶
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I am hot'
                })
              }
            >
              I'm hot 🥵
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ SECOND COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">General Messages</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need to use the restroom'
                })
              }
            >
              Restroom 🚻
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I want to go outside'
                })
              }
            >
              Outside 🌳
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'What time is it?',
                })
              }
            >
              What time is it? ⏰
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I love you',
                })
              }
            >
              I love you 💟
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* ------------ THIRD COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* First Item */}
        <div>
          {/* TODO - Parse data for emissions_output with JSON.parse() */}
          <Box variant="awsui-key-label">Health</Box>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I do not feel well'
                })
              }
            >
              Sick 🤒
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need to see a doctor'
                })
              }
            >
              I need a doctor 🩺
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need my morning medicine'
                })
              }
            >
              Morning Medicine ⛅💊
            </Button>
          </div>
          <div>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need my midday medicine'
                })
              }
            >
              Midday Medicine 🌞💊
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need my evening medicine'
                })
              }
            >
              Evening Medicine 🌙💊
            </Button>
            <Button
              onClick={() =>
                PubSub.publish(`device/${singleMICDDeviceId}/data`, {
                  MessageId: uuidv4(),
                  Timestamp: currentTimeLocaleString,
                  DeviceId: `${singleMICDDeviceId}`,
                  SerialNumber: `${singleMICDDevice.SerialNumber}`,
                  DeviceName: `${singleMICDDevice.DeviceName}`,
                  ShortName: `${singleMICDDevice.ShortName}`,
                  Manufacturer:`${singleMICDDevice.Manufacturer}`,
                  Model: `${singleMICDDevice.Model}`,
                  RegisteredPatient: `${singleMICDDeviceRegisteredPatient}`,
                  FloorNumber: `${singleMICDDevice.FloorNumber}`,
                  RoomNumber: `${singleMICDDevice.RoomNumber}`,
                  Message: 'I need medicine'
                })
              }
            >
              Medicine 💊
            </Button>
          </div>
        </div>
      </SpaceBetween>

      {/* <div className="VideoStreamContainer">TODO - ADD KINESIS VIDEO HERE</div> */}
    </ColumnLayout>

  );
};


// Content/formatting for the MICDDevice Device Details table
export const MICDDeviceMetricsTableConfig = ({
  isInProgress,
  singleMICDDevice,
  iotMessages,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  const micdDeviceData = singleMICDDevice;
  console.log('MessagesTable/config.jsx', micdDeviceData);

  return (
    <ColumnLayout columns={1} variant="text-grid">
      {/* ------------ FIRST COLUMN ------------ */}
      <SpaceBetween size="l">
        {/* Second Item */}
        <div>
          <Box variant="awsui-key-label">Patient: {singleMICDDevice.RegisteredPatient}</Box>
          <PieChart
            data={Object.keys(pieChart).map(key =>
              ({
                title: key,
                value: pieChart[key]
              }))}
            detailPopoverContent={(datum, sum) => [
              { key: "Count", value: datum.value },
              {
                key: "Percentage",
                value: `${((datum.value / sum) * 100).toFixed(
                  0
                )}%`
              }
            ]}
            // segmentDescription={(datum) =>
            //   `${datum.value}`
            // }
            ariaDescription="Pie chart showing button pressed proportions."
            ariaLabel="Pie chart"
            size="large"
            legendTitle="Requests over all time"
            hideFilter
            hideTitles
            empty={
              <Box textAlign="center" color="inherit">
                <b>No data available</b>
                <Box variant="p" color="inherit">
                  There is no data available
                </Box>
              </Box>
            }
            noMatch={
              <Box textAlign="center" color="inherit">
                <b>No matching data</b>
                <Box variant="p" color="inherit">
                  There is no matching data to display
                </Box>
                <Button>Clear filter</Button>
              </Box>
            }
          />
        </div>
        {/* Second Item - Bar Chart */}
        <div>
          {/* <Box variant="awsui-key-label">Chart 1</Box> */}
          <MixedLineBarChart
            series={[
              {
                title: "Buttons pressed",
                type: "bar",
                data: Object.keys(qualifiedMonthMap).map(key =>
                  ({
                    x: key,
                    y: qualifiedMonthMap[key]
                  }))
              },
              {
                title: "Buttons last year",
                type: "line",
                data: Object.keys(qualifiedMonthMap).map(key =>
                    ({
                      x: key,
                      y: qualifiedMonthMap[key]
                    }))
              }
            ]}
            xDomain={
              lastTwelveMonth.map((monthYear) => monthYear)
            }
            yDomain={[0, 20]}
            i18nStrings={{
              yTickFormatter: function s(t) {
                return Math.abs(t) >= 1e9
                  ? (t / 1e9).toFixed(1).replace(/\.0$/, "") +
                      "G"
                  : Math.abs(t) >= 1e6
                  ? (t / 1e6).toFixed(1).replace(/\.0$/, "") +
                    "M"
                  : Math.abs(t) >= 1e3
                  ? (t / 1e3).toFixed(1).replace(/\.0$/, "") +
                    "K"
                  : t.toFixed(0);
              }
            }}
            ariaLabel="Mixed bar chart"
            height={300}
            xScaleType="categorical"
            yTitle="Number of requests over last 12 months"
            hideFilter
            empty={
              <Box textAlign="center" color="inherit">
                <b>No data available</b>
                <Box variant="p" color="inherit">
                  There is no data available
                </Box>
              </Box>
            }
            noMatch={
              <Box textAlign="center" color="inherit">
                <b>No matching data</b>
                <Box variant="p" color="inherit">
                  There is no matching data to display
                </Box>
                <Button>Clear filter</Button>
              </Box>
            }
          />
        </div>
      </SpaceBetween>
    </ColumnLayout>
  );
};
