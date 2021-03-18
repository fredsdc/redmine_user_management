# Redmine User Managerment - A Redmine Plugin
# Copyright (C) 2021  Frederico Camara
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require_dependency 'user_custom_field'
require_dependency 'group'
require_dependency 'user'

class CustomField
  unloadable
  has_many :user_manager_ucfs, :dependent => :delete_all
end

class Group
  unloadable
  has_many :user_manager_groups, :dependent => :delete_all
  has_many :user_manager_users, :dependent => :delete_all
end

class Principal
  unloadable
  has_many :user_manager_users, :dependent => :delete_all
end
