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

class UserManagersController < ApplicationController
  layout 'admin'
  self.main_menu = false

  before_action :require_admin

  def index
    @user_managers = UserManager.all.select(:id, :name, :description).to_a
  end

  def new
    @user_manager = UserManager.new
    find_user_manager
  end

  def create
    @user_manager = UserManager.new
    @user_manager.safe_attributes = params[:user_manager]
    if @user_manager.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to edit_user_manager_path @user_manager
    else
      find_user_manager
      render :action => 'new'
    end
  end

  def edit
    @user_manager = UserManager.find(params[:id])
    find_user_manager
  end

  def update
    @user_manager = UserManager.find(params[:id])
    @user_manager.safe_attributes = params[:user_manager]
    if @user_manager.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to edit_user_manager_path @user_manager
    else
      find_user_manager
      render :action => 'edit'
    end
  end

  def destroy
    @user_manager = UserManager.find(params[:id]).destroy
    redirect_to user_managers_path
  end

  def autocomplete
    if params[:term].present?
      scope = Principal.where(type: "User").preload(:email_address).like(params[:term]) +
              Principal.where(type:"Group").like(params[:term])
    else
      scope = []
    end
    render :json => scope.collect{|p| {'id' => p.id, 'label' => p.name, 'value' => p.name}}
  end

  private

  def find_user_manager
    @users = @user_manager.principals.map{|x| [x.id, x.name]}
    @user_custom_fields = UserCustomField.all.map{|x| [x.id, x.name, @user_manager.user_custom_field_ids.include?(x.id)]}
    @groups = Group.sorted.select{|g| ! g.builtin?}.map{|x| [x.id, x.name, @user_manager.group_ids.include?(x.id)]}
  end
end
