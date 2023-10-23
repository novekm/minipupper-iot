/** **********************************************************************
                            DISCLAIMER

This is just a playground package. It does not comply with best practices
of using Cloudscape Design components. For production code, follow the
integration guidelines:

https://cloudscape.design/patterns/patterns/overview/
*********************************************************************** */
import React, { useState, useEffect } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';

// - CLOUDSCAPE -
import {
  BreadcrumbGroup,
  Button,
  AppLayout,
  Container,
  Header,
  HelpPanel,
  Icon,
  SpaceBetween,
  ContentLayout,
} from '@cloudscape-design/components';

// - COMMON -
import {
  ExternalLinkItem,
  InfoLink,
  Navigation,
  TableHeader,
} from '../../common/common-components-config';
import Sidebar from '../../common/components/Sidebar';

// - CORE COMPONENTS -
import {
  PageHeader,
  MICDDeviceDeviceDetailsTableConfig,
  MICDDeviceCommandsTableConfig,
  MICDDeviceMetricsTableConfig,
  // MICDDeviceCommandsTableConfig2,
} from './config';
import MessagesTable from './MessagesTable'

// - STYLES -
import '../../common/styles/base.scss';

// - ASSETS -

// - AMPLIFY -
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
import {
  AWSIoTProvider,
  CONNECTION_STATE_CHANGE,
  ConnectionState,
} from '@aws-amplify/pubsub';

// - API FUNCTIONS -
import {
  getIoTDevice,
  listIoTDevices,
  getIoTMessage,
  listIoTMessages,
  listIoTMessagesByDeviceId,
} from '../../graphql/queries';


