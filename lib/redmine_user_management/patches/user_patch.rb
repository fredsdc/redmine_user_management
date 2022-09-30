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

module RedmineUserManagement
  module Patches
    module UserPatch
      def self.included(base)
        base.class_eval do
          has_many :user_manager_users, :foreign_key => 'principal_id', :dependent => :delete_all
        end
      end
    end
  end
end

unless User.included_modules.include?(RedmineUserManagement::Patches::UserPatch)
  User.send(:include, RedmineUserManagement::Patches::UserPatch)
end
