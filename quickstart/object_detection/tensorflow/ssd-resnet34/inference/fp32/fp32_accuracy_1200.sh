#!/usr/bin/env bash
#
# Copyright (c) 2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

MODEL_DIR=${MODEL_DIR-$PWD}

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The required environment variable OUTPUT_DIR has not been set"
  exit 1
fi

# Create the output directory in case it doesn't already exist
mkdir -p ${OUTPUT_DIR}

if [ -z "${DATASET_DIR}" ]; then
  echo "The required environment variable DATASET_DIR has not been set"
  exit 1
fi

if [ ! -d "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

FROZEN_GRAPH=${FROZEN_GRAPH-"$MODEL_DIR/pretrained_model/ssd_resnet34_fp32_1200x1200_pretrained_model.pb"}

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
    --data-location $DATASET_DIR \
    --in-graph $FROZEN_GRAPH \
    --model-source-dir $TF_MODELS_DIR \
    --model-name ssd-resnet34 \
    --framework tensorflow \
    --precision fp32 \
    --mode inference \
    --socket-id 0 \
    --batch-size 1 \
    --accuracy-only \
    $@ \
    -- input-size=1200
