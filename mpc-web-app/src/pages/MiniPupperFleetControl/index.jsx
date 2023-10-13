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
import { API, graphqlOperation, Amplify, PubSub, Auth, Hub } from 'aws-amplify';

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
const MiniPupperFleetControl = () => {
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
  useEffect(() => {
    fetchSingleMiniPupper();
  }, []);

  // Subscribe to the specific topic relating to the current MiniPupper on the page on page load
  useEffect(() => {
    const sub = PubSub.subscribe(`MP-global/sub`).subscribe({
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
      navigation={<Sidebar activeHref="/minipupper-fleet-control" />}
      // notifications={<Notifications successNotification={false} />}
      breadcrumbs={<Breadcrumbs />} // define these values in /breadcrumbs/index.js
      content={
        <ContentLayout
          header={
            <PageHeader
              buttons={[{ text: 'My MiniPuppers', href: '/my-minipuppers' }]}
              // buttons={[{ text: 'Edit' }, { text: 'Delete' }]}
              // loadHelpPanelContent={this.loadHelpPanelContent.bind(this)}
            />
          }
        >
          <SpaceBetween size="l">
            <MiniPupperDeviceDetailsTable isInProgress />
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

export default MiniPupperFleetControl;

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
          Global Commands
        </Header>
      }
    >
      {/* <MiniPupperDeviceDetailsTableConfig
        // Pass singleMiniPupper data as prop

        isInProgress={isInProgress}
      /> */}
      <MiniPupperCommandsTableConfig />
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
        text: 'Fleet Control',
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
    header={<h2>Fleet Control</h2>}
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
      This page is for managing your entire fleet at scale. Click the buttons to
      issue global commands to all connected MiniPuppers.
    </p>
  </HelpPanel>
);
