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
import TaskInstructionInput from './TaskInstructionInput';
import toast from 'react-hot-toast';
import { useRosServiceCaller } from '../hooks/useRosServiceCaller';
import TagInput from './TagInput';
import TokenInputPopup from './TokenInputPopup';
import TaskPhase from '../constants/taskPhases';
import { setTaskInfo, setUseMultiTaskMode } from '../features/tasks/taskSlice';
import { useCombobox } from "downshift";

const EpisodePanel = () => {
  const dispatch = useDispatch();
    const taskInfos = [
  {
    taskName: 'Task 1',
    robotType: 'Type A',
    taskType: 'Type X',
    taskInstruction: 'Do X',
    userId: 'repo1',
    fps: 30,
    tags: ['tag1'],
    warmupTime: '10',
    episodeTime: '60',
    resetTime: '5',
    numEpisodes: 3,
    pushToHub: false,
  },]
  const info = useSelector((state) => state.tasks.taskInfo);
  const taskStatus = useSelector((state) => state.tasks.taskStatus);

  const [isTaskStatusPaused, setIsTaskStatusPaused] = useState(false);
  const [lastTaskStatusUpdate, setLastTaskStatusUpdate] = useState(Date.now());

  const useMultiTaskMode = useSelector((state) => state.tasks.useMultiTaskMode);

  const [showPopup, setShowPopup] = useState(false);
  const [taskInfoList] = useState(taskInfos);
  const disabled = taskStatus.phase !== TaskPhase.READY || !isTaskStatusPaused;
  const [isEditable, setIsEditable] = useState(!disabled);

  // User ID list for dropdown
  const [userIdList, setUserIdList] = useState([]);

  // Token popup states
  const [showTokenPopup, setShowTokenPopup] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // User ID selection states
  const [showUserIdDropdown, setShowUserIdDropdown] = useState(false);

  const { registerHFUser, getRegisteredHFUser } = useRosServiceCaller();

  const handleChange = useCallback(
    (field, value) => {
      if (!isEditable) return; // Block changes when not editable
      dispatch(setTaskInfo({ ...info, [field]: value }));
    },
    [isEditable, info, dispatch]
  );

  const handleSelect = (selected) => {
    dispatch(setTaskInfo(selected));
    setShowPopup(false);
  };

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
          setShowUserIdDropdown(true);
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

  const handleUserIdSelect = useCallback(
    (selectedUserId) => {
      handleChange('userId', selectedUserId);
      setShowUserIdDropdown(false);
    },
    [handleChange]
  );

  // Update isEditable state when the disabled prop changes
  useEffect(() => {
    setIsEditable(!disabled);
  }, [disabled]);

  // Reset dropdown state when Push to Hub is unchecked
  useEffect(() => {
    if (!info.pushToHub) {
      setShowUserIdDropdown(false);
    }
  }, [info.pushToHub]);

  // Auto-enable optimized save when multi-task mode is enabled
  useEffect(() => {
    if (useMultiTaskMode && !info.useOptimizedSave) {
      dispatch(setTaskInfo({ ...info, useOptimizedSave: true }));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [useMultiTaskMode, info.useOptimizedSave, dispatch]);

  useEffect(() => {
    handleLoadUserId();
  }, [handleLoadUserId]);

  useEffect(() => {
    if (userIdList.length > 0 && info.userId === undefined) {
      handleUserIdSelect(userIdList[0]);
    }
  }, [userIdList, info.userId, handleUserIdSelect]);

  // track task status update
  useEffect(() => {
    if (taskStatus) {
      setLastTaskStatusUpdate(Date.now());
      setIsTaskStatusPaused(false);
    }
  }, [taskStatus]);

  // Check if task status updates are paused (considered paused if no updates for 1 second)
  useEffect(() => {
    const UPDATE_PAUSE_THRESHOLD = 1000;
    const timer = setInterval(() => {
      const timeSinceLastUpdate = Date.now() - lastTaskStatusUpdate;
      const isPaused = timeSinceLastUpdate >= UPDATE_PAUSE_THRESHOLD;
      if (isPaused !== isTaskStatusPaused) {
        setIsTaskStatusPaused(isPaused);
      }
    }, 1000);

    return () => clearInterval(timer);
  }, [lastTaskStatusUpdate, isTaskStatusPaused]);

  const classEpisodePanel = clsx(
    'bg-white',
    'border',
    'border-gray-200',
    'rounded-2xl',
    'shadow-md',
    'p-4',
    'w-full',
    'max-w-[300px]',
    'relative',
    'overflow-y-auto',
    'scrollbar-thin'
  );

  return (
    <div className={classEpisodePanel}>
      <div className={clsx('text-lg', 'font-semibold', 'mb-3', 'text-gray-800')}>
        EPISODE
      </div>
      <div className={clsx('flex', 'items-start', 'mb-2.5')}>
 
      </div>

    </div>
  );
};

export default EpisodePanel;