// Main component for page
const SingleMICDDevice = () => {
  const [toolsOpen, setToolsOpen] = useState(false);
  const { DeviceId } = useParams();
  const [singleMICDDevice, setSingleMICDDevice] = useState([]);
  const [iotMessages, setIoTMessages] = useState([]);
  const [lastTwelveMonth, setLastTwelveMonth] = useState([]);
  const [qualifiedMonthMap, setQualifiedMonths] = useState([]);
  const [pieChart, setPieChart] = useState([]);

  // Fetch data for one MICD Device by 'DeviceId' specified in browser URL via useParams hook
  const fetchSingleMICDDevice = async () => {
    try {
      const singleMICDDeviceData = await API.graphql(
        graphqlOperation(getIoTDevice, { DeviceId: `${DeviceId}` })
      );
      const singleMICDDeviceDataList = singleMICDDeviceData.data.getIoTDevice;
      console.log('Single MICD Device List', singleMICDDeviceDataList);
      setSingleMICDDevice(singleMICDDeviceDataList);
      // setLoading(false)
    } catch (error) {
      console.log('error on fetching single MICDDevice', error);
    }
  };
  // // Fetch data for all IoT messages in the MICD_MQTT DynamoDB table
  // const fetchIoTMessages = async () => {
  //   try {
  //     const iotMessagesData = await API.graphql(
  //       graphqlOperation(listIoTMessages, { limit: 10000 })
  //     );

  //     const iotMessagesDataList = iotMessagesData.data.listIoTMessages.messages;
  //     console.log('IoTMessagesFromDynamoDB<SingleMICDDevice/index.jsx>', iotMessagesDataList);
  //     getPieChartMap(iotMessagesDataList);
  //     getLastTwelveMonthAndQualifiedMonths(iotMessagesDataList);
  //     setIoTMessages(iotMessagesDataList);
  //     // setLoading(false)
  //   } catch (error) {
  //     console.log('error on fetching IoT Messages', error);
  //   }
  // };
  // Fetch data for all IoT messages filtered by DeviceId in the MICD_MQTT DynamoDB table
  const fetchIoTMessagesByDeviceId = async () => {
    try {
      const iotMessagesData = await API.graphql(
        graphqlOperation(listIoTMessagesByDeviceId, {DeviceId: DeviceId, limit: 10000 })
      );

      const iotMessagesDataList = iotMessagesData.data.listIoTMessagesByDeviceId.messages;
      console.log('IoTMessagesFromDynamoDB<SingleMICDDevice/index.jsx>', iotMessagesDataList);
      getPieChartMap(iotMessagesDataList);
      getLastTwelveMonthAndQualifiedMonths(iotMessagesDataList);
      setIoTMessages(iotMessagesDataList);
      // setLoading(false)
    } catch (error) {
      console.log('error on fetching IoT Messages', error);
    }
  };

  // Get messages list for PieChart graph
  const getPieChartMap = async (iotMessages) => {
      const iotMessagesList = iotMessages.map((iotMessage) => iotMessage.Message);
      const pieChartMap = iotMessagesList.reduce((acc, curr) => {
        acc[curr] = (acc[curr] || 0) + 1;
        return acc;
      }, {});

      setPieChart(pieChartMap);
  }

  // Get the last 12 months from today's date
  const getLastTwelveMonthAndQualifiedMonths = async (iotMessages) => {
    var theMonths = new Array("January", "February", "March", "April", "May", "June",
                              "July", "August", "September", "October", "November", "December");
    var now = new Date();
    const lastTwelveMonth = [];
    for (var i = 0; i > -12; i--) {
      var past = new Date(now.getFullYear(), now.getMonth() + i, 1);
      var month = theMonths[past.getMonth()];
      var year = past.getFullYear().toString();
      lastTwelveMonth.unshift(month + ' ' + year);
    }

    // Get intersection of last 12 months and months in our dataset
    const timeStamps = iotMessages.map((iotMessage) => new Date(iotMessage.Timestamp)
                                  .toLocaleString('default', { month: 'long' }) + " " + new Date(iotMessage.Timestamp)
                                  .getFullYear());
    const qualifiedMonths = timeStamps.filter((x) => lastTwelveMonth.includes(x));
    const qualifiedMonthMap = qualifiedMonths.reduce((acc, curr) => {
      acc[curr] = (acc[curr] || 0) + 1;
      return acc;
    }, {});

    setQualifiedMonths(qualifiedMonthMap);
    setLastTwelveMonth(lastTwelveMonth);
  }

  // Run the fetchSingleMICDDevice() function on page load
  // useEffect(() => {
  // }, []);

  // Subscribe to the specific topic relating to the current MICDDevice on the page on page load
  useEffect(() => {
    fetchSingleMICDDevice();
    // fetchIoTMessages();
    fetchIoTMessagesByDeviceId();

    const sub = PubSub.subscribe(`device/${singleMICDDevice.DeviceId}/data`).subscribe({
      next: (data) => console.log('Message received', data),
      error: (error) => console.error(error),
      complete: () => console.log('Done'),
    });
    console.log('subscribe');
    console.log(`${singleMICDDevice.DeviceName}`);
    return () => {
      sub.unsubscribe();
    };
  }, []);
  // Subscribe to the specific global topic relating to the current MICDDevice on the page on page load
  useEffect(() => {
    const sub = PubSub.subscribe(
      `${singleMICDDevice.DeviceName}/sub-global`
    ).subscribe({
      next: (data) => console.log('Message received', data),
      error: (error) => console.error(error),
      complete: () => console.log('Done'),
    });
    return () => {
      sub.unsubscribe();
    };
  }, []);

  return (
    <AppLayout
      navigation={<Sidebar activeHref="/micd-devices" />}
      // notifications={<Notifications successNotification={false} />}
      breadcrumbs={<Breadcrumbs singleMICDDevice={singleMICDDevice} />} // define these values in /breadcrumbs/index.js
      content={
        <ContentLayout
          header={
            <PageHeader
              singleMICDDevice={singleMICDDevice}
              buttons={[{ text: 'MICD Devices', href: '/micd-devices' }]}
              // buttons={[{ text: 'Edit' }, { text: 'Delete' }]}
              // loadHelpPanelContent={this.loadHelpPanelContent.bind(this)}
            />
          }
        >
          <SpaceBetween size="l">
            <MICDDeviceDeviceDetailsTable
              singleMICDDevice={singleMICDDevice}
              isInProgress
              lastTwelveMonth={lastTwelveMonth}
              qualifiedMonthMap={qualifiedMonthMap}
              pieChart={pieChart}
            />
          </SpaceBetween>
            <MessagesTable
              singleMICDDevice={singleMICDDevice}
              iotMessages={iotMessages}
              />
          <SpaceBetween size="l">
            <MICDDeviceDeviceMetricsTable
              singleMICDDevice={singleMICDDevice}
              isInProgress
              lastTwelveMonth={lastTwelveMonth}
              qualifiedMonthMap={qualifiedMonthMap}
              pieChart={pieChart}
            />
          </SpaceBetween>
        </ContentLayout>

      }
      contentType="table"
      tools={<ToolsContent />}
      toolsOpen={toolsOpen}
      onToolsChange={({ detail }) => setToolsOpen(detail.open)}
      stickyNotifications
    />
  );
};

