#
# Cookbook Name:: portage
# Recipe:: default
#
# Copyright 2009, Gábor Vészi
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
#

directory '/etc/portage' do
  owner 'root'
  group 'portage'
  mode 0770
end

%w(keywords mask unmask use).each do |d|
  bash "convert_package_#{d}_to_file" do
    only_if { File.file?("/etc/portage/package.#{d}") }
    user 'root'
    cwd '/etc/portage'
    code <<-EOC
    mv package.#{d} _package.#{d}
    mkdir package.#{d}
    sort -n _package.#{d} | uniq | egrep -v '^\s*(\#|$)' | while read LINE
    do
      echo "$LINE" > package.#{d}/$(echo ${LINE} | sed 's, .*$,,' | \
        sed 's,[\./],-,g' | sed -r 's,[^a-z0-9_\-],,g')
    done
    rm _package.#{d}
    EOC
  end

  directory "/etc/portage/package.#{d}" do
    owner 'root'
    group 'portage'
    mode 0770
  end
end
