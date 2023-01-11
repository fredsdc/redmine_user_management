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

Redmine::Plugin.register :redmine_user_management do
  name 'Redmine User Management plugin'
  author 'Frederico Camara'
  description 'Allows some users to manage non-admin users, status and groups'
  version '1.0'
  url 'http://github.com/fredsdc/redmine_user_management'
  author_url 'http://github.com/fredsdc'

  menu :admin_menu, :user_managers, { controller: 'user_managers', action: 'index'},
    caption: :label_user_manager_plural, html: { class: 'icon icon-user_managers'}

  menu :top_menu, :user_managements, { controller: 'user_managements', action: 'index' }, caption: :label_user_plural,
    if: Proc.new { User.current.admin? || UserManager.all.map {|u| u.principals.map { |p| p.type=="User" ? p.id : p.users.ids}}.flatten.include?(User.current.id) }
end