export default SingleMICDDevice;

// MICDDevice Device Details Table - Configuration is in config.jsx
const MICDDeviceDeviceDetailsTable = ({
  singleMICDDevice,
  iotMessages,
  loadHelpPanelContent,
  isInProgress,
  setToolsOpen,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  return (
    <>
      <Container
        header={
          <Header variant="h2">
            Device Details
          </Header>
        }
        >
        <MICDDeviceDeviceDetailsTableConfig
          // Pass singleMICDDevice data as prop
          singleMICDDevice={singleMICDDevice}
          isInProgress={isInProgress}
          />
        <MICDDeviceCommandsTableConfig singleMICDDevice={singleMICDDevice} />
        {/* Option 2 for commands layout */}
        {/* <MICDDeviceCommandsTableConfig2 /> */}
      </Container>
    </>
  );
};
// MICDDevice Device Details Table - Configuration is in config.jsx
const MICDDeviceDeviceMetricsTable = ({
  singleMICDDevice,
  iotMessages,
  loadHelpPanelContent,
  isInProgress,
  setToolsOpen,
  lastTwelveMonth,
  qualifiedMonthMap,
  pieChart
}) => {
  return (
    <>
      <Container
        header={
          <Header variant="h2">
            Device Metrics
          </Header>
        }
        >
        <MICDDeviceMetricsTableConfig
          // Pass singleMICDDevice data as prop
          singleMICDDevice={singleMICDDevice}
          isInProgress={isInProgress}
          lastTwelveMonth={lastTwelveMonth}
          qualifiedMonthMap={qualifiedMonthMap}
          pieChart={pieChart}
          />

      </Container>
      {/* <Container>
      </Container> */}
        {/* <MessagesTable
          iotMessages={iotMessages}
        /> */}
    </>
  );
};

export const Breadcrumbs = ({ singleMICDDevice }) => (
  <BreadcrumbGroup
    items={[
      {
        text: 'MICD App',
        href: '/dashboard',
      },
      {
        text: 'MICD Devices',
        href: '/micd-devices',
      },
      {
        text: `${singleMICDDevice.DeviceName}`,
        href: '#',
      },
    ]}
    expandAriaLabel="Show path"
    ariaLabel="Breadcrumbs"
  />
);

// Info pop out window seen when clicking 'info' or the i in a circle button on right side of page
export const ToolsContent = () => (
  <HelpPanel
    header={<h2>Device Details</h2>}
    footer={
      <>
        <h3>
          Learn more{' '}
          <span role="img" aria-label="Icon external Link">
            <Icon name="external" />
          </span>
        </h3>
        <ul>
          <li>
            <ExternalLinkItem
              href="https://aws.amazon.com/energy/"
              text="AWS Energy & Utilities"
            />
          </li>
          <li>
            <ExternalLinkItem
              href="https://github.com/BeccaLSmith/MICD"
              text="MICD GitHub Repo"
            />
          </li>
        </ul>
      </>
    }
  >
    <p>
      This page is a view into your selected MICD Device and related information such
      as the Device Name, Device Id, Device Status, Registered Patient, and more.
    </p>
  </HelpPanel>
);
