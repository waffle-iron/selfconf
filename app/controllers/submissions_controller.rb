class SubmissionsController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    if user_signed_in?
      @submissions = current_user.submissions.unselected.where(event_id: @event)
      @talks = current_user.submissions.selected
    end
  end

  def show
    @submission = Submission.find(params[:id])
    authorize(@submission, :show?)
  end

  def new
    @submission = @event.submissions.build(users: [current_user])
  end

  def edit
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def create
    @submission = @event.submissions.build(submission_params.merge(users: [current_user]))
    if @submission.save
      flash[:success] = "Talk submitted!"
      redirect_to submissions_path
    else
      render 'new'
    end
  end

  def update
    @submission = Submission.find(params[:id])
    authorize @submission
    if @submission.update_attributes(submission_params)
      @submissions.votes.destroy_all
      flash[:success] = "Submission updated!"
      redirect_to submissions_path
    else
      render 'edit'
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    authorize @submission
    if @submission.destroy
      flash[:success] = "Submission destroyed."
    else
      flash[:danger] = "Submission could not be destroyed, please try again."
    end
    redirect_to submissions_path
  end

  private

  def submission_params
    params.require(:submission).permit(:name, :abstract, :talktype, :notes)
  end
end
