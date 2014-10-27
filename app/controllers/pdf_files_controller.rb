class PdfFilesController < ApplicationController
  require 'pdf_documents/pdf'

  before_action :get_user_document, :only => [:generate]
  before_action :get_user_documents, :only => [:index, :welcome]

  def index
    @file_names = Dir.glob("documents/pdf/#{current_user.id}/*.pdf")
  end

  def welcome
  end

  def generate
    PdfDocument::Pdf.new.generate @document
    @document.update :is_generated => true
    redirect_to pdf_files_path, :notice => 'Document complete'
  end

  def download
    current_user.create_mail_reminder! MailForm::REMINDER_TYPE.first
    if current_user.documents.where(:id => params[:filename].split('_').last.try(:to_i) || 0).exists?
      send_file "documents/pdf/#{ params[:filename] }.pdf", :type => "application/pdf", :x_sendfile => true
    else
      redirect_to pdf_files_path
    end
  end

  private
  def get_user_document
    @document = current_user.documents.find(params[:document_id])
  end

  def get_user_documents
    @documents = current_user.documents
  end
end
