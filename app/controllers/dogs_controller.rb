class DogsController < ApplicationController
  before_action :require_login
  before_action :set_dog, only: [ :edit, :update, :destroy ]

  def new
    @dog = Dog.new
  end

  def create
    @dog = current_user.dogs.new(dog_params)
    if @dog.save
      redirect_to mypage_path, notice: "愛犬を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @dog.update(dog_params)
      redirect_to mypage_path, notice: "愛犬情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dog.destroy
    redirect_to mypage_path, notice: "愛犬情報を削除しました"
  end

  private

  def dog_params
    params.require(:dog).permit(:name, :breed, :size, :birthday, :gender, :image)
  end

  def set_dog
    @dog = current_user.dogs.find(params[:id])
  end
end
