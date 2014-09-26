--[[
Copyright 2014 Rackspace

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--]]
local ConnectionStream = require("/base/client/connection_stream").ConnectionStream

local logging = require('logging')
local loggingUtil = require('/base/util/logging')
local fmt = require('string').format

local Stream = ConnectionStream:extend()
function Stream:initialize(id, token, guid, upgradeEnabled, options, types)
  ConnectionStream.initialize(self, id, token, guid, upgradeEnabled, options, types)
  self._log = loggingUtil.makeLogger('agent')
end

function Stream:_createConnection(options)
  local client = ConnectionStream._createConnection(self, options)
  client:on('error', function(err)
    self._log(logging.DEBUG, tostring(err))
  end)
  return client
end

local exports = {}
exports.Stream = Stream
return exports
