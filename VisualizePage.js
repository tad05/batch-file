// Copyright 2025 ROBOTIS CO., LTD.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Author: Kiwoong Park

import React, { useState, useEffect, useCallback } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import clsx from 'clsx';
import toast, { useToasterStore } from 'react-hot-toast';
import { MdKeyboardDoubleArrowLeft, MdKeyboardDoubleArrowRight, MdTask } from 'react-icons/md';
import { LuListVideo } from "react-icons/lu";
import { FiChevronDown } from "react-icons/fi";
import ControlPanel from '../components/ControlPanel';
import TokenInputPopup from '../components/TokenInputPopup';
import ImageGrid from '../components/ImageGrid';
import EpisodePannel from '../components/EpisodePannel';
import { addTag } from '../features/tasks/taskSlice';
import { setIsFirstLoadFalse } from '../features/ui/uiSlice';
import { useRosServiceCaller } from '../hooks/useRosServiceCaller';
import {useCombobox} from 'downshift';

export default function VisualizePage({ isActive = true }) {
  const dispatch = useDispatch();
  const { registerHFUser, getRegisteredHFUser } = useRosServiceCaller();

  const taskInfo = useSelector((state) => state.tasks.taskInfo);
  const taskStatus = useSelector((state) => state.tasks.taskStatus);
  const useMultiTaskMode = useSelector((state) => state.tasks.useMultiTaskMode);
  const multiTaskIndex = useSelector((state) => state.tasks.multiTaskIndex);

  // Toast limit implementation using useToasterStore
  const { toasts } = useToasterStore();
  const TOAST_LIMIT = 3;

  const [isRightPanelCollapsed, setIsRightPanelCollapsed] = useState(false);

  const isFirstLoad = useSelector((state) => state.ui.isFirstLoad.record);

  // User ID list for dropdown
  const [userIdList, setUserIdList] = useState([]);

  // Token popup states
    const [showTokenPopup, setShowTokenPopup] = useState(false);
    const [isLoading, setIsLoading] = useState(false);

  // useEffect(() => {
  //   toasts
  //     .filter((t) => t.visible) // Only consider visible toasts
  //     .filter((_, i) => i >= TOAST_LIMIT) // Is toast index over limit?
  //     .forEach((t) => toast.dismiss(t.id)); // Dismiss – Use toast.remove(t.id) for no exit animation
  // }, [toasts]);

  const handleTokenSubmit = async (token) => {
    if (!token || !token.trim()) {
      toast.error('Please enter a token');
      return;
    }

    setIsLoading(true);
    try {
      const result = await registerHFUser(token);
      console.log('registerHFUser result:', result);

      if (result && result.user_id_list) {
        setUserIdList(result.user_id_list);
        setShowTokenPopup(false);
        toast.success('User ID list updated successfully!');
      } else {
        toast.error('Failed to get user ID list from response');
      }
    } catch (error) {
      console.error('Error registering HF user:', error);
      toast.error(`Failed to register user: ${error.message}`);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLoadUserId = useCallback(async () => {
      setIsLoading(true);
      try {
        const result = await getRegisteredHFUser();
        console.log('getRegisteredHFUser result:', result);
  
        if (result && result.user_id_list) {
          if (result.success) {
            setUserIdList(result.user_id_list);
            toast.success('User ID list loaded successfully!');
            //setShowUserIdDropdown(true);
          } else {
            toast.error('Failed to get user ID list:\n' + result.message);
          }
        } else {
          toast.error('Failed to get user ID list from response');
        }
      } catch (error) {
        console.error('Error loading HF user list:', error);
        toast.error(`Failed to load user ID list: ${error.message}`);
      } finally {
        setIsLoading(false);
      }
    }, [getRegisteredHFUser]);

  useEffect(() => {
      handleLoadUserId();
    }, [handleLoadUserId]);

  const classMainContainer = 'h-full flex flex-col overflow-hidden';
  const classContentsArea = 'flex-1 flex min-h-0 pt-0 px-0 justify-center items-start';
  const classImageGridContainer = clsx(
    'transition-all',
    'duration-300',
    'ease-in-out',
    'flex',
    'items-center',
    'justify-center',
    'min-h-0',
    'h-full',
    'overflow-hidden',
    'm-2',
    {
      'flex-[10]': isRightPanelCollapsed,
      'flex-[20]': !isRightPanelCollapsed,
    }
  );

  const classRightPanelArea = clsx(
    'h-full',
    'w-full',
    'transition-all',
    'duration-300',
    'ease-in-out',
    'relative',
    'overflow-y-auto',
    {
      'flex-[0_0_40px]': isRightPanelCollapsed,
      'flex-[1]': !isRightPanelCollapsed,
      'min-w-[60px]': isRightPanelCollapsed,
      'min-w-[350px]': !isRightPanelCollapsed,
      'max-w-[60px]': isRightPanelCollapsed,
      'max-w-[350px]': !isRightPanelCollapsed,
    }
  );

  const classHideButton = clsx(
    'absolute',
    'top-3',
    'bg-white',
    'border',
    'border-gray-300',
    'rounded-full',
    'w-12',
    'h-12',
    'flex',
    'items-center',
    'justify-center',
    'shadow-md',
    'hover:bg-gray-50',
    'transition-all',
    'duration-200',
    'z-10',
    {
      'left-2': isRightPanelCollapsed,
      'left-[10px]': !isRightPanelCollapsed,
    }
  );

  const classRightPanel = clsx(
    'h-full',
    'flex',
    'flex-col',
    'items-center',
    'overflow-hidden',
    'transition-opacity',
    'duration-300',
    {
      'opacity-0': isRightPanelCollapsed,
      'opacity-100': !isRightPanelCollapsed,
      'pointer-events-none': isRightPanelCollapsed,
      'pointer-events-auto': !isRightPanelCollapsed,
    }
  );
// Common button base styles
  const classButtonBase = clsx(
    'px-3',
    'py-1',
    'mx-1',
    'text-s',
    'font-medium',
    'rounded-xl'
  );
 const items = ['User_12345678951213121123231121312316874113668', 'User_002', 'User_003', 'User_004', 'User_005']

  return (
    <div className={classMainContainer}>
      <div className={classContentsArea}>
        <div className="w-full h-full flex flex-col relative">
          <div className="w-full flex flex-col p-10 gap-6">
              <h1 className="text-4xl font-bold flex flex-row items-center gap-2">
              <LuListVideo className="w-10 h-10" />
              Data Tools
              </h1>
          </div>
          <div className="w-full flex flex-col pl-10 gap-3">
            <div className={clsx('flex', 'items-start', 'items-baseline')}>
              <span
                className={clsx(
                  'inline-block',
                  'text-sm',
                  'text-gray-600',
                  'w-30',
                  'flex-shrink-0',
                  'font-medium',
                  'pt-2'
                )}
              >
                User ID
              </span>
              <DropdownCombobox placeholder={"Select User ID"} dataList={items} initItem={"User_002"}/>
              <button
                className={clsx(classButtonBase, 'bg-blue-200 text-blue-800 hover:bg-blue-300')}
                onClick={() => {
                    if (!isLoading) {
                      handleLoadUserId();
                    }
                  }}
                  disabled={isLoading}
                >
                {isLoading ? 'Loading...' : 'Load'}
              </button>
              <button
                  className={clsx(classButtonBase, 'bg-green-200 text-green-800 hover:bg-green-300')}
                  onClick={() => {
                    if (!isLoading) {
                      setShowTokenPopup(true);
                    }
                  }}
                  disabled={isLoading}
                >
                Change
              </button>
            </div>
            <div className={clsx('flex', 'items-start', 'items-baseline')}>
              <span
                className={clsx(
                  'inline-block',
                  'text-sm',
                  'text-gray-600',
                  'w-30',
                  'flex-shrink-0',
                  'font-medium',
                  'pt-2'
                )}
              >
                Repository
              </span>
              <DropdownCombobox placeholder={"Select Repository"}/>
              <button
                className={clsx(classButtonBase, 'bg-blue-200 text-blue-800 hover:bg-blue-300')}
                onClick={() => {
                  if (!isLoading) {
                    handleLoadUserId();
                  }
                }}
                disabled={isLoading}
              >
                {isLoading ? 'Loading...' : 'Load'}
              </button>
              <button
                  className={clsx(classButtonBase, 'bg-green-200 text-green-800 hover:bg-green-300')}
                  onClick={() => {
                    if (!isLoading) {
                      setShowTokenPopup(true);
                    }
                  }}
                  disabled={isLoading}
                >
                Change
              </button>
            </div>
          </div>
        </div>
        <div className={classRightPanelArea}>
          <button
            onClick={() => setIsRightPanelCollapsed(!isRightPanelCollapsed)}
            className={classHideButton}
            title="Hide"
          >
            <span className="text-gray-600 text-3xl transition-transform duration-200">
              {isRightPanelCollapsed ? (
                <MdKeyboardDoubleArrowLeft />
              ) : (
                <MdKeyboardDoubleArrowRight />
              )}
            </span>
          </button>
          <div className={classRightPanel}>
            <div className="w-full min-h-10"></div>
            <EpisodePannel />
          </div>
        </div>
      </div>
      {/* Token Input Popup */}
      <TokenInputPopup
        isOpen={showTokenPopup}
        onClose={() => setShowTokenPopup(false)}
        onSubmit={handleTokenSubmit}
        isLoading={isLoading}
      />
    </div>
  );
}
function ControlCombobox() {
  
  
}

function DropdownCombobox({placeholder, dataList, initItem}) {
  const sourceItems = dataList;
  const [inputItems, setInputItems] = useState(dataList || []);
  const [selectedItem, setSelectedItem] = useState(initItem || null);
  function handleSelectedItemChange({selectedItem}) {
    setSelectedItem(selectedItem)
  };
  const {
    isOpen,
    getToggleButtonProps,
    getInputProps,
    getItemProps,
  } = useCombobox({
    items: inputItems,
    selectedItem,
    onSelectedItemChange: handleSelectedItemChange,
    onInputValueChange: ({inputValue}) => {
      setInputItems(
        sourceItems.filter((item) =>
          item.toLowerCase().includes(inputValue.toLowerCase()),
        ),
      )
    },
  })
  return (
    <div>
      <div className="flex shadow-sm bg-white gap-0.5">
        <input placeholder={placeholder} className="w-full p-1.5" {...getInputProps()} />
        <button
          type="button"
          {...getToggleButtonProps()}
          aria-label="toggle menu"
        >
          <div className="py-2 px-3">
            <FiChevronDown/>
          </div>
        </button>
      </div>
      <ul >
        {isOpen &&
          inputItems.map((item, index) => (
            <li
              className={clsx(
                  selectedItem === item && 'font-bold',
                  'py-2 px-3 shadow-sm flex flex-col',
                )}
              key={`${item}${index}`}
              {...getItemProps({item, index})}
            >
              {item}
            </li>
          ))}
      </ul>
    </div>
  )
}