class DynamicForms::FormsController < ApplicationController
  def index
    @forms = ::Form.paginate(:page => params[:page] || 1)
    render :template => "forms/index"
  end

  # the Forms#show action actually renders FormSubmissions#new for displaying the form
  def show
    @form = ::Form.find(params[:id])
    @form_submission = @form.form_submissions.build
    render :template => 'form_submissions/new'
  end

  def new
    @form = ::Form.new(:submit_label => 'Submit')
    render :template => "forms/new"
  end

  def edit
    @form = ::Form.find(params[:id])
    render :template => "forms/edit"
  end

  def create
    # check to see if preview should be rendered rather than saving changes
    preview_new and return if params[:commit].to_s.downcase == 'preview'

    @form = ::Form.new(form_params)
    if @form.save
      flash[:success] = translate(:form_created, :scope => [:dynamic_forms, :controllers, :forms], :name => @form.name)
      redirect_to form_path(@form)
    else
      render :action => 'new', :template => "forms/new"
    end
  end

  def update
    # check to see if preview should be rendered rather than saving changes
    preview_edit and return if params[:commit].to_s.downcase == 'preview'

    @form = ::Form.find(params[:id])

    if @form.update(form_params)
      flash[:success] = translate(:form_updated, :scope => [:dynamic_forms, :controllers, :forms], :name => @form.name)
      redirect_to form_path(@form)
    else
      render :action => 'edit', :template => "forms/edit"
    end
  end

  def destroy
    form = ::Form.find(params[:id])
    form.destroy
    flash[:success] = translate(:form_deleted, :scope => [:dynamic_forms, :controllers, :forms], :name => form.name)
    redirect_to forms_path
  end

  private

  def form_params
    params.require(:form).permit(
      :name, :submit_label, :email, :email_submissions, :instructions, :confirmation, :active,
      form_fields_attributes: [
        :id, :label, :type, :sti_type, :position, :_destroy,
        form_field_options_attributes: [:id, :label, :value, :position, :_destroy]
      ]
    )
  end

  def preview_new
    @form = ::Form.new(form_params)
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'new', :template => "forms/new"
  end

  def preview_edit
    @form = ::Form.new(form_params)
    @form.id = params[:id]
    if @form.valid?
      @form_submission = @form.form_submissions.build
      @form_submission.form = @form # Believe it or not, this is necessary
    end
    render :action => 'edit', :template => "forms/edit"
  end

end
