class DynamicForms::FormSubmissionsController < ApplicationController
  before_action :load_form

  def index
    @form_submissions = @form.form_submissions
    render :template => "form_submissions/index"
  end

  def show
    @form_submission = @form.form_submissions.find(params[:id])
    @submitted = (params[:submitted] ? true : false)
    render :template => "form_submissions/show"
  end

  def new
    @form_submission = @form.form_submissions.build
    render :template => "form_submissions/new"
  end

  def create
    @form_submission = @form.form_submissions.submit(form_submission_params)
    if !@form_submission.new_record?
      flash[:success] = translate(:submission_created, :scope => [:dynamic_forms, :controllers, :form_submissions])
      if @form.email_submissions? && !@form.email.blank?
        ::DynamicFormsMailer.form_submission(@form_submission).deliver_now
      end
      redirect_to form_form_submission_path(@form, @form_submission, :submitted => true)
    else
      render :action => 'new', :template => "form_submissions/new"
    end
  end

  private

  def form_submission_params
    # Field names are dynamic, so we permit everything under :form_submission.
    # The host app can restrict further if needed.
    params.require(:form_submission).permit!
  end

  def load_form
    @form = ::Form.find(params[:form_id])
  end

end
