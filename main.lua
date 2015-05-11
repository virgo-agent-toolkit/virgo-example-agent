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
local path = require('path')
local los = require('los')

local function run(...)
  local client = require('./client')
  local Emitter = require('core').Emitter
  local Endpoint = require('virgo/client').Endpoint

  local Agent = Emitter:extend()
  function Agent:initialize(options, types)
    self.options = options
    self.id = options.id or 'agentA'
    self.token = options.token or 'tokenA'
    self.guid = options.guid or 'guidA'
    self.types = types
    self.streams = nil
    self.endpoints = {
      Endpoint:new('127.0.0.1', '50041'),
      Endpoint:new('127.0.0.1', '50042'),
      Endpoint:new('127.0.0.1', '50043'),
    }
  end
  
  function Agent:connect(callback)
    local connectionStreamType = self.types.ConnectionStream
    self.streams = connectionStreamType:new(self.id,
                                            self.token,
                                            self.guid,
                                            false,
                                            self.options,
                                            self.types)
    self.streams:createConnections(self.endpoints, callback)
  end

  local agent = Agent:new({}, {
    ['AgentClient'] = client.client.Client,
    ['ConnectionStream'] = client.stream.Stream,
  })
  agent:connect()
end

return require('luvit')(function()
  local options = {}
  options.version = require('./package').version
  options.pkg_name = "example"
  options.creator_name = "Example Agent"
  options.long_pkg_name = options.creator_name .. " Agent"
  options.paths = {}
  if los.type() == 'win32' then
    local winpaths = require('virgo/util/win_paths')
    options.paths.persistent_dir = path.join(winpaths.GetKnownFolderPath(winpaths.FOLDERID_ProgramData), options.creator_name)
    options.paths.exe_dir = path.join(options.paths.persistent_dir, "exe")
    options.paths.config_dir = path.join(options.paths.persistent_dir, "config")
    options.paths.library_dir = path.join(winpaths.GetKnownFolderPath(winpaths.FOLDERID_ProgramFiles), options.creator_name)
    options.paths.runtime_dir = options.paths.persistent_dir
  else
    options.paths.persistent_dir = "/var/lib/example_agent"
    options.paths.exe_dir = options.paths.persistent_dir .. "/exe"
    options.paths.config_dir = "/etc"
    options.paths.library_dir = "/usr/lib/example_agent"
    options.paths.runtime_dir = "/tmp"
  end
  options.paths.current_exe = args[0]
  require('virgo')(options, run)
end)
