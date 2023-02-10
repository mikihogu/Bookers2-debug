class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @groups = Group.all
    # @group = Group.find_by(params[:id])
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path, notice: 'New group has been created successfully.'
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path, notice: 'Group has been updated successfully.'
    else
      render :edit
    end
  end

  def join
    @group = Group.find(params[:id])
    unless @group.users.include?(current_user)
      @group.users << current_user
      redirect_to groups_path
    end
  end

  def leave
    @group = Group.find(params[:id])
    if @group.users.include?(current_user)
      @group.users.destroy(current_user)
      redirect_to groups_path
    end
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
