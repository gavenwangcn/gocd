##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'spec_helper'

describe ApiV3::Plugin::PluginInfosRepresenter do
  it 'renders all plugin_infos with hal representation' do
    vendor = GoPluginDescriptor::Vendor.new('bob', 'https://bob.example.com')
    about = GoPluginDescriptor::About.new('Foo plugin', '1.2.3', '17.2.0', 'Does foo', vendor, ['Linux'])
    descriptor = GoPluginDescriptor.new('foo.example', '1.0', about, nil, nil, false)

    plugin_info = com.thoughtworks.go.server.ui.plugins.AuthenticationPluginInfo.new(descriptor)

    actual_json = ApiV3::Plugin::PluginInfosRepresenter.new([plugin_info]).to_hash(url_builder: UrlBuilder.new)

    expect(actual_json).to have_links(:self, :doc, :find)
    expect(actual_json).to have_link(:self).with_url('http://test.host/api/admin/plugin_info')
    expect(actual_json).to have_link(:doc).with_url('https://api.gocd.io/#plugin-info')
    expect(actual_json).to have_link(:find).with_url('http://test.host/api/admin/plugin_info/:plugin_id')
    actual_json.delete(:_links)
    actual_json.fetch(:_embedded).should == {plugin_info: [ApiV3::Plugin::PluginInfoRepresenter.new(plugin_info).to_hash(url_builder: UrlBuilder.new)]}
  end
end
