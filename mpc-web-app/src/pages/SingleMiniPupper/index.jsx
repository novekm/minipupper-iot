/* eslint-disable no-console */
/* eslint-disable react-hooks/exhaustive-deps */
/* eslint-disable react/prop-types */
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
import { Link, useNavigate, useParams } from 'react-router-dom';
// COMPONENT IMPORTS
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

// Amplify
import { API, graphqlOperation, Amplify, Auth, PubSub, Hub } from 'aws-amplify';
import {
  AWSIoTProvider,
  CONNECTION_STATE_CHANGE,
  ConnectionState,
} from '@aws-amplify/pubsub';

// Common
import {
  ExternalLinkItem,
  InfoLink,
  Navigation,
  TableHeader,
} from '../../common/common-components-config';
import Sidebar from '../../common/components/Sidebar';

// Page configuration components
import {
  PageHeader,
  MiniPupperDeviceDetailsTableConfig,
  MiniPupperCommandsTableConfig,
  MiniPupperCommandsTableConfig2,
} from './config';

// API functions
import { getOneMiniPupper } from '../../graphql/queries';

// Styles
import '../../common/styles/base.scss';

// Main component for page
const SingleMiniPupper = () => {
  const [toolsOpen, setToolsOpen] = useState(false);
  const { DeviceId } = useParams();
  const [singleMiniPupper, setSingleMiniPupper] = useState([]);

  // Fetch data for one MiniPupper by 'DeviceId' specified in browser URL via useParams hook
  const fetchSingleMiniPupper = async () => {
    try {
      const singleMiniPupperData = await API.graphql(
        graphqlOperation(getOneMiniPupper, { DeviceId: `${DeviceId}` })
      );
      const singleMiniPupperDataList = singleMiniPupperData.data.getOneMiniPupper;
      console.log('Single MiniPupper List', singleMiniPupperDataList);
      setSingleMiniPupper(singleMiniPupperDataList);
      // setLoading(false)
    } catch (error) {
      console.log('error on fetching single MiniPupper', error);
    }
  };

  // Run the fetchSingleMiniPupper() function on page load
  // useEffect(() => {
  // }, []);

  // Subscribe to the specific topic relating to the current MiniPupper on the page on page load
  useEffect(() => {
    fetchSingleMiniPupper();
    // const sub = PubSub.subscribe(`MiniPupper1/sub`).subscribe({
    const sub = PubSub.subscribe(`${singleMiniPupper.DeviceName}/sub`).subscribe({
      next: (data) => console.log('Message received', data),
      error: (error) => console.error(error),
      complete: () => console.log('Done'),
    });
    console.log('subscribe');
    console.log(`${singleMiniPupper.DeviceName}`);
    return () => {
      sub.unsubscribe();
    };
  }, []);
  // Subscribe to the specific global topic relating to the current MiniPupper on the page on page load
  useEffect(() => {
    const sub = PubSub.subscribe(
      `${singleMiniPupper.DeviceName}/sub-global`
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
      navigation={<Sidebar activeHref="/single-minipupper" />}
      // notifications={<Notifications successNotification={false} />}
      breadcrumbs={<Breadcrumbs singleMiniPupper={singleMiniPupper} />} // define these values in /breadcrumbs/index.js
      content={
        <ContentLayout
          header={
            <PageHeader
              singleMiniPupper={singleMiniPupper}
              buttons={[{ text: 'My MiniPuppers', href: '/my-minipuppers' }]}
              // buttons={[{ text: 'Edit' }, { text: 'Delete' }]}
              // loadHelpPanelContent={this.loadHelpPanelContent.bind(this)}
            />
          }
        >
          <SpaceBetween size="l">
            <MiniPupperDeviceDetailsTable
              singleMiniPupper={singleMiniPupper}
              isInProgress
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

export default SingleMiniPupper;

// MiniPupper Device Details Table - Configuration is in config.jsx
const MiniPupperDeviceDetailsTable = ({
  singleMiniPupper,
  loadHelpPanelContent,
  isInProgress,
  setToolsOpen,
}) => {
  return (
    <Container
      header={
        <Header variant="h2">
          {/* Table Title */}
          Device Details
        </Header>
      }
    >
      <MiniPupperDeviceDetailsTableConfig
        // Pass singleMiniPupper data as prop
        singleMiniPupper={singleMiniPupper}
        isInProgress={isInProgress}
      />
      <MiniPupperCommandsTableConfig singleMiniPupper={singleMiniPupper} />
      {/* Option 2 for commands layout */}
      {/* <MiniPupperCommandsTableConfig2 /> */}
    </Container>
  );
};

export const Breadcrumbs = ({ singleMiniPupper }) => (
  <BreadcrumbGroup
    items={[
      {
        text: ' MiniPupper Control',
        href: '/dashboard',
      },
      {
        text: 'My MiniPuppers',
        href: '/my-minipuppers',
      },
      {
        text: `${singleMiniPupper.DeviceName}`,
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
              href="https://ghgprotocol.org/Third-Party-Databases/IPCC-Emissions-Factor-Database"
              text="IPCC Emissions Factor Database"
            />
          </li>
          <li>
            <ExternalLinkItem
              href="https://aws.amazon.com/energy/"
              text="AWS Energy & Utilities"
            />
          </li>
          <li>
            <ExternalLinkItem
              href="https://ghgprotocol.org/"
              text="GHG Protocol Guidance"
            />
          </li>
        </ul>
      </>
    }
  >
    <p>
      This page is a view into your selected MiniPupper and related information such
      as the Device Name, Device Id, Device Status, Battery, and more.
    </p>
  </HelpPanel>
);
