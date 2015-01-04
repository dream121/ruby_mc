class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :download, :destroy]
  before_action :set_parent
  before_action :set_admin
  after_filter :verify_authorized

  include DocumentsHelper

  def new
    @document = @parent.documents.build
    authorize(@document)
  end

  def edit
  end

  def download
    track_event 'documents.enrolled.download', course: @parent.title, document: @document.title
    redirect_to @document.document.expiring_url(10)
  end

  def create
    @document = @parent.documents.build(document_params)
    authorize(@document)

    if @document.save
      redirect_to @parent, notice: 'Document was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @document.update(document_params)
      redirect_to @parent, notice: 'Document was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @document.destroy
    redirect_to @parent, notice: 'Document was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
      authorize(@document)
    end

    # Only allow a trusted parameter "white list" through.
    def document_params
      params.require(:document).permit(:kind, :title, :document, :url)
    end
end
