/* eslint-disable no-sequences */
/* eslint-disable jsx-a11y/anchor-is-valid */
/* eslint-disable react/prop-types */
import React from 'react';
import {
  CollectionPreferences,
  // StatusIndicator,
  Link,
} from '@cloudscape-design/components';
import { addColumnSortLabels } from '../labels';

export const COLUMN_DEFINITIONS = addColumnSortLabels([
  {
    id: 'DeviceName',
    cell: (item) => (
      <Link href={`/micd-devices/${item.DeviceId}`}>{item.DeviceName}</Link>
    ),
    header: 'Device Name',
    minWidth: 120,
    maxWidth: 200,
    sortingField: 'DeviceName',
  },
  {
    id: 'DeviceId',
    header: 'Device Id',
    cell: (item) => item.DeviceId,
    minWidth: 200,
    sortingField: 'DeviceId',
  },
  {
    id: 'DeviceStatus',
    header: 'Device Status',
    cell: (item) => item.DeviceStatus,
    minWidth: 160,
    maxWidth: 200,
    sortingField: 'DeviceStatus',
  },
  // {
  //   id: 'Battery',
  //   header: 'Battery',
  //   cell: (item) => item.Battery,
  //   minWidth: 100,
  //   maxWidth: 100,
  //   sortingField: 'Battery',
  // },
  {
    id: 'SerialNumber',
    header: 'Serial Number',
    cell: (item) => item.SerialNumber,
    minWidth: 100,
    maxWidth: 100,
    sortingField: 'SerialNumber',
  },

  {
    id: 'ShortName',
    header: 'Short Name',
    cell: (item) => item.ShortName,
    minWidth: 100,
    sortingField: 'ShortName',
  },
  {
    id: 'Manufacturer',
    header: 'Manufacturer',
    cell: (item) => item.Manufacturer,
    minWidth: 100,
    sortingField: 'Manufacturer',
  },
  {
    id: 'Model',
    header: 'Model',
    cell: (item) => item.Model,
    minWidth: 100,
    sortingField: 'Model',
  },
  {
    id: 'RegisteredPatient',
    header: 'Registered Patient',
    cell: (item) => item.RegisteredPatient,
    minWidth: 100,
    sortingField: 'RegisteredPatient',
  },
  {
    id: 'FloorNumber',
    header: 'Floor Number',
    cell: (item) => item.FloorNumber,
    minWidth: 100,
    sortingField: 'FloorNumber',
  },
  {
    id: 'RoomNumber',
    header: 'Room Number',
    cell: (item) => item.RoomNumber,
    minWidth: 100,
    sortingField: 'RoomNumber',
  },

  // This eventually could be used for error handling
  // Could maybe have State of 'Verified', 'Unverified', 'Failed', etc. to give more info
  // {
  //   id: 'JobStatus',
  //   header: 'Job Status',
  //   //  cell: item => item.JobStatus,
  //   cell: (item) => (
  //     item.JobStatus,
  //     (
  //       <StatusIndicator type={item.state === 'Disabled' ? 'error' : 'success'}>
  //         {' '}
  //         {item.state}
  //         {item.JobStatus}
  //       </StatusIndicator>
  //     )
  //   ),
  //   minWidth: 100,
  //   sortingField: 'JobStatus',
  // },
]);

export const PAGE_SIZE_OPTIONS = [
  { value: 10, label: '10 MICDDevices' },
  { value: 30, label: '30 MICDDevices' },
  { value: 50, label: '50 MICDDevices' },
];

export const FILTERING_PROPERTIES = [
  {
    propertyLabel: 'Device Name',
    key: 'DeviceName',
    groupValuesLabel: 'Device Name values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Device Id',
    key: 'DeviceId',
    groupValuesLabel: 'DeviceId values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Device Status',
    key: 'DeviceStatus',
    groupValuesLabel: 'Device Status values',
    operators: [':', '!:', '=', '!='],
  },
  // {
  //   propertyLabel: 'Battery',
  //   key: 'Battery',
  //   groupValuesLabel: 'Battery values',
  //   operators: [':', '!:', '=', '!='],
  // },
  {
    propertyLabel: 'Short Name',
    key: 'ShortName',
    groupValuesLabel: 'Short Name values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Serial Number',
    key: 'SerialNumber',
    groupValuesLabel: 'Serial Number values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Manufacturer',
    key: 'Manufacturer',
    groupValuesLabel: 'Manufacturer values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Model',
    key: 'Model',
    groupValuesLabel: 'Model values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Registered Patient',
    key: 'RegisteredPatient',
    groupValuesLabel: 'Registered Patient values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Floor Number',
    key: 'FloorNumber',
    groupValuesLabel: 'Floor Number values',
    operators: [':', '!:', '=', '!='],
  },
  {
    propertyLabel: 'Room Number',
    key: 'FRoomNumber',
    groupValuesLabel: 'Room Number values',
    operators: [':', '!:', '=', '!='],
  },
];

