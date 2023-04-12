# frozen_string_literal: true

class V1::Users::AnswersController < V1::Users::BaseController
  before_action :set_answer, only: %i(update destroy)

  def index
    answers = current_user.answers
    answers = Answer.by_user(params[:user_id]) if params[:user_id].present?

    paginate(collection: answers)
  end

  def create
    question = Question.find(params[:question_id])
    @answer = question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def set_answer
    @answer = current_user.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:text, :image)
  end
end
