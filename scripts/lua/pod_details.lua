--
-- (C) 2013-20 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path

require "lua_utils"
require "graph_utils"

local page_utils = require("page_utils")
local format_utils = require("format_utils")

local pod            = _GET["pod"]
local page           = _GET["page"]

interface.select(ifname)
local ifId = getInterfaceId(ifname)

sendHTTPContentTypeHeader('text/html')

page_utils.set_active_menu_entry(page_utils.menu_entries.pods)

dofile(dirs.installdir .. "/scripts/lua/inc/menu.lua")

if(pod == nil) then
    return
end

if(not areContainersTimeseriesEnabled(ifId)) then
    print("<div class=\"alert alert alert-danger\"><img src=".. ntop.getHttpPrefix() .. "/img/warning.png> " .. i18n("no_data_available") .. "</div>")
    return
end

--[[
Create Menu Bar with buttons
--]]
local nav_url = ntop.getHttpPrefix().."/lua/pod_details.lua?pod="..pod
local title = i18n("containers_stats.pod") .. ": "..pod
page_utils.print_navbar(title, nav_url,
			{
			   {
			      active = page == "historical" or not page,
			      page_name = "historical",
			      label = "<i class='fas fa-lg fa-chart-area'></i>",
			   },
			}
)

--[[
Selectively render information pages
--]]
if page == "historical" then
  local schema = _GET["ts_schema"] or "pod:num_flows"
  local selected_epoch = _GET["epoch"] or ""
  local url = ntop.getHttpPrefix()..'/lua/pod_details.lua?pod='..pod..'&page=historical'

  local tags = {
    ifid = ifId,
    pod = pod,
  }

  drawGraphs(ifId, schema, tags, _GET["zoom"], url, selected_epoch, {
    timeseries = {
      {schema="pod:num_flows",             label=i18n("graphs.active_flows")},
      {schema="pod:num_containers",        label=i18n("containers_stats.containers")},
      {schema="pod:rtt",                   label=i18n("containers_stats.avg_rtt")},
      {schema="pod:rtt_variance",          label=i18n("containers_stats.avg_rtt_variance")},
    }
  })
end

dofile(dirs.installdir .. "/scripts/lua/inc/footer.lua")