export const PROPERTY_FILTERING_I18N_CONSTANTS = {
  filteringAriaLabel: 'your choice',
  dismissAriaLabel: 'Dismiss',

  filteringPlaceholder: 'Search',
  groupValuesText: 'Values',
  groupPropertiesText: 'Properties',
  operatorsText: 'Operators',

  operationAndText: 'and',
  operationOrText: 'or',

  operatorLessText: 'Less than',
  operatorLessOrEqualText: 'Less than or equal',
  operatorGreaterText: 'Greater than',
  operatorGreaterOrEqualText: 'Greater than or equal',
  operatorContainsText: 'Contains',
  operatorDoesNotContainText: 'Does not contain',
  operatorEqualsText: 'Equals',
  operatorDoesNotEqualText: 'Does not equal',

  editTokenHeader: 'Edit filter',
  propertyText: 'Property',
  operatorText: 'Operator',
  valueText: 'Value',
  cancelActionText: 'Cancel',
  applyActionText: 'Apply',
  allPropertiesLabel: 'All properties',

  tokenLimitShowMore: 'Show more',
  tokenLimitShowFewer: 'Show fewer',
  clearFiltersText: 'Clear filters',
  removeTokenButtonAriaLabel: () => 'Remove token',
  enteredTextLabel: (text) => `Use: "${text}"`,
};
export const CUSTOM_PREFERENCE_OPTIONS = [
  { value: 'table', label: 'Table' },
  { value: 'cards', label: 'Cards' },
];
export const DEFAULT_PREFERENCES = {
  pageSize: 30,
  visibleContent: [
    'DeviceName',
    'DeviceId',
    'DeviceStatus',
    // 'Battery',
    'ShortName',
    'SerialNumber',
    'Model',
    'RegisteredPatient',
    'FloorNumber',
    'RoomNumber',
  ],
  wraplines: false,
  custom: CUSTOM_PREFERENCE_OPTIONS[0].value,
};

export const VISIBLE_CONTENT_OPTIONS = [
  {
    label: 'Main MICD Devices Table properties',
    options: [
      { id: 'DeviceName', label: 'Device Name', editable: false },
      { id: 'DeviceId', label: 'Device ID', editable: true },
      { id: 'DeviceStatus', label: 'Device Status', editable: true },
      // { id: 'Battery', label: 'Battery', editable: true },
      { id: 'ShortName', label: 'Short Name', editable: true },
      { id: 'SerialNumber', label: 'Serial Number', editable: true },
      { id: 'Model', label: 'Model', editable: true },
      { id: 'RegisteredPatient', label: 'Registered Patient', editable: true },
      { id: 'FloorNumber', label: 'Floor Number', editable: true },
      { id: 'RoomNumber', label: 'Room Number', editable: true },

      // { id: 'CreatedAt', label: 'Created At', editable: true },
    ],
  },
];
export const Preferences = ({
  preferences,
  setPreferences,
  disabled,
  pageSizeOptions = PAGE_SIZE_OPTIONS,
  visibleContentOptions = VISIBLE_CONTENT_OPTIONS,
}) => (
  <CollectionPreferences
    title="Preferences"
    confirmLabel="Confirm"
    cancelLabel="Cancel"
    disabled={disabled}
    preferences={preferences}
    onConfirm={({ detail }) => setPreferences(detail)}
    pageSizePreference={{
      title: 'Page size',
      options: pageSizeOptions,
    }}
    wrapLinesPreference={{
      label: 'Wrap lines',
      description: 'Check to see all the text and wrap the lines',
    }}
    visibleContentPreference={{
      title: 'Select visible columns',
      options: visibleContentOptions,
    }}
  />
);